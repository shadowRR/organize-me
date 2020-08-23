defmodule OrganizeMe.Todos.TodoCategory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos_categories" do
    field :color, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(todo_category, attrs) do
    todo_category
    |> cast(attrs, [:name, :color])
    |> validate_required([:name, :color])
  end
end
