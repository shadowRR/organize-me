defmodule OrganizeMe.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  alias OrganizeMe.Todos.TodoCategory

  schema "todos" do
    belongs_to :category, TodoCategory
    field :name, :string
    field :description, :string
    field :assign_on, :date
    field :due_date, :date

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [
      :name,
      :description,
      :assign_on,
      :due_date,
      :category_id
    ])
    |> validate_required([
      :name,
      :description,
      :category_id
    ])
  end
end
