defmodule GraphqlApi.Accounts.Preference do
  @moduledoc """
  This module is responsible for managing the preferences of the users.
  """
  use Ecto.Schema

  import Ecto.Changeset

  schema "preferences" do
    field :likes_emails, :boolean, default: false
    field :likes_faxes, :boolean, default: false
    field :likes_phone_calls, :boolean, default: false
    belongs_to :user, GraphqlApi.Accounts.User
  end

  @available_fields [:likes_emails, :likes_phone_calls, :likes_faxes]

  def create_changeset(params) do
    changeset(%GraphqlApi.Accounts.Preference{}, params)
  end

  @doc false
  def changeset(preference, attrs) do
    preference
    |> cast(attrs, @available_fields)
    |> validate_required(@available_fields)
    |> cast_assoc(:user)
  end
end
