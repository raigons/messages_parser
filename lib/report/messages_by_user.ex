defmodule Report.MessagesByUser do
  alias Repository.Record

  def count(record) do
    messages = Record.all_messages(record)

    Enum.reduce(messages, %{}, fn {author, messages}, result ->
      Map.put(result, author, Enum.count(messages))
    end)
  end
end
