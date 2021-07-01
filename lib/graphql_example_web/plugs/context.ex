defmodule GraphqlExampleWeb.Context do
  @moduledoc false

  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    case build_context(conn) do
      {:ok, context} ->
        put_private(conn, :absinthe, %{context: context})

      _ ->
        conn
    end
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization") do
      {:ok, %{current_user: GraphqlExample.Accounts.get_user_by_session_token(token)}}
    end
  end
end
