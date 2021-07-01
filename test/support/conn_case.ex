defmodule GraphqlExampleWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use GraphqlExampleWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import GraphqlExampleWeb.ConnCase

      import GraphqlExample.Factory

      alias GraphqlExampleWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint GraphqlExampleWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(GraphqlExample.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(GraphqlExample.Repo, {:shared, self()})
    end

    user =
      cond do
        tags[:as_user] ->
          GraphqlExample.Factory.insert(:user, id: 1)

        true ->
          nil
      end

    conn =
      if is_nil(user) do
        Phoenix.ConnTest.build_conn()
      else
        token = GraphqlExample.Accounts.generate_user_session_token(user)

        Phoenix.ConnTest.build_conn()
        |> Plug.Conn.put_req_header("authorization", "Bearer " <> token)
      end

    {:ok, conn: conn, user: user}
  end

  @doc """
  Setup helper that registers and logs in users.

      setup :register_and_log_in_user

  It stores an updated connection and a registered user in the
  test context.
  """
  def register_and_log_in_user(%{conn: conn}) do
    user = GraphqlExample.AccountsFixtures.user_fixture()
    %{conn: log_in_user(conn, user), user: user}
  end

  @doc """
  Logs the given `user` into the `conn`.

  It returns an updated `conn`.
  """
  def log_in_user(conn, user) do
    token = GraphqlExample.Accounts.generate_user_session_token(user)

    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:user_token, token)
  end
end
