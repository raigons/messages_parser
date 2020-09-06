defmodule Reader.FlowReader do
  alias Reader.Parser
  alias Repository.Record

  def import(stream, record) do
    flow = build(stream, record)

    case Flow.run(flow) do
      :ok -> {:ok, record}
      _ -> :error
    end
  end

  defp build(stream, record) do
    stream
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.map(&store_message(record, Parser.parse_message(&1)))
  end

  defp store_message(record, message) do
    %Message{author: author} = message
    Record.save(record, author, message)
    message
  end
end
