defmodule OrganizeMeWeb.PlannerLive do
  use OrganizeMeWeb, :live_view

  alias OrganizeMeWeb.TodoNewLive

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)

    {:ok,
     assign(socket,
       open_todo_modal: false
     )}
  end

  @impl true
  def handle_event("open-todo-modal", _params, socket) do
    {:noreply, assign(socket, open_todo_modal: true)}
  end

  @impl true
  def handle_info({TodoNewLive, :close}, socket) do
    {:noreply, assign(socket, open_todo_modal: false)}
  end
end
