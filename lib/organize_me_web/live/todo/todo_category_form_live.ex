defmodule OrganizeMeWeb.TodoCategoryFormLive do
  use OrganizeMeWeb, :live_component

  alias OrganizeMe.Todos
  alias OrganizeMe.Todos.TodoCategory

  @impl true
  def render(assigns) do
    ~L"""
    <%= f = form_for @changeset, "#", [phx_change: "validate", phx_target: @myself, phx_submit: "save"] %>
      <div class="columns">
        <div class="column col-8">
          <div class="form-group">
            <%= label f, :name, "Name", [class: "form-label"] %>
            <%= text_input f, :name, [class: "form-input"] %>
            <%= error_tag f, :name %>
          </div>
        </div>
        <div class="column col-2">
          <div class="form-group">
            <%= label f, :color, "Color", [class: "form-label"] %>
            <%= color_input f, :color, [class: "form-input"] %>
            <%= error_tag f, :color %>
          </div>
        </div>
        <div class="column col-2" style="display: flex; align-items: flex-end;">
          <%= submit [class: "btn btn-success"] do %>
            <i class="icon icon-plus"></i>
          <% end %>
        </div>
      </div>
    </form>
    """
  end

  @impl true
  def update(assigns, socket) do
    changeset = Todos.change_todo_category(%TodoCategory{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(
       todo_category: nil,
       changeset: changeset
      )}
  end

  @impl true
  def handle_event("validate", %{"todo_category" => attrs}, socket) do
    changeset =
      (socket.assigns.todo_category || %TodoCategory{})
      |> Todos.change_todo_category(attrs)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"todo_category" => attrs}, socket) do
    IO.puts "saving"
    case Todos.create_todo_category(attrs) do
      {:ok, todo_category} ->
        changeset = Todos.change_todo_category(%TodoCategory{})
        send(self(), {__MODULE__, :todo_category_created, todo_category})
        {:noreply, assign(socket, changeset: changeset)}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
