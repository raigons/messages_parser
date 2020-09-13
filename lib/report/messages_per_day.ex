defmodule Report.MessagesPerDay do
  alias Repository.Record

  def count(record) do
    record
    |> Record.all_messages(:flatten)
    |> Enum.frequencies_by(fn message -> NaiveDateTime.to_date(message.datetime) end)
    |> Enum.sort_by(fn {_date, count} -> count end, :desc)
  end
end
