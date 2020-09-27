defmodule OrganizeMe.Todos do
  @moduledoc """
  The Todos context.
  """

  alias Ecto.Changeset
  alias OrganizeMe.Repo
  alias OrganizeMe.Accounts.User
  alias OrganizeMe.Todos.Todo
  alias OrganizeMe.Todos.TodoCategory

  # ==================================
  # TODO
  # ==================================

  @doc """
  Returns the list of todos.

  ## Examples

      iex> list_todos()
      [%Todo{}, ...]

  """
  def list_todos do
    Repo.all(Todo)
  end

  @doc """
  Gets a single todo.

  Raises `Ecto.NoResultsError` if the Todo does not exist.

  ## Examples

      iex> get_todo!(123)
      %Todo{}

      iex> get_todo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_todo!(id), do: Repo.get!(Todo, id)

  @doc """
  Creates a todo.

  ## Examples

      iex> create_todo(%{field: value})
      {:ok, %Todo{}}

      iex> create_todo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo(%User{} = user, attrs \\ %{}) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> Changeset.put_change(:user_id, user.id)
    |> Repo.insert()
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update_todo(todo, %{field: new_value})
      {:ok, %Todo{}}

      iex> update_todo(todo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a todo.

  ## Examples

      iex> delete_todo(todo)
      {:ok, %Todo{}}

      iex> delete_todo(todo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.

  ## Examples

      iex> change_todo(todo)
      %Ecto.Changeset{data: %Todo{}}

  """
  def change_todo(%Todo{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
  end

  # ==================================
  # TODO CATEGORY
  # ==================================

  @doc """
  Returns the list of todos_categories.

  ## Examples

      iex> list_todos_categories()
      [%TodoCategory{}, ...]

  """
  def list_todos_categories do
    Repo.all(TodoCategory)
  end

  @doc """
  Gets a single todo_category.

  Raises `Ecto.NoResultsError` if the Todo category does not exist.

  ## Examples

      iex> get_todo_category!(123)
      %TodoCategory{}

      iex> get_todo_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_todo_category!(id), do: Repo.get!(TodoCategory, id)

  @doc """
  Creates a todo_category.

  ## Examples

      iex> create_todo_category(%{field: value})
      {:ok, %TodoCategory{}}

      iex> create_todo_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo_category(%User{} = user, attrs \\ %{}) do
    %TodoCategory{}
    |> TodoCategory.changeset(attrs)
    |> Changeset.put_change(:user_id, user.id)
    |> Repo.insert()
  end

  @doc """
  Updates a todo_category.

  ## Examples

      iex> update_todo_category(todo_category, %{field: new_value})
      {:ok, %TodoCategory{}}

      iex> update_todo_category(todo_category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo_category(%TodoCategory{} = todo_category, attrs) do
    todo_category
    |> TodoCategory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a todo_category.

  ## Examples

      iex> delete_todo_category(todo_category)
      {:ok, %TodoCategory{}}

      iex> delete_todo_category(todo_category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo_category(%TodoCategory{} = todo_category) do
    Repo.delete(todo_category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo_category changes.

  ## Examples

      iex> change_todo_category(todo_category)
      %Ecto.Changeset{data: %TodoCategory{}}

  """
  def change_todo_category(%TodoCategory{} = todo_category, attrs \\ %{}) do
    TodoCategory.changeset(todo_category, attrs)
  end
end
