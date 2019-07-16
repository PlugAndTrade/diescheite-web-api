defmodule DieScheiteWebApi.HTTP.LogEntryRoutes do
  use DieScheiteWebApi.HTTP.Routes,
    module: DieScheiteWebApi.HTTP.LogEntryController,
    routes: [
      {:post, "", :create}
    ]
end
