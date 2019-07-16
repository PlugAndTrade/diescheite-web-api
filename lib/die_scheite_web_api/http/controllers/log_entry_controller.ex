defmodule DieScheiteWebApi.HTTP.LogEntryController do
  use DieScheiteWebApi.HTTP.Controller

  @create_schema %{
    "type" => "object",
    "required" => ["logentry"],
    "additionalProperties" => true,
    "properties" => %{
      "logentry" => %{
        "type" => "object",
        "additionalProperties" => true,
        "required" => [
          "id",
          "correlationId",
          "serviceId",
          "serviceVersion",
          "route",
          "protocol",
          "timestamp",
          "duration",
          "level",
          "levelCategory",
          "headers",
          "messages",
          "trace"
        ],
        "properties" => %{
          "id" => %{"type" => "string", "minLength" => 1},
          "correlationId" => %{"type" => "string", "minLength" => 1},
          "serviceId" => %{"type" => "string", "minLength" => 1},
          "serviceVersion" => %{"type" => "string", "minLength" => 1},
          "route" => %{"type" => "string", "minLength" => 1},
          "protocol" => %{"type" => "string", "minLength" => 1},
          "timestamp" => %{"type" => "integer", "minimum" => 0},
          "duration" => %{"type" => "integer", "minimum" => 0},
          "level" => %{"type" => "integer", "minimum" => 0},
          "levelCategory" => %{"type" => "string", "enum" => ["", "DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"]},
          "headers" => %{"type" => ["array","object"], "items" => %{"type" => "object"}},
          "messages" => %{
            "type" => "array",
            "items" => %{
              "type" => "object",
              "additionalProperties" => false,
              "required" => ["message", "level"],
              "properties" => %{
                "message" => %{"type" => "string", "minLength" => 0},
                "level" => %{"type" => "integer", "minimum" => 0},
                "stacktrace" => %{"type" => "string"},
                "attachments" => %{
                  "type" => "array",
                  "items" => %{
                    "type" => "object",
                    "additionalProperties" => false,
                    "required" => ["id", "name", "data"],
                    "properties" => %{
                      "id" => %{"type" => "string", "minLength" => 1},
                      "name" => %{"type" => "string", "minLength" => 1},
                      "contentType" => %{"type" => "string", "minLength" => 1},
                      "contentEncoding" => %{"type" => "string", "minLength" => 0},
                      "headers" => %{"type" => ["array","object"], "items" => %{"type" => "object"}},
                      "data" => %{"type" => "string", "minLength" => 1},
                    }
                  }
                }
              }
            }
          },
          "trace" => %{
            "type" => "array",
            "items" => %{
              "type" => "object",
              "additionalProperties" => false,
              "required" => ["id","name","timestamp","duration"],
              "properties" => %{
                "id" => %{"type" => "string", "minLength" => 1},
                "parentId" => %{"type" => "string", "minLength" => 1},
                "name" => %{"type" => "string", "minLength" => 1},
                "timestamp" => %{"type" => "integer", "minimum" => 0},
                "duration" => %{"type" => "integer", "minimum" => 0},
              }
            }
          },
        }
      }
    }
  }

  def create(conn, params) do
    with :ok <- validate_create(params),
         :ok <- post_logentry(Map.fetch!(params, "logentry")) do
      conn |> send_resp(201, "")
    else
      {:invalid, errors} -> json(
        conn,
        400,
        %{errors: Enum.map(errors, &(%{message: &1, code: "ERR_INVALID_LOGENTRY"}))}
      )
    end
  end

  defp validate_create(params) do
    validate(@create_schema, params)
  end

  defp validate(schema, data) do
    case ExJsonSchema.Validator.validate(schema, data) do
      {:error, json_errors} -> {:invalid, Enum.map(json_errors, &transform_error/1)}
      _ -> :ok
    end
  end

  defp transform_error({message, key}), do: "#{key}: #{message}"

  defp post_logentry(log) do
    IO.puts(Jason.encode!(log))
  end
end
