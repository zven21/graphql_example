defmodule GraphqlExample.Factory do
  use ExMachina.Ecto, repo: GraphqlExample.Repo

  alias GraphqlExample.Accounts.User
  alias GraphqlExample.CMS.Post

  def user_factory() do
    %User{
      email: sequence(:email, &"#{&1}_test_hash"),
      hashed_password: sequence(:hashed_password, &"#{&1}_test_hash")
    }
  end

  def post_factory() do
    %Post{
      title: sequence(:title, &"#{&1}_test_hash"),
      desc: sequence(:desc, &"#{&1}_test_hash")
    }
  end
end
