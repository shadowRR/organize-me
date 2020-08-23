defmodule OrganizeMe.TodosTest do
  use OrganizeMe.DataCase

  alias OrganizeMe.Todos

  describe "todos_categories" do
    alias OrganizeMe.Todos.TodoCategory

    @valid_attrs %{color: "some color", name: "some name"}
    @update_attrs %{color: "some updated color", name: "some updated name"}
    @invalid_attrs %{color: nil, name: nil}

    def todo_category_fixture(attrs \\ %{}) do
      {:ok, todo_category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Todos.create_todo_category()

      todo_category
    end

    test "list_todos_categories/0 returns all todos_categories" do
      todo_category = todo_category_fixture()
      assert Todos.list_todos_categories() == [todo_category]
    end

    test "get_todo_category!/1 returns the todo_category with given id" do
      todo_category = todo_category_fixture()
      assert Todos.get_todo_category!(todo_category.id) == todo_category
    end

    test "create_todo_category/1 with valid data creates a todo_category" do
      assert {:ok, %TodoCategory{} = todo_category} = Todos.create_todo_category(@valid_attrs)
      assert todo_category.color == "some color"
      assert todo_category.name == "some name"
    end

    test "create_todo_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todos.create_todo_category(@invalid_attrs)
    end

    test "update_todo_category/2 with valid data updates the todo_category" do
      todo_category = todo_category_fixture()
      assert {:ok, %TodoCategory{} = todo_category} = Todos.update_todo_category(todo_category, @update_attrs)
      assert todo_category.color == "some updated color"
      assert todo_category.name == "some updated name"
    end

    test "update_todo_category/2 with invalid data returns error changeset" do
      todo_category = todo_category_fixture()
      assert {:error, %Ecto.Changeset{}} = Todos.update_todo_category(todo_category, @invalid_attrs)
      assert todo_category == Todos.get_todo_category!(todo_category.id)
    end

    test "delete_todo_category/1 deletes the todo_category" do
      todo_category = todo_category_fixture()
      assert {:ok, %TodoCategory{}} = Todos.delete_todo_category(todo_category)
      assert_raise Ecto.NoResultsError, fn -> Todos.get_todo_category!(todo_category.id) end
    end

    test "change_todo_category/1 returns a todo_category changeset" do
      todo_category = todo_category_fixture()
      assert %Ecto.Changeset{} = Todos.change_todo_category(todo_category)
    end
  end

  describe "todos" do
    alias OrganizeMe.Todos.Todo

    @valid_attrs %{assign_on: ~D[2010-04-17], description: "some description", due_date: ~D[2010-04-17], name: "some name"}
    @update_attrs %{assign_on: ~D[2011-05-18], description: "some updated description", due_date: ~D[2011-05-18], name: "some updated name"}
    @invalid_attrs %{assign_on: nil, description: nil, due_date: nil, name: nil}

    def todo_fixture(attrs \\ %{}) do
      {:ok, todo} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Todos.create_todo()

      todo
    end

    test "list_todos/0 returns all todos" do
      todo = todo_fixture()
      assert Todos.list_todos() == [todo]
    end

    test "get_todo!/1 returns the todo with given id" do
      todo = todo_fixture()
      assert Todos.get_todo!(todo.id) == todo
    end

    test "create_todo/1 with valid data creates a todo" do
      assert {:ok, %Todo{} = todo} = Todos.create_todo(@valid_attrs)
      assert todo.assign_on == ~D[2010-04-17]
      assert todo.description == "some description"
      assert todo.due_date == ~D[2010-04-17]
      assert todo.name == "some name"
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todos.create_todo(@invalid_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{} = todo} = Todos.update_todo(todo, @update_attrs)
      assert todo.assign_on == ~D[2011-05-18]
      assert todo.description == "some updated description"
      assert todo.due_date == ~D[2011-05-18]
      assert todo.name == "some updated name"
    end

    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture()
      assert {:error, %Ecto.Changeset{}} = Todos.update_todo(todo, @invalid_attrs)
      assert todo == Todos.get_todo!(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{}} = Todos.delete_todo(todo)
      assert_raise Ecto.NoResultsError, fn -> Todos.get_todo!(todo.id) end
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = Todos.change_todo(todo)
    end
  end
end
