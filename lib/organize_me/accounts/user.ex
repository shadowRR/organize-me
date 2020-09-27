defmodule OrganizeMe.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  @derive {Inspect, except: [:password]}
  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :confirmed_at, :naive_datetime

    timestamps()
  end

  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_email()
    |> validate_password()
  end

  def email_changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_email()
    |> ensure_email_has_changed()
  end

  def password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password()
  end

  def confirm_changeset(user) do
    now =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    change(user, confirmed_at: now)
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, OrganizeMe.Repo)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 80)
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> prepare_changes(&hash_password/1)
  end

  defp hash_password(changeset) do
    password = get_change(changeset, :password)

    changeset
    |> put_change(:hashed_password, Pbkdf2.hash_pwd_salt(password))
    |> delete_change(:password)
  end

  defp ensure_email_has_changed(%{changes: %{email: _}} = changeset) do
    changeset
  end

  defp ensure_email_has_changed(changeset) do
    add_error(changeset, :email, "did not change")
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we
  call `Pbkdf2.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%__MODULE__{hashed_password: h_pass}, pass)
      when is_binary(h_pass) and byte_size(pass) > 0 do
    Pbkdf2.verify_pass(pass, h_pass)
  end

  def valid_password?(_, _) do
    Pbkdf2.no_user_verify()
    false
  end

  @doc """
  Validates the current password.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password),
      do: changeset,
      else: add_error(changeset, :current_password, "is not valid")
  end
end
