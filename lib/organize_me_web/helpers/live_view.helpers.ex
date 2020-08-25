defmodule OrganizeMeWeb.LiveView.Helpers do
  @moduledoc """
  A set of helpers to handle recurrent needs inside liveviews
  which will be automatically loaded when using the following
  `use OrganizeMeWeb, :live_view`.
  """
  import Phoenix.LiveView

  alias OrganizeMe.Accounts
  alias OrganizeMeWeb.Router.Helpers, as: Routes

  @doc """
  Assign the current user to the socket, to ensure that every request made to the
  live view has access to it, in order to validate authentication / authorization.

  If the assign fails, a flash message will be set and the user will be redirected
  to the login page.
  """
  @spec assign_defaults(%{}, %Phoenix.LiveView.Socket{}) :: %Phoenix.LiveView.Socket{}
  def assign_defaults(%{"user_token" => token}, socket) do
    socket =
      socket
      |> assign_new(:current_user, fn -> Accounts.get_user_by_session_token(token) end)

    if socket.assigns.current_user do
      socket
    else
      socket
      |> put_flash(:error, "You are not connected to Organize-Me.")
      |> redirect(to: Routes.user_session_path(socket, :new))
    end
  end
end
