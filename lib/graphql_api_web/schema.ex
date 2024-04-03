defmodule GraphqlApiWeb.Schema do
  @moduledoc false
  use Absinthe.Schema

  alias GraphqlApiWeb.Middleware.ErrorHandler

  import_types GraphqlApiWeb.Types.User
  import_types GraphqlApiWeb.Schema.Queries.User
  import_types GraphqlApiWeb.Schema.Mutations.User

  query do
    import_fields :user_queries
  end

  mutation do
    import_fields :user_mutations
  end


  def context(ctx) do
    source = Dataloader.Ecto.new(GraphqlApi.Repo)
    dataloader = Dataloader.add_source(Dataloader.new(), GraphqlApi.Accounts, source)
    Map.put(ctx, :loader, dataloader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  def middleware(middleware, _field, _object) do
    middleware ++ [ErrorHandler]
  end
end
