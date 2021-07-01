defmodule GraphqlExample.Turbo do
  @moduledoc false
  import Ecto.Query, warn: false

  alias GraphqlExample.Repo
  alias GraphqlExampleWeb.Gettext, as: Translator

  @doc """
  Finds a object by it's id.

  ## Example

      iex> get(GraphqlExample.Accounts.User, 1)
      {:ok, %GraphqlExample.Accounts.User{}}

  """
  def get(queryable, id, preload: preload) do
    queryable
    |> preload(^preload)
    |> Repo.get(id)
    |> done(queryable, id)
  end

  def get(queryable, id) do
    queryable
    |> Repo.get(id)
    |> done(queryable, id)
  end

  def done(nil, queryable, id), do: {:error, not_found_formater(queryable, id)}
  def done(result, _, _), do: {:ok, result}

  @doc """
  无法通过「检索条件」找到对象，格式化返回。

  ## Examples

    iex> not_found_formater(GraphqlExample.Accounts.User, 1)
    "User(1) not found"

    iex> not_found_formater(GraphqlExample.Accounts.User, [email: "bad_value"])
    "User(bad_value) not found"

  """
  def not_found_formater(queryable, id) when is_integer(id) or is_binary(id) do
    modal =
      queryable
      |> to_string
      |> String.split(".")
      |> List.last()

    Translator |> Gettext.dgettext("404", "#{modal}(%{id}) not found", id: id)
  end

  def not_found_formater(queryable, clauses) do
    modal =
      queryable
      |> to_string
      |> String.split(".")
      |> List.last()

    detail =
      clauses
      |> Enum.into(%{})
      |> Map.values()
      |> List.first()
      |> to_string

    Translator |> Gettext.dgettext("404", "#{modal}(%{name}) not found", name: detail)
  end
end
