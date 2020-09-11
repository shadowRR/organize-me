defmodule OrganizeMeWeb.TodoFormLive do
  use OrganizeMeWeb, :live_component

  alias OrganizeMe.Todos
  alias OrganizeMe.Todos.Todo

  @impl true
  def render(assigns) do
    ~L"""
    <div class="modal active">
      <a phx-click="close" phx-target="<%= @myself %>" class="modal-overlay"></a>
      <div class="modal-container">
        <div class="modal-header">
          <a phx-click="close" phx-target="<%= @myself %>" class="btn btn-clear float-right"></a>
          <div class="modal-title h5">Add a Todo</div>
        </div>
        <div class="modal-body">
          <div class="content">
            <%= f = form_for @changeset, "#", [phx_change: "validate", phx_target: @myself, phx_submit: "save"] %>
              <div class="form-group">
                <%= label f, :name, "Name", [class: "form-label"] %>
                <%= text_input f, :name, [class: "form-input"] %>
                <%= error_tag f, :name %>
              </div>
              <div class="form-group">
                <%= label f, :description, "Description", [class: "form-label"] %>
                <%= textarea f, :description, [class: "form-input"] %>
                <%= error_tag f, :description %>
              </div>
              <div class="form-group">
                <%= label f, :todo_category_id, "Category", [class: "form-label"] %>
                <%= select f, :todo_category_id, prepare_categories(@categories), [
                  class: "form-select",
                  prompt: "Select a category"
                ] %>
                <%= error_tag f, :todo_category_id %>
              </div>
              <%= if is_nil(@todo) do %>
                <%= submit [class: "btn btn-success"] do %>
                  <i class="icon icon-plus"></i>
                  Create the todo
                <% end %>
              <% else %>
                <%= submit [class: "btn btn-warning"] do %>
                  <i class="icon icon-edit"></i>
                  Sauvegarder
                <% end %>
              <% end %>
              <button phx-click="close" phx-target="<%= @myself %>" class="btn btn-error" type="button">
                <i class="icon icon-cross"></i>
                Cancel
              </button>
            </form>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    changeset =
      unless is_nil(assigns.todo),
        do: Todos.change_todo(%Todo{}, Map.from_struct(assigns.todo)),
        else: Todos.change_todo(%Todo{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(changeset: changeset)}
  end

  @impl true
  def handle_event("close", _params, socket) do
    send(self(), {__MODULE__, :close})
    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"todo" => attrs}, socket) do
    changeset =
      (socket.assigns.todo || %Todo{})
      |> Todos.change_todo(attrs)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"todo" => attrs}, %{assigns: %{todo: nil}} = socket) do
    case Todos.create_todo(socket.assigns.current_user, attrs) do
      {:ok, todo} ->
        changeset = Todos.change_todo(%Todo{})
        send(self(), {__MODULE__, :todo_created, todo})
        {:noreply, assign(socket, changeset: changeset)}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true
  def handle_event("save", %{"todo" => attrs}, %{assigns: %{todo: todo}} = socket) do
    case Todos.update_todo(todo, attrs) do
      {:ok, todo} ->
        send(self(), {__MODULE__, :todo_updated, todo})
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp prepare_categories(categories) do
    Enum.map(categories, &{&1.name, &1.id})
  end
end
