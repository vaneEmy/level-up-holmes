defmodule Sender do
  @moduledoc """
  Documentation for `Sender`.
  """
  def send_email("konnichiwa@world.com" = _email), do: :error

  def send_email(email) do
    Process.sleep(3_000)
    IO.puts("Email to #{email} sent")
    {:ok, "email_sent"}
  end
end
