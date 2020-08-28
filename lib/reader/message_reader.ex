defmodule Reader.MessageReader do
  alias Reader.Parser
  alias Repository.Record

  def import(file_name) do
    {:ok, record} = Record.start_link([])

    with stream <- File.stream!(file_name),
         stream <- Stream.map(stream, &String.trim/1),
         stream <- Stream.map(stream, &store_message(record, Parser.parse_message(&1))) do
      case Stream.run(stream) do
        :ok -> {:ok, record}
        _ -> :error
      end
    end
  end

  defp store_message(record, message) do
    Record.save(record, message.author, message)
  end
end
