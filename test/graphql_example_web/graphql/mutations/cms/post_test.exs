defmodule GraphqlExampleWeb.Mutation.CMS.PostTest do
  @moduledoc false

  use GraphqlExampleWeb.ConnCase, async: true

  describe "CreatePost.gql" do
    @create_query """
    mutation(
      $title: String!
      $desc: String!
    ) {
      create_post(
        title: $title
        desc: $desc
      ) {
        title
        desc
        user {
          email
        }
      }
    }
    """

    @tag :as_user
    test "create post", %{conn: conn, user: user} do
      variables = %{title: "post_title", desc: "post_desc"}

      result =
        conn |> post("/api", query: @create_query, variables: variables) |> json_response(200)

      assert result == %{
               "data" => %{
                 "create_post" => %{
                   "desc" => "post_desc",
                   "title" => "post_title",
                   "user" => %{"email" => user.email}
                 }
               }
             }
    end
  end

  describe "UpdatePost.gql" do
    @update_post_query """
    mutation(
      $id: ID!
      $title: String!
      $desc: String!
    ) {
    update_post (
      id: $id
      title: $title
      desc: $desc
    ) {
        id
        title
        desc
        user {
          email
        }
      }
    }
    """
    @tag :as_user
    test "update a exist post", %{conn: conn, user: user} do
      a1 = insert(:post, user: user)

      variables = %{
        id: a1.id,
        title: "updated_title",
        desc: "updated_desc"
      }

      result =
        conn
        |> post("/api", query: @update_post_query, variables: variables)
        |> json_response(200)

      assert result == %{
               "data" => %{
                 "update_post" => %{
                   "desc" => "updated_desc",
                   "id" => a1.id,
                   "title" => "updated_title",
                   "user" => %{"email" => user.email}
                 }
               }
             }
    end
  end

  describe "DeletePost.gql" do
    @delete_query """
    mutation ($id: ID!) {
      delete_post (id: $id) {
        id
        title
      }
    }
    """
    @tag :as_user
    test "delete a exist post", %{conn: conn, user: user} do
      a1 = insert(:post, id: 1, user: user)

      variables = %{id: a1.id}

      result =
        conn |> post("/api", query: @delete_query, variables: variables) |> json_response(200)

      assert result == %{"data" => %{"delete_post" => %{"id" => 1, "title" => a1.title}}}
    end

    @tag :as_user
    test "delete a not exist post", %{conn: conn} do
      # assert false
      variables = %{id: 10}

      result =
        conn |> post("/api", query: @delete_query, variables: variables) |> json_response(200)

      assert result == %{
               "data" => %{"delete_post" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 3, "line" => 2}],
                   "message" => "Post(10) not found",
                   "path" => ["delete_post"]
                 }
               ]
             }
    end

    test "no Authorize to delete a post", %{conn: conn} do
      a1 = insert(:post, id: 1, user: build(:user))
      variables = %{id: a1.id}

      result =
        conn |> post("/api", query: @delete_query, variables: variables) |> json_response(200)

      assert result == %{
               "data" => %{"delete_post" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 3, "line" => 2}],
                   "message" => "Authorize: need login",
                   "path" => ["delete_post"]
                 }
               ]
             }
    end
  end
end
