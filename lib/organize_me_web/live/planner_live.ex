defmodule OrganizeMeWeb.PlannerLive do
  use OrganizeMeWeb, :live_view

  alias OrganizeMe.Todos
  alias OrganizeMeWeb.TodoFormLive
  alias OrganizeMeWeb.TodoCategoryFormLive
  alias OrganizeMeWeb.TodosCategoriesManagementLive

  @impl true
  def mount(_params, session, socket) do
    todos = Todos.list_todos()
    todos_categories = Todos.list_todos_categories()
    socket = assign_defaults(session, socket)

    {:ok,
     assign(socket,
       open_todo_modal: false,
       open_todo_categories_modal: false,
       todos: todos,
       todos_categories: todos_categories,
       current_todo: nil
     )}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    current_week =
      unless is_nil(params["date"]),
        do: Timex.parse!(params["date"], "{YYYY}-{M}-{D}"),
        else: Date.utc_today()

    {:noreply, assign(socket, current_week: current_week)}
  end

  @impl true
  def handle_event("open-todo-modal", %{"todo" => id}, socket) do
    todo = Enum.find(socket.assigns.todos, &(&1.id == String.to_integer(id)))
    {:noreply, assign(socket, open_todo_modal: true, current_todo: todo)}
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
  def handle_event("move-todo", %{"id" => id, "day" => day}, socket) do
    idx = Enum.find_index(socket.assigns.todos, &(&1.id == String.to_integer(id)))
    {:ok, todo} = Todos.update_todo(Enum.at(socket.assigns.todos, idx), %{assign_on: day})
    {:noreply, assign(socket, todos: List.replace_at(socket.assigns.todos, idx, todo))}
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
    idx = Enum.find_index(socket.assigns.todos_categories, &(&1.id == category.id))
    todos_categories = List.replace_at(socket.assigns.todos_categories, idx, category)
    {:noreply, assign(socket, todos_categories: todos_categories)}
  end

  @impl true
  def handle_info({TodoCategoryFormLive, :todo_category_deleted, category}, socket) do
    idx = Enum.find_index(socket.assigns.todos_categories, &(&1.id == category.id))
    todos_categories = List.delete_at(socket.assigns.todos_categories, idx)
    {:noreply, assign(socket, todos_categories: todos_categories)}
  end

  @impl true
  def handle_info({TodoFormLive, :todo_created, todo}, socket) do
    {:noreply, assign(socket, todos: [todo] ++ socket.assigns.todos)}
  end

  @impl true
  def handle_info({TodoFormLive, :todo_updated, todo}, socket) do
    idx = Enum.find_index(socket.assigns.todos, &(&1.id == todo.id))
    todos = List.replace_at(socket.assigns.todos, idx, todo)
    {:noreply, assign(socket, open_todo_modal: false, todos: todos)}
  end

  defp get_related_category(todo, categories) do
    Enum.find(categories, &(&1.id == todo.todo_category_id))
  end

  defp get_unassigned_todos(todos) do
    Enum.filter(todos, &is_nil(&1.assign_on))
  end

  defp get_assigned_todos(todos, day) do
    todos
    |> Enum.filter(&!is_nil(&1.assign_on))
    |> Enum.filter(&Date.compare(&1.assign_on, day) == :eq)
  end
end
