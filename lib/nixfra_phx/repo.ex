defmodule NixfraPhx.Repo do
  use Ecto.Repo,
    otp_app: :nixfra_phx,
    adapter: Ecto.Adapters.Postgres
end
