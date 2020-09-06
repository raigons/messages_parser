defmodule Reader.StreamReader do
  alias Reader.Parser
  alias Repository.Record

  def import(stream, record) do
    stream = build(stream, record)

    case Stream.run(stream) do
      :ok -> {:ok, record}
      _ -> :error
    end
  end

  defp build(stream, record) do
    stream
    |> Stream.map(&store_message(record, Parser.parse_message(&1)))
  end

  defp store_message(record, message) do
    %Message{author: author} = message
    Record.save(record, author, message)
    message
  end
end
