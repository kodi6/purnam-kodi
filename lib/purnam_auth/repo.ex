defmodule PurnamAuth.Repo do
  use Ecto.Repo,
    otp_app: :purnam_auth,
    adapter: Ecto.Adapters.Postgres
end
