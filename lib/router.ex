defmodule Pepe.Router do
  use Plug.Router

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  get "/configs" do
    result = Pepe.Controller.get(conn.query_params)

    conn
    |> put_resp_header("content-type", "application/json")
    |> parse_response(result)
  end

  post "/configs" do
    result = Pepe.Controller.post(conn.body_params)
    parse_response(conn, result)
  end

  patch "/configs" do
    result = Pepe.Controller.patch(conn.body_params)
    parse_response(conn, result)
  end

  defp parse_response(conn, {status, %{} = response}) do
    parse_response(conn, {status, response |> Jason.encode!()})
  end

  defp parse_response(conn, {status, response}) do
    send_resp(conn, status, response)
  end

  match _ do
    send_resp(conn, 400, "Bad Request")
  end
end
