defmodule OrganizeMeWeb.PlannerLive do
  use OrganizeMeWeb, :live_view

  alias OrganizeMe.Todos
  alias OrganizeMeWeb.TodoFormLive
  alias OrganizeMeWeb.TodoCategoryFormLive
  alias OrganizeMeWeb.TodosCategoriesManagementLive

  @impl true
  def mount(_params, session, socket) do
    todos_categories = Todos.list_todos_categories()
    socket = assign_defaults(session, socket)

    {:ok,
     assign(socket,
       open_todo_modal: false,
       open_todo_categories_modal: false,
       todos_categories: todos_categories
     )}
  end

  @impl true
  def handle_event("open-todo-modal", _params, socket) do
    {:noreply, assign(socket, open_todo_modal: true)}
  end

  @impl true
  def handle_event("open-todo-categories-modal", _params, socket) do
    {:noreply, assign(socket, open_todo_categories_modal: true)}
  end

  @impl true
  def handle_info({TodoFormLive, :close}, socket) do
    {:noreply, assign(socket, open_todo_modal: false)}
  end

  @impl true
  def handle_info({TodosCategoriesManagementLive, :close}, socket) do
    {:noreply, assign(socket, open_todo_categories_modal: false)}
  end

  @impl true
  def handle_info({TodoCategoryFormLive, :todo_category_created, category}, socket) do
    {:noreply, assign(socket, todos_categories: [category] ++ socket.assigns.todos_categories)}
  end

  @impl true
  def handle_info({TodoCategoryFormLive, :todo_category_updated, category}, socket) do
    idx = Enum.find_index(socket.assigns.todos_categories, & &1.id == category.id)
    todos_categories = List.replace_at(socket.assigns.todos_categories, idx, category)
    {:noreply, assign(socket, todos_categories: todos_categories)}
  end

  @impl true
  def handle_info({TodoCategoryFormLive, :todo_category_deleted, category}, socket) do
    idx = Enum.find_index(socket.assigns.todos_categories, & &1.id == category.id)
    todos_categories = List.delete_at(socket.assigns.todos_categories, idx)
    {:noreply, assign(socket, todos_categories: todos_categories)}
  end
end
