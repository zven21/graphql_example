defmodule GraphqlExampleWeb.Query.CMS.PostTest do
  @moduledoc false

  use GraphqlExampleWeb.ConnCase, async: true

  describe "Post.gql" do
    @query """
    query($id: ID!) {
      post(id: $id) {
        title
        desc
        user {
          email
        }
      }
    }
    """

    test "get post by id with user login", %{conn: conn} do
      a1 = insert(:post, title: "post_title_1", id: 10, user: build(:user))
      variables = %{id: a1.id}
      result = conn |> post("/api", query: @query, variables: variables) |> json_response(200)

      assert result == %{
               "data" => %{
                 "post" => %{
                   "desc" => a1.desc,
                   "title" => a1.title,
                   "user" => %{"email" => a1.user.email}
                 }
               }
             }
    end

    @tag :as_user
    test "post id not exists", %{conn: conn} do
      variables = %{id: 1}

      result = conn |> post("/api", query: @query, variables: variables) |> json_response(200)

      assert result == %{
               "data" => %{"post" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 3, "line" => 2}],
                   "message" => "Post(1) not found",
                   "path" => ["post"]
                 }
               ]
             }
    end
  end

  describe "PagedPosts.gql" do
    @query """
    query {
      list_posts {
        title
        desc
      }
    }
    """
    test "paged posts", %{conn: conn} do
      insert(:post, title: "post_title_1")
      insert(:post, title: "post_title_1")
      result = conn |> post("/api", query: @query, variables: %{}) |> json_response(200)
      assert length(get_in(result, ~w(data list_posts))) == 2
    end
  end
end
