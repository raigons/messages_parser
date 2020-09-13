defmodule Report.MessagesPerDay do
  alias Repository.Record

  def count(record) do
    record
    |> Record.all_messages()
    |> Enum.flat_map(fn {_author, a_messages} -> a_messages end)
    |> Enum.frequencies_by(fn message -> NaiveDateTime.to_date(message.datetime) end)
  end
end
