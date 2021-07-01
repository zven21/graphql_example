defmodule GraphqlExampleWeb.Resolvers.CMS do
  @moduledoc false

  alias GraphqlExample.CMS

  def list_posts(_, _), do: {:ok, CMS.list_posts()}

  def resolve_get_post(%{id: id}, _), do: CMS.find_post(id)

  def create_post(_, %{title: title, desc: desc}, %{context: %{current_user: user}}) do
    attrs = %{
      title: title,
      desc: desc,
      user_id: user.id
    }

    CMS.create_post(attrs)
  end

  def update_post(_, %{id: id, title: title, desc: desc}, %{context: %{current_user: user}}) do
    with {:ok, post} <- CMS.find_post(id),
         true <- post.user_id == user.id do
      attrs = %{
        title: title,
        desc: desc
      }

      CMS.update_post(post, attrs)
    else
      {:error, err_msg} -> {:error, err_msg}
      false -> {:error, "Not Authorized"}
    end
  end

  def delete_post(_, %{id: id}, %{context: %{current_user: user}}) do
    with {:ok, post} <- CMS.find_post(id),
         true <- post.user_id == user.id do
      CMS.delete_post(post)
    else
      {:error, err_msg} -> {:error, err_msg}
      false -> {:error, "Not Authorized"}
    end
  end
end
