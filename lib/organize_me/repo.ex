defmodule OrganizeMe.Repo do
  use Ecto.Repo,
    otp_app: :organize_me,
    adapter: Ecto.Adapters.Postgres
end
