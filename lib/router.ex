defmodule Pepe.Router do
  use Plug.Router

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  get "/:path" do
    result = Pepe.Controller.get(path, Pepe.QueryString.transform(conn.query_string))
    parse_response(conn, result)
  end

  post "/:path" do
    result = Pepe.Controller.post(path, conn.body_params)
    parse_response(conn, result)
  end

  defp parse_response(conn, {status, response}) do
    send_resp(conn, status, response)
  end

  match _ do
    send_resp(conn, 400, "Bad Request")
  end
end
