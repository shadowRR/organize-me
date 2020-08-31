defmodule OrganizeMeWeb.TodoCategoryFormLive do
  use OrganizeMeWeb, :live_component

  alias OrganizeMe.Todos
  alias OrganizeMe.Todos.TodoCategory

  @impl true
  def render(assigns) do
    ~L"""
    <div class="modal active">
      <a phx-click="close" phx-target="<%= @myself %>" class="modal-overlay"></a>
        <div class="modal-container">
          <div class="modal-header">
            <a phx-click="close" phx-target="<%= @myself %>" class="btn btn-clear float-right"></a>
            <div class="modal-title h5">Manage Todos Categories</div>
          </div>
          <div class="modal-body">
            <div class="content">
              <%= f = form_for @changeset, "#", [phx_target: @myself, phx_submit: "save"] %>
                <div class="columns">
                  <div class="column col-8">
                    <div class="form-group">
                      <%= label f, :name, "Name", [class: "form-label"] %>
                      <%= text_input f, :name, [class: "form-input"] %>
                      <%= error_tag f, :name %>
                    </div>
                  </div>
                  <div class="column col-3">
                    <div class="form-group">
                      <%= label f, :color, "Color", [class: "form-label"] %>
                      <%= color_input f, :color, [class: "form-input"] %>
                      <%= error_tag f, :color %>
                    </div>
                  </div>
                  <div class="column col-1" style="display: flex; align-items: flex-end;">
                    <%= submit [class: "btn btn-success"] do %>
                      <i class="icon icon-plus"></i>
                    <% end %>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    changeset = Todos.change_todo_category(%TodoCategory{})

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
  def handle_event("validate", %{"todo_category" => attrs}, socket) do
    changeset =
      (socket.assigns.changeset || %TodoCategory{})
      |> Todos.change_todo_category(attrs)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"todo_category" => attrs}, socket) do
    IO.puts "saving"
    case Todos.create_todo_category(attrs) do
      {:ok, category} ->
        send(self(), {__MODULE__, :todo_category_created, category})
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
