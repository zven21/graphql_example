defmodule GraphqlExampleWeb.Schema.CMS.Types do
  @moduledoc false

  use GraphqlExampleWeb.Helper.GqlSchemaSuite

  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  alias GraphqlExample.CMS

  object :post do
    field(:id, :integer)
    field(:title, :string)
    field(:desc, :string)
    field(:user_id, :id)
    field(:user, :user, resolve: dataloader(CMS, :user))

    field(:inserted_at, :datetime)
    field(:updated_at, :datetime)
  end
end
