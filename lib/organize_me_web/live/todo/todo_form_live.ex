defmodule OrganizeMeWeb.TodoFormLive do
  use OrganizeMeWeb, :live_component

  alias OrganizeMe.Todos
  alias OrganizeMe.Todos.Todo
  alias OrganizeMeWeb.TodoCategoryFormLive

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
              <%= unless @toggle_form_category do %>
                <div class="form-group">
                  <%= label f, :category_id, "Category", [class: "form-label"] %>
                  <div class="input-group">
                    <%= select f, :category_id, [], [class: "form-select"] %>
                    <button phx-click="toggle-category" phx-target="<%= @myself %>"
                      class="btn btn-success input-group-btn" type="button">
                      <i class="icon icon-plus"></i>
                    </button>
                  </div>
                  <%= error_tag f, :category_id %>
                </div>
              <% else %>
                <%= live_component @socket, TodoCategoryFormLive, [
                  id: "todo-category-form"
                ] %>
              <% end %>
            </form>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-success">
            <i class="icon icon-plus"></i>
            Create the todo
          </button>
          <button phx-click="close" phx-target="<%= @myself %>" class="btn btn-error">
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
    toggle_form_category = false

    {:ok,
     assign(socket,
       categories: categories,
       changeset: changeset,
       toggle_form_category: toggle_form_category
     )}
  end

  @impl true
  def handle_event("toggle-category", _params, socket) do
    toggle_form_category = true
    {:noreply, assign(socket, toggle_form_category: toggle_form_category)}
  end

  @impl true
  def handle_event("close", _params, socket) do
    send(self(), {__MODULE__, :close})
    {:noreply, socket}
  end
end
