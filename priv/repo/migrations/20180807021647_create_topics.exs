defmodule PhoenixDiscuss.Repo.Migrations.CreateTopics do
  use Ecto.Migration

  def change do
    create table(:topics) do
      add :title, :string
      add :user_id, references(:users)

      timestamps()
    end
  end
end
