defmodule DieScheiteWebApi.HTTP.Router do
  use Plug.Router
  use Plug.ErrorHandler
  require Logger

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json, :urlencoded],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  forward("/logentries", to: DieScheiteWebApi.HTTP.LogEntryRoutes)

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
