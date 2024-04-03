defmodule GraphqlApiWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: GraphqlApiWeb.Schema

  @impl true
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  @impl true
  def id(_socket), do: nil
end
