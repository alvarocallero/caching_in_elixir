defmodule GraphqlApiWeb.Middleware.ErrorHandler do
  @moduledoc """
  Absinthe Middleware to handle the errors after every GraphQL request
  """

  @behaviour Absinthe.Middleware

  alias GraphqlApi.ErrorUtils

  def call(resolution, _config) do
    case length(resolution.errors) do
      0 ->
        resolution

      _ ->
        Absinthe.Resolution.put_result(
          resolution,
          handle_errors(hd(resolution.errors), resolution.arguments)
        )
    end
  end

  defp handle_errors(%Ecto.Changeset{} = changeset, params) do
    error =
      changeset
      |> Ecto.Changeset.traverse_errors(fn {msg, options} ->
        Enum.reduce(options, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)
      |> Enum.map(fn {key, value} -> %{key: key, message: value} end)

    {:error, ErrorUtils.conflict(error, params)}
  end

  defp handle_errors(%{code: code, details: details, message: message}, params) do
    case code do
      :not_found ->
        {:error, ErrorUtils.not_found(message, details)}

      :conflict ->
        {:error, ErrorUtils.conflict(message, details)}

      _ ->
        {:error, ErrorUtils.internal_server_error_found("Internal server error", params)}
    end
  end

  defp handle_errors(error, params) do
    {:error, ErrorUtils.not_acceptable(error, params)}
  end
end
