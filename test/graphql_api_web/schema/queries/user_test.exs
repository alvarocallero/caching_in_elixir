defmodule GraphqlApiWeb.Schema.Queries.UserTest do
  use GraphqlApiWeb.DataCase, async: true

  alias GraphqlApi.Accounts
  alias GraphqlApiWeb.Schema
  alias GraphqlApiWeb.UserHelper

  @get_all_users_doc """
  query AllUsers {
    users{
      #{UserHelper.get_fields_to_fetch_from_user()}
      }
    }
  """

  @get_one_user_doc """
  query OneUser($id: ID!) {
    user(id: $id){
      #{UserHelper.get_fields_to_fetch_from_user()}
      }
    }
  """

  @get_request_hits_counter """
  query GetRequestHits($key: String!) {
    resolver_hits(key: $key)
    }
  """

  describe "@users" do
    test "fetches all users" do
      assert {:ok, %{data: old_data}} = Absinthe.run(@get_all_users_doc, Schema)

      assert {:ok, user} = Accounts.create_user(UserHelper.get_user())

      assert {:ok, %{data: new_data}} = Absinthe.run(@get_all_users_doc, Schema)
      assert length(old_data["users"]) + 1 == length(new_data["users"])

      search_result =
        new_data["users"]
        |> Enum.filter(&(&1["name"] === user.name))
        |> length() !== 0

      assert search_result === true
    end
  end

  describe "@user" do
    test "fetch a specific user by id" do
      assert {:ok, user} = Accounts.create_user(UserHelper.get_user())

      assert {:ok, %{data: data}} =
               Absinthe.run(@get_one_user_doc, Schema,
                 variables: %{
                   "id" => user.id
                 }
               )

      assert data["user"]["name"] === user.name
      assert data["user"]["id"] === to_string(user.id)
      assert data["user"]["email"] === user.email
    end
  end

  describe "@resolver_hits" do
    setup do
      {:ok, %{data: data}} =
        Absinthe.run(@get_request_hits_counter, Schema,
          variables: %{
            "key" => "users"
          }
        )

      {:ok, initial_counter: if(data["resolver_hits"] === nil, do: 0, else: data["resolver_hits"])}
    end

    test "get the hits count of get_all_users request query", state do
      assert {:ok, %{data: _get_users_data}} = Absinthe.run(@get_all_users_doc, Schema)

      assert {:ok, %{data: new_data}} =
               Absinthe.run(@get_request_hits_counter, Schema,
                 variables: %{
                   "key" => "users"
                 }
               )

      final_hits_counter = new_data["resolver_hits"]

      assert state[:initial_counter] + 1 === final_hits_counter
    end
  end
end
