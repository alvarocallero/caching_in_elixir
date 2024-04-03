defmodule GraphqlApi.AuthTokens.AuthTokenManagerTest do
  use ExUnit.Case

  alias GraphqlApi.AuthTokens.AuthTokenManager

  describe "create_auth_token/1" do
    test "should create a new auth token for a user" do
      assert {:ok, token} = AuthTokenManager.create_auth_token("pepe@argento.com")
      assert token != nil
    end
  end

  describe "get_user_auth_token/1" do
    test "get an existing auth token" do
      assert {:ok, token} = AuthTokenManager.create_auth_token("coqui@argento.com")
      assert token = AuthTokenManager.get_user_auth_token("coqui@argento.com")
    end

    test "get a non existing auth token" do
      assert {:error, :user_does_not_have_auth_token} =
               AuthTokenManager.get_user_auth_token("ruperto@bonjour.com")
    end
  end
end
