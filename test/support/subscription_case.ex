defmodule GraphqlApiWeb.SubscriptionCase do
  @moduledoc """
  Test Case for GraphQL subscription
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      use GraphqlApiWeb.ChannelCase
      use GraphqlApiWeb.DataCase
      use Absinthe.Phoenix.SubscriptionTest, schema: GraphqlApiWeb.Schema

      setup do
        {:ok, socket} = Phoenix.ChannelTest.connect(GraphqlApiWeb.UserSocket, %{})
        {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)

        {:ok, %{socket: socket}}
      end
    end
  end
end
