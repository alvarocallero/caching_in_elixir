defmodule GraphqlApi.Repo.Migrations.CreatePreferences do
  use Ecto.Migration

  def change do
    create table(:preferences) do
      add :likes_emails, :boolean, default: false, null: false
      add :likes_phone_calls, :boolean, default: false, null: false
      add :likes_faxes, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :delete_all)
    end

    create index(:preferences, [:user_id])
  end
end
