defmodule OrganizeMe.Todos.TodoCategory do
  use Ecto.Schema
  import Ecto.Changeset

  alias OrganizeMe.Accounts.User

  schema "todos_categories" do
    belongs_to :user, User
    field :name, :string
    field :color, :string

    timestamps()
  end

  @doc false
  def changeset(todo_category, attrs) do
    todo_category
    |> cast(attrs, [
      :name,
      :color
    ])
    |> validate_required([
      :name,
      :color
    ])
  end
end
