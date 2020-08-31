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
            <%= f = form_for @changeset, "#", [phx_target: @myself, phx_save: "save"] %>
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
                <%= label f, :category_id, "Category", [class: "form-label"] %>
                <%= select f, :category_id, [], [class: "form-select"] %>
                <%= error_tag f, :category_id %>
              </div>
            </form>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-success">
            <i class="icon icon-plus"></i>
            Create the todo
          </button>
          <button phx-click="close" phx-target="<%= @myself %>" class="btn btn-error" type="button">
            <i class="icon icon-cross"></i>
            Cancel
          </button>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    categories = Todos.list_todos_categories()
    changeset = Todos.change_todo(%Todo{})

    {:ok,
     assign(socket,
       categories: categories,
       changeset: changeset
     )}
  end

  @impl true
  def handle_event("close", _params, socket) do
    send(self(), {__MODULE__, :close})
    {:noreply, socket}
  end
end
