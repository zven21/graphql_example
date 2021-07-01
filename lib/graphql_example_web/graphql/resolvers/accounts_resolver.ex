defmodule GraphqlExampleWeb.Resolvers.Accounts do
  @moduledoc false

  alias GraphqlExample.Accounts

  def resolve_get_user(%{id: id}, _), do: {:ok, Accounts.get_user!(id)}
end
