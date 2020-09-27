defmodule OrganizeMe.Accounts.UserToken do
  use Ecto.Schema

  import Ecto.Query

  alias OrganizeMe.Accounts.User

  @rand_size 32
  @hash_algorithm :sha256

  # It is very important to keep the reset password token expiry short,
  # since someone with access to the e-mail may take over the account.
  @reset_password_validity_in_days 1
  @confirm_validity_in_days 7
  @change_email_validity_in_days 7
  @session_validity_in_days 60

  schema "users_tokens" do
    field :token, :binary
    field :context, :string
    field :sent_to, :string
    belongs_to :user, User

    timestamps(updated_at: false)
  end

  @doc """
  Generates a token that will be stored in a signed
  place such as session or cookie. Since those are
  signed, they do not need to be hashed.
  """
  def build_session_token(user) do
    token = :crypto.strong_rand_bytes(@rand_size)
    {token, %__MODULE__{token: token, context: "session", user_id: user.id}}
  end

  @doc """
  Returns a query that both check the validity of the
  token and select the related user.
  """
  def verify_session_token_query(token) do
    query =
      from(token in token_and_context_query(token, "session"))
      |> join(:inner, [token], user in assoc(token, :user))
      |> where([token], token.inserted_at > ago(@session_validity_in_days, "day"))
      |> select([_, user], user)

    {:ok, query}
  end

  @doc """
  Builds a token with a hashed counter part.

  The non-hashed token is sent to the user e-mail while
  the hashed part is stored in the database, in order to
  avoid reconstruction. The token is valid for a week as
  long as users do not change their email.
  """
  def build_email_token(user, context) do
    build_hashed_token(user, context, user.email)
  end

  defp build_hashed_token(user, context, sent_to) do
    token = :crypto.strong_rand_bytes(@rand_size)
    hashed_token = :crypto.hash(@hash_algorithm, token)

    {Base.url_encode64(token, padding: false),
     %__MODULE__{
       token: hashed_token,
       context: context,
       sent_to: sent_to,
       user_id: user.id
     }}
  end

  @doc """
  Returns a query that both check the validity of the
  email token for confirmation and select the related
  user.
  """
  def verify_email_token_query(token, context) do
    case Base.url_decode64(token, padding: false) do
      {:ok, d_token} -> build_confirm_email_token_query(context, d_token)
      :error -> :error
    end
  end

  defp build_confirm_email_token_query(context, decoded_token) do
    days = days_for_context(context)
    hashed_token = :crypto.hash(@hash_algorithm, decoded_token)

    query =
      from(token in token_and_context_query(hashed_token, context))
      |> join(:inner, [token], user in assoc(token, :user))
      |> where([token], token.inserted_at > ago(^days, "day"))
      |> where([token, user], token.sent_to == user.email)
      |> select([_, user], user)

    {:ok, query}
  end

  defp days_for_context("confirm"), do: @confirm_validity_in_days
  defp days_for_context("reset_password"), do: @reset_password_validity_in_days

  @doc """
  Returns a query that both check the validity of the
  email token for change and select the related user
  token.
  """
  def verify_change_email_token_query(token, context) do
    case Base.url_decode64(token, padding: false) do
      {:ok, d_token} -> build_change_email_token_query(context, d_token)
      :error -> :error
    end
  end

  defp build_change_email_token_query(context, decoded_token) do
    hashed_token = :crypto.hash(@hash_algorithm, decoded_token)

    query =
      from(token in token_and_context_query(hashed_token, context))
      |> where([token], token.inserted_at > ago(@change_email_validity_in_days, "day"))

    {:ok, query}
  end

  @doc """
  Fetch either all the tokens of a user for a given context
  or for a list of contexts.
  """
  def user_and_contexts_query(user, :all) do
    __MODULE__
    |> where(user_id: ^user.id)
  end

  def user_and_contexts_query(user, [_ | _] = contexts) do
    from(t in __MODULE__)
    |> where([t], t.user_id == ^user.id and t.context in ^contexts)
  end

  @doc """
  Returns the subquery with the given token / context
  couple underlying data.
  """
  def token_and_context_query(token, context) do
    __MODULE__
    |> where(token: ^token, context: ^context)
  end
end
