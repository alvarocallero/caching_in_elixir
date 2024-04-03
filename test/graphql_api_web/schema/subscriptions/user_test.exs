defmodule GraphqlApiWeb.Schema.Subscriptions.UserTest do
  use GraphqlApiWeb.SubscriptionCase

  alias GraphqlApi.Accounts
  alias GraphqlApiWeb.UserHelper

  @update_user_preferences_doc """
  mutation UpdateUserPreferences($id: ID!, $preferences: InputUserPreferences!, $secretKey: String!) {
    update_user_preferences(id: $id, preferences: $preferences, secretKey: $secretKey){
      #{UserHelper.get_fields_to_fetch_from_user()}
      }
    }
  """

  @updated_user_preferences_sub_doc """
  subscription UpdateUserPreferences($id: ID!){
    updated_user_preferences(id: $id){
      #{UserHelper.get_fields_to_fetch_from_user()}
      }
    }
  """

  @create_user_doc """
  mutation CreateUser($name: String!, $email: String!, $preference: InputUserPreferences!, $secretKey: String!) {
    create_user(name: $name, email: $email, preference: $preference, secretKey: $secretKey){
      #{UserHelper.get_fields_to_fetch_from_user()}
      }
    }
  """

  @created_user_sub_doc """
  subscription CreatedUser{
    created_user{
      #{UserHelper.get_fields_to_fetch_from_user()}
      }
    }
  """

  describe "@updated_user_preferences" do
    test "sends a user when @update_user_preferences mutation is triggered", %{socket: socket} do
      assert {:ok, user} = Accounts.create_user(UserHelper.get_user())

      new_preferences = UserHelper.get_new_user_preferences()
      user_id = to_string(user.id)

      ref = push_doc(socket, @updated_user_preferences_sub_doc, variables: %{id: user.id})

      assert_reply ref, :ok, %{subscriptionId: subscription_id}

      ref =
        push_doc(socket, @update_user_preferences_doc,
          variables: %{
            "id" => user.id,
            "secretKey" => "testkey",
            "preferences" => new_preferences
          }
        )

      assert_reply ref, :ok, reply

      assert %{
               data: %{
                 "update_user_preferences" => %{
                   "id" => ^user_id,
                   "preference" => ^new_preferences
                 }
               }
             } = reply

      assert_push "subscription:data", data

      assert %{
               subscriptionId: ^subscription_id,
               result: %{
                 data: %{
                   "updated_user_preferences" => %{
                     "id" => ^user_id,
                     "preference" => ^new_preferences
                   }
                 }
               }
             } = data
    end
  end

  describe "@created_user" do
    test "create a user when @create_user mutation is triggered", %{socket: socket} do
      ref = push_doc(socket, @created_user_sub_doc)

      assert_reply ref, :ok, %{subscriptionId: subscription_id}

      ref = push_doc(socket, @create_user_doc, variables: UserHelper.get_user())

      assert_reply ref, :ok, reply

      assert %{
               data: %{
                 "create_user" => %{
                   "name" => "Peter Parker",
                   "email" => "peter@parker.com.uy",
                   "preference" => %{
                     "likesEmails" => true,
                     "likesFaxes" => false,
                     "likesPhoneCalls" => true
                   }
                 }
               }
             } = reply

      assert_push "subscription:data", data

      assert %{
               subscriptionId: ^subscription_id,
               result: %{
                 data: %{
                   "created_user" => %{
                     "name" => "Peter Parker",
                     "email" => "peter@parker.com.uy",
                     "preference" => %{
                       "likesEmails" => true,
                       "likesFaxes" => false,
                       "likesPhoneCalls" => true
                     }
                   }
                 }
               }
             } = data
    end
  end
end
