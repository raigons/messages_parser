defmodule Report.MessagesPerHourByUser do
  alias Repository.Record

  def count(record) do
    record
    |> Record.all_messages()
    |> Enum.reduce(%{}, fn {author, messages}, result ->
      oredered_frequencies =
        messages
        |> Enum.frequencies_by(fn message -> message.datetime.hour end)
        |> Enum.sort(fn {_hour, count}, {_h, count_next} -> count > count_next end)

      Map.put(result, author, oredered_frequencies)
    end)
  end
end
