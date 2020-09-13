defmodule Report.MessagesByUser do
  alias Repository.Record

  def count(record) do
    record
    |> Record.all_messages()
    |> Enum.reduce(%{}, fn {author, messages}, result ->
      Map.put(result, author, Enum.count(messages))
    end)
    |> Enum.sort_by(fn {_author, count} -> count end, :desc)
  end
end
