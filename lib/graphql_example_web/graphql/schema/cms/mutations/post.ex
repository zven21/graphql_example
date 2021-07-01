defmodule GraphqlExampleWeb.Schema.CMS.Mutations.Post do
  @moduledoc false

  use GraphqlExampleWeb.Helper.GqlSchemaSuite

  object :cms_post_mutations do
    @desc "create a post"
    field :create_post, :post do
      arg(:title, non_null(:string))
      arg(:desc, non_null(:string))

      middleware(M.Authorize, :login)

      resolve(&R.CMS.create_post/3)
    end

    @desc "update a post"
    field :update_post, :post do
      arg(:id, non_null(:id))
      arg(:title, non_null(:string))
      arg(:desc, non_null(:string))

      middleware(M.Authorize, :login)

      resolve(&R.CMS.update_post/3)
    end

    @desc "delete a post"
    field :delete_post, :post do
      arg(:id, non_null(:id))

      middleware(M.Authorize, :login)

      resolve(&R.CMS.delete_post/3)
    end
  end
end
