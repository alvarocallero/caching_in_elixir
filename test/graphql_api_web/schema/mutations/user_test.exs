defmodule GraphqlApiWeb.Schema.Mutations.UserTest do
  use GraphqlApiWeb.DataCase, async: true

  alias GraphqlApi.Accounts
  alias GraphqlApiWeb.Schema
  alias GraphqlApiWeb.UserHelper

  @create_user_doc """
  mutation CreateUser($name: String!, $email: String!, $preference: InputUserPreferences!, $secretKey: String!) {
    create_user(name: $name, email: $email, preference: $preference, secretKey: $secretKey){
      #{UserHelper.get_fields_to_fetch_from_user()}
      }
    }
  """

  @update_user_doc """
  mutation UpdateUser($id: ID!, $name: String!, $email: String!, $secretKey: String!) {
    update_user(id: $id, name: $name, email: $email, secretKey: $secretKey){
      #{UserHelper.get_fields_to_fetch_from_user()}
      }
    }
  """

  @update_user_preferences_doc """
  mutation UpdateUserPreferences($id: ID!, $preferences: InputUserPreferences!, $secretKey: String!) {
    update_user_preferences(id: $id, preferences: $preferences, secretKey: $secretKey){
      #{UserHelper.get_fields_to_fetch_from_user()}
      }
    }
  """

  describe "@update_user" do
    test "update a user with success" do
      assert {:ok, user} = Accounts.create_user(UserHelper.get_user())

      assert {:ok, %{data: data}} =
               Absinthe.run(@update_user_doc, Schema,
                 variables: %{
                   "id" => user.id,
                   "name" => "Marcelo Zalayeta",
                   "email" => "mzalayeta@adinet.com.uy",
                   "secretKey" => "testkey"
                 }
               )

      assert data["update_user"]["name"] === "Marcelo Zalayeta"
      assert data["update_user"]["email"] === "mzalayeta@adinet.com.uy"
    end

    test "update a user with an invalid secret key" do
      assert {:ok, user} = Accounts.create_user(UserHelper.get_user())

      assert {:ok, %{data: data}} =
               Absinthe.run(@update_user_doc, Schema,
                 variables: %{
                   "id" => user.id,
                   "name" => "Marcelo Zalayeta",
                   "email" => "mzalayeta@adinet.com.uy",
                   "secretKey" => "asdasd"
                 }
               )

      assert data["update_user"] == nil
    end
  end

  describe "@create_user" do
    test "create a user" do
      assert {:ok, %{data: data}} =
               Absinthe.run(@create_user_doc, Schema, variables: UserHelper.get_user())

      assert data["create_user"]["name"] === "Peter Parker"
      assert data["create_user"]["email"] === "peter@parker.com.uy"
      assert data["create_user"]["preference"]["likesEmails"] === true
      assert data["create_user"]["preference"]["likesFaxes"] === false
      assert data["create_user"]["preference"]["likesPhoneCalls"] === true

      assert {:ok, user} = Accounts.find_user(%{id: data["create_user"]["id"]})
      assert user.name === "Peter Parker"
      assert user.email === "peter@parker.com.uy"
    end

    test "create a user with same email" do
      assert {:ok, %{data: _data}} =
               Absinthe.run(@create_user_doc, Schema, variables: UserHelper.get_user())

      assert {:ok, %{data: _data, errors: errors}} =
               Absinthe.run(@create_user_doc, Schema, variables: UserHelper.get_user())

      assert hd(errors).code == :conflict
      assert hd(hd(hd(errors).message).message) == "This email address already exists."
    end
  end

  describe "@update_user_preferences" do
    test "update the preferences of a user by id" do
      assert {:ok, user} = Accounts.create_user(UserHelper.get_user())

      assert {:ok, %{data: data}} =
               Absinthe.run(@update_user_preferences_doc, Schema,
                 variables: %{
                   "id" => user.id,
                   "preferences" => %{
                     "likesEmails" => false,
                     "likesFaxes" => true,
                     "likesPhoneCalls" => false
                   },
                   "secretKey" => "testkey"
                 }
               )

      assert data["update_user_preferences"]["preference"]["likesEmails"] === false
      assert data["update_user_preferences"]["preference"]["likesFaxes"] === true
      assert data["update_user_preferences"]["preference"]["likesPhoneCalls"] === false
    end
  end
end
