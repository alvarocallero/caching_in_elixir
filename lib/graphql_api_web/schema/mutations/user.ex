defmodule GraphqlApiWeb.Schema.Mutations.User do
  @moduledoc false
  use Absinthe.Schema.Notation

  alias GraphqlApiWeb.Resolver

  object :user_mutations do
    @desc "Create a new user. If the user already exists then an error is returned"
    field :create_user, :user do
      arg :name, non_null(:string)
      arg :email, non_null(:string)
      arg :preference, non_null(:input_user_preferences)

      resolve &Resolver.User.create/2
    end

    @desc "Update the name and/or email of an user"
    field :update_user, :user do
      arg :id, non_null(:id)
      arg :name, :string
      arg :email, :string

      resolve &Resolver.User.update/2
    end

    @desc "Create a new user. If the user already exists then an error is returned"
    field :update_user_preferences, :user do
      arg :id, non_null(:id)
      arg :preferences, non_null(:input_user_preferences)

      resolve &Resolver.User.update_preferences/2
    end
  end
end
