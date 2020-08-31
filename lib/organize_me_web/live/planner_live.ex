defmodule OrganizeMeWeb.PlannerLive do
  use OrganizeMeWeb, :live_view

  alias OrganizeMe.Todos
  alias OrganizeMeWeb.TodoFormLive

  @impl true
  def mount(_params, session, socket) do
    todos_categories = Todos.list_todos_categories()
    socket = assign_defaults(session, socket)

    {:ok,
     assign(socket,
       open_todo_modal: false,
       todos_categories: todos_categories
     )}
  end

  @impl true
  def handle_event("open-todo-modal", _params, socket) do
    {:noreply, assign(socket, open_todo_modal: true)}
  end

  @impl true
  def handle_info({TodoFormLive, :close}, socket) do
    {:noreply, assign(socket, open_todo_modal: false)}
  end

  @impl true
  def handle_info({TodoCategoryFormLive, :todo_category_created, category}, socket) do
    {:noreply, assign(socket, todos_categories: [category] ++ socket.assigns.todos_categories)}
  end
end
