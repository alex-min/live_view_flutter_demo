defmodule FlutterServer.Repo do
  use Ecto.Repo,
    otp_app: :flutter_server,
    adapter: Ecto.Adapters.Postgres
end
