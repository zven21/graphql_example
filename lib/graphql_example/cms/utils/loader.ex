defmodule GraphqlExample.CMS.Utils.Loader do
  @moduledoc """
  dataloader for CMS
  """

  import Ecto.Query, warn: false

  alias GraphqlExample.Repo

  def data, do: Dataloader.Ecto.new(Repo, query: &query/2)
  def query(queryable, _args), do: queryable
end
