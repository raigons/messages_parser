defmodule Reader.MessageReader do
  alias Reader.Parser
  alias Repository.Record

  def import(file_name) do
    {:ok, record} = Record.start_link([])
    stream = build_stream(file_name, record)

    case Stream.run(stream) do
      :ok -> {:ok, record}
      _ -> :error
    end
  end

  defp build_stream(file_name, record) do
    file_name
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.scan(%Message{}, &store_message(record, Parser.parse_message(&1), &2))
  end

  defp store_message(_record, nil, last_inserted), do: last_inserted

  defp store_message(record, message = %Message{author: nil, datetime: nil}, last_inserted) do
    message = %Message{message | author: last_inserted.author, datetime: last_inserted.datetime}
    store_message(record, message, last_inserted)
  end

  defp store_message(record, message, _last_inserted) do
    Record.save(record, message.author, message)
    message
  end
end
