defmodule GraphqlApi.Utils do
  @moduledoc false
  def string_keys_to_atom(map) when is_map(map) do
    Map.new(map, fn {k, v} -> {convert_key(k), convert_value(v)} end)
  end

  defp convert_key(k) when is_binary(k), do: String.to_existing_atom(k)
  defp convert_key(k), do: k

  defp convert_value(v) when is_map(v), do: string_keys_to_atom(v)
  defp convert_value(v), do: v
end
