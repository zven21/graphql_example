defmodule GraphqlExampleWeb.Helper.Utils do
  @moduledoc false

  def handle_absinthe_error(resolution, err_msg) when is_list(err_msg) do
    # %{resolution | value: [], errors: transform_errors(changeset)}
    resolution
    |> Absinthe.Resolution.put_result({:error, message: err_msg})
  end

  def handle_absinthe_error(resolution, err_msg) when is_binary(err_msg) do
    resolution
    |> Absinthe.Resolution.put_result({:error, message: err_msg})
  end
end
