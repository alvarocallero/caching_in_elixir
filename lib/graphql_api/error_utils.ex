defmodule GraphqlApi.ErrorUtils do
  @moduledoc false
  def not_found(error_msg, error_details) do
    %{code: :not_found, details: error_details, message: error_msg}
  end

  def internal_server_error_found(error_msg, error_details) do
    %{code: :internal_server_error, details: error_details, message: error_msg}
  end

  def not_acceptable(error_msg, error_details) do
    %{code: :not_acceptable, details: error_details, message: error_msg}
  end

  def conflict(error_msg, error_details) do
    %{code: :conflict, details: error_details, message: error_msg}
  end
end
