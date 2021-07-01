defmodule GraphqlExample.CMS.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :desc, :string
    field :title, :string

    belongs_to :user, GraphqlExample.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    required_fields = ~w(title desc user_id)a

    post
    |> cast(attrs, required_fields)
    |> validate_required(required_fields)
  end
end
