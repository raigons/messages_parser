defmodule Reader.MessageReader do
  alias Reader.Parser
  alias Repository.Record

  def import(file_name) do
    {:ok, record} = Record.start_link([])

    with stream <- File.stream!(file_name),
         stream <- Stream.map(stream, &String.trim/1),
         stream <-
           Stream.scan(stream, %Message{}, &store_message(record, Parser.parse_message(&1), &2)) do
      case Stream.run(stream) do
        :ok -> {:ok, record}
        _ -> :error
      end
    end
  end

  defp store_message(_record, nil, last_inserted), do: last_inserted

  defp store_message(
         record,
         message = %Message{author: nil, datetime: nil, content: _content},
         last_inserted
       ) do
    store_message(
      record,
      %Message{message | author: last_inserted.author, datetime: last_inserted.datetime},
      last_inserted
    )
  end

  defp store_message(record, message, _last_inserted) do
    Record.save(record, message.author, message)
    message
  end
end
