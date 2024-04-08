defmodule GraphqlApiWeb.Types.User do
  @moduledoc false
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  @desc "Information about the platform clients"
  object :user do
    field :id, :id
    field :name, :string
    field :email, :string

    field :preference, :user_preferences, resolve: dataloader(GraphqlApi.Accounts, :preference)
  end

  @desc "The preferences that each user has"
  object :user_preferences do
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
    field :likes_faxes, :boolean
  end

  @desc "Input object for user preferences"
  input_object :input_user_preferences do
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
    field :likes_faxes, :boolean
  end

  @desc "The state of the app"
  object :app_state do
    field :emails, list_of(:string)
  end
end
