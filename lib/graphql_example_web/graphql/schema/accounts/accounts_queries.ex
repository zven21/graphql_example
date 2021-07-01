defmodule GraphqlExampleWeb.Schema.Accounts.Queries do
  @moduledoc """
  CMS Queries
  """

  use GraphqlExampleWeb.Helper.GqlSchemaSuite

  object :accounts_queries do
    field :user, :user do
      arg(:email, non_null(:string))
      resolve(&R.Accounts.resolve_get_user/2)
    end
  end
end
