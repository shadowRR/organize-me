defmodule OrganizeMeWeb.TodoCategoryFormLive do
  use OrganizeMeWeb, :live_component

  alias OrganizeMe.Todos
  alias OrganizeMe.Todos.TodoCategory

  @impl true
  def render(assigns) do
    ~L"""
    <%= f = form_for @changeset, "#", [phx_change: "validate", phx_target: @myself, phx_submit: "save"] %>
      <div class="columns">
        <div class="column col-8">
          <div class="form-group">
            <%= text_input f, :name, [
              id: "#{@id}-name-input",
              class: "form-input"
            ] %>
            <%= error_tag f, :name %>
          </div>
        </div>
        <div class="column col-2">
          <div class="form-group">
            <%= color_input f, :color, [
              id: "#{@id}-color-input",
              class: "form-input"
            ] %>
            <%= error_tag f, :color %>
          </div>
        </div>
        <div class="column col-2" style="display: flex; align-items: flex-end;">
          <%= unless is_nil(@todo_category) do %>
            <%= submit [phx_disable_with: "...", class: "btn btn-warning", disabled: map_size(@changeset.changes) == 0] do %>
              <i class="icon icon-edit"></i>
            <% end %>
            <button phx-click="delete" phx-target="<%= @myself %>" class="btn btn-error ml-1" type="button">
              <i class="icon icon-delete"></i>
            </button>
          <% else %>
            <%= submit [phx_disable_with: "...", class: "btn btn-success", disabled: !@changeset.valid?] do %>
              <i class="icon icon-plus"></i>
            <% end %>
          <% end %>
        </div>
      </div>
    </form>
    """
  end

  @impl true
  def update(assigns, socket) do
    changeset =
      unless is_nil(assigns.todo_category),
        do: Todos.change_todo_category(assigns.todo_category),
        else: Todos.change_todo_category(%TodoCategory{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(changeset: changeset)}
  end

  @impl true
  def handle_event("validate", %{"todo_category" => attrs}, socket) do
    changeset =
      (socket.assigns.todo_category || %TodoCategory{})
      |> Todos.change_todo_category(attrs)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"todo_category" => attrs}, %{assigns: %{todo_category: nil}} = socket) do
    case Todos.create_todo_category(socket.assigns.current_user, attrs) do
      {:ok, todo_category} ->
        changeset = Todos.change_todo_category(%TodoCategory{})
        send(self(), {__MODULE__, :todo_category_created, todo_category})
        {:noreply, assign(socket, changeset: changeset)}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true
  def handle_event("save", %{"todo_category" => attrs}, %{assigns: %{todo_category: todo_category}} = socket) do
    case Todos.update_todo_category(todo_category, attrs) do
      {:ok, todo_category} ->
        send(self(), {__MODULE__, :todo_category_updated, todo_category})
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true
  def handle_event("delete", _params, %{assigns: %{todo_category: todo_category}} = socket) do
    case Todos.delete_todo_category(todo_category) do
      {:ok, _} ->
        send(self(), {__MODULE__, :todo_category_deleted, todo_category})
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
