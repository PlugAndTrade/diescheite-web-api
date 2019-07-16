defmodule DieScheiteWebApi do
  @moduledoc """
  Documentation for DiescheiteWebApi.
  """

  use Application
  require Logger

  def start(_type, _args) do
    {port, _} = Integer.parse(Elixir.Confex.get_env(:die_scheite_web_api, :port))

    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: DieScheiteWebApi.HTTP.Router,
        options: [port: port, timeout: 70_000]
      )
    ]

    Logger.debug(fn -> "[#{__MODULE__}] :: Starting HTTP server on port #{port}" end)

    Supervisor.start_link(children, strategy: :one_for_one, name: DieScheiteWebApi.Supervisor)
  end
end
