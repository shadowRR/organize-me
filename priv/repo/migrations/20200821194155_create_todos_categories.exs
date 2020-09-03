defmodule OrganizeMe.Repo.Migrations.CreateTodosCategories do
  use Ecto.Migration

  def change do
    create table(:todos_categories) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :name, :string, null: false
      add :color, :string, null: false

      timestamps()
    end

    create table(:todos) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :todo_category_id, references(:todos_categories, on_delete: :delete_all), null: false
      add :name, :string, null: false
      add :description, :string, null: false
      add :assign_on, :date
      add :due_date, :date
      add :finished, :boolean, default: false

      timestamps()
    end

    create index(:todos, [:todo_category_id])
  end
end
