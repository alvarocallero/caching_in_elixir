defmodule GraphqlApiWeb.DataCase do
  @moduledoc false
  use ExUnit.CaseTemplate

  using do
    quote do
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import GraphqlApiWeb.DataCase

      alias GraphqlApi.Repo
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(GraphqlApi.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(GraphqlApi.Repo, {:shared, self()})
    end

    :ok
  end
end
