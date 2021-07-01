defmodule GraphqlExampleWeb.Middleware.GeneralError do
  @behaviour Absinthe.Middleware

  def call(%{errors: [List = errors]} = resolution, _) do
    message = [%{message: errors}]

    %{resolution | value: [], errors: message}
  end

  def call(resolution, _), do: resolution
end
