defmodule Report.MessagesPerHour do
  alias Repository.Record

  def count(record) do
    record
    |> Record.all_messages()
    |> Enum.flat_map(fn {_author, a_messages} -> a_messages end)
    |> Enum.frequencies_by(fn message -> message.datetime.hour end)
    |> Enum.sort(fn {_hour, count}, {_h, count_next} -> count > count_next end)
  end
end
