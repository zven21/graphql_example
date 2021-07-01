defmodule GraphqlExampleWeb.Schema.Accounts.Types do
  @moduledoc false

  use GraphqlExampleWeb.Helper.GqlSchemaSuite

  object :user do
    field(:id, :id)
    field(:email, :string)
    field(:inserted_at, :datetime)
    field(:updated_at, :datetime)
  end
end
