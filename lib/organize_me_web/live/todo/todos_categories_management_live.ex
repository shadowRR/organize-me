defmodule OrganizeMeWeb.TodosCategoriesManagementLive do
  use OrganizeMeWeb, :live_component

  alias OrganizeMeWeb.TodoCategoryFormLive

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
              <%= for category <- @categories do %>
                <div class="mb-1">
                  <%= live_component @socket, TodoCategoryFormLive, [
                    id: "todo-category-form-update-#{category.id}",
                    current_user: @current_user,
                    todo_category: category
                  ] %>
                </div>
              <% end %>
                <div class="mb-1">
                  <%= live_component @socket, TodoCategoryFormLive, [
                    id: "todo-category-form-create",
                    current_user: @current_user,
                    todo_category: nil
                  ] %>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("close", _params, socket) do
    send(self(), {__MODULE__, :close})
    {:noreply, socket}
  end
end
