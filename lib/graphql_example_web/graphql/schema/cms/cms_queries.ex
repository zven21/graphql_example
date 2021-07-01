defmodule GraphqlExampleWeb.Schema.CMS.Queries do
  @moduledoc """
  CMS Queries
  """

  use GraphqlExampleWeb.Helper.GqlSchemaSuite

  object :cms_queries do
    @desc "get post list"
    field :list_posts, list_of(:post) do
      resolve(&R.CMS.list_posts/2)
    end

    @desc "get post by id"
    field :post, :post do
      arg(:id, non_null(:id))
      resolve(&R.CMS.resolve_get_post/2)
    end
  end
end
