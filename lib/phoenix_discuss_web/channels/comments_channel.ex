defmodule PhoenixDiscussWeb.CommentsChannel do
  use PhoenixDiscussWeb, :channel
  import Ecto

  alias PhoenixDiscuss.Discussions.{Topic, Comment}
  alias PhoenixDiscuss.Repo

  def join("comments:" <> topic_id, _auth_msg, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Topic
      |> Repo.get(topic_id)
      |> Repo.preload(comments: [:user])

    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  def handle_in(_name, %{"content" => content}, socket) do
    topic = socket.assigns.topic
    user_id = socket.assigns.user_id

    changeset = topic
      |> build_assoc(:comments, user_id: user_id)
      |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} ->
        preloadedComment = Repo.preload(comment, :user)
        broadcast!(
          socket,
          "comments:#{socket.assigns.topic.id}:new",
          %{comment: preloadedComment}
        )

        {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
