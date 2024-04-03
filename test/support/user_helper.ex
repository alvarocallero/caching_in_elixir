defmodule GraphqlApiWeb.UserHelper do
  @moduledoc false
  @test_user %{
    "name" => "Peter Parker",
    "email" => "peter@parker.com.uy",
    "secretKey" => "testkey",
    "preference" => %{
      "likesEmails" => true,
      "likesFaxes" => false,
      "likesPhoneCalls" => true
    }
  }

  @another_test_user %{
    "name" => "Steve Aoki",
    "email" => "steve@aoki.com.uy",
    "secretKey" => "testkey",
    "preference" => %{
      "likesEmails" => false,
      "likesFaxes" => false,
      "likesPhoneCalls" => true
    }
  }

  @fields_to_fetch_from_user "
        id
        email
        name
        preference{
          likesEmails
          likesFaxes
          likesPhoneCalls
        }"

  @new_user_preferences %{
    "likesEmails" => false,
    "likesFaxes" => true,
    "likesPhoneCalls" => false
  }

  def get_user, do: @test_user
  def get_another_user, do: @another_test_user
  def get_fields_to_fetch_from_user, do: @fields_to_fetch_from_user
  def get_new_user_preferences, do: @new_user_preferences
end
