defmodule DieScheiteWebApi.HTTP.Routes do
  defmacro __using__(opts) do
    routes = Keyword.get(opts, :routes, [])

    quote bind_quoted: [routes: routes, opts: opts] do
      use Plug.Router
      import Plug.Conn
      require Logger

      plug(:match)
      plug(:dispatch)

      Enum.each(routes, fn {m, r, f} ->
        match(r,
          via: m,
          do:
            apply(unquote(Keyword.get(opts, :module, __MODULE__)), unquote(f), [
              var!(conn),
              var!(conn).params
            ])
        )
      end)

      match(_, do: send_resp(var!(conn), 404, "Not Found"))
    end
  end
end
