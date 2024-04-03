defmodule GraphqlApi.RequestsCounterStoreTest do
  use ExUnit.Case

  alias GraphqlApi.RequestsCounterStore

  setup do
    {:ok, pid} = RequestsCounterStore.start_link(nil)
    %{pid: pid}
  end

  test "increment the user query request and get the counter" do
    RequestsCounterStore.increment_request_counter("user")
    assert {:ok, 2} == RequestsCounterStore.get_request_counter("user")
  end

  test "get the request counter when the key does not exist" do
    assert {:error, "request_name not found in cache"} ==
             RequestsCounterStore.get_request_counter("other_user")
  end
end
