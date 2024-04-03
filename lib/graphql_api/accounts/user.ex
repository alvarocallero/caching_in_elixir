defmodule GraphqlApi.Accounts.User do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  schema "users" do
    field :email, :string
    field :name, :string
    has_one :preference, GraphqlApi.Accounts.Preference
  end

  @available_fields [:name, :email]

  def create_changeset(params) do
    changeset(%GraphqlApi.Accounts.User{}, params)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @available_fields)
    |> validate_required(@available_fields)
    |> unique_constraint(:email, message: "This email address already exists.")
    |> cast_assoc(:preference)
  end

  def join_preference(query \\ GraphqlApi.Accounts.User) do
    join(query, :inner, [u], p in assoc(u, :preference), as: :preference)
  end

  def by_user_preferences(query, {likes_filter, value}) do
    where(query, [preference: p], field(p, ^likes_filter) == ^value)
  end
end
