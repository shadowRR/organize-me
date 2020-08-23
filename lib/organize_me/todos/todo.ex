defmodule OrganizeMe.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :assign_on, :date
    field :description, :string
    field :due_date, :date
    field :name, :string
    field :category, :id

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:name, :description, :assign_on, :due_date])
    |> validate_required([:name, :description, :assign_on, :due_date])
  end
end
