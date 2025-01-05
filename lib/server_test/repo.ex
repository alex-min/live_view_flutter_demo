defmodule ServerTest.Repo do
  use Ecto.Repo,
    otp_app: :server_test,
    adapter: Ecto.Adapters.Postgres
end
