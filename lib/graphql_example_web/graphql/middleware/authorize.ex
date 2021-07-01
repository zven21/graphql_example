defmodule GraphqlExampleWeb.Middleware.Authorize do
  @moduledoc """
  authorize gateway, mainly for login check
  """

  @behaviour Absinthe.Middleware

  import GraphqlExampleWeb.Helper.Utils, only: [handle_absinthe_error: 2]

  def call(%{context: %{current_user: current_user}} = resolution, _info) when not is_nil(current_user), do: resolution

  def call(resolution, _) do
    resolution
    |> handle_absinthe_error("Authorize: need login")
  end
end
