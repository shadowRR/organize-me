defmodule OrganizeMeWeb.Todos.TodoCardLive do
  use OrganizeMeWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div data-id="<%= @todo.id %>" class="tile tile-centered p-1">
      <div class="tile-content">
        <div class="tile-title text-ellipsis">
          <%= @todo.name %>
        </div>
        <div class="tile-subtitle">
          <%= with category <- get_related_category(@todo, @todos_categories) do %>
            <div class="label label-rounded text-uppercase"
                style="font-size: 0.5rem; color: white; background: <%= category.color %>;">
              <%= category.name %>
            </div>
          <% end %>
        </div>
      </div>
      <div class="tile-action">
        <button phx-click="open-todo-modal" phx-value-todo="<%= @todo.id %>" class="btn btn-sm btn-link">
          <i class="icon icon-edit"></i>
        </button>
      </div>
    </div>
    """
  end

  defp get_related_category(todo, categories) do
    Enum.find(categories, &(&1.id == todo.todo_category_id))
  end
end
