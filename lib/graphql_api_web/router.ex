defmodule GraphqlApiWeb.Router do
  use GraphqlApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api
  end

  forward "/graphql", Absinthe.Plug,
    schema: GraphqlApiWeb.Schema,
    before_send: {RequestCache, :connect_absinthe_context_to_conn}

  forward "/graphiql", Absinthe.Plug.GraphiQL,
    schema: GraphqlApiWeb.Schema,
    before_send: {RequestCache, :connect_absinthe_context_to_conn},
    socket: GraphqlApiWeb.UserSocket,
    interface: :playground
end
