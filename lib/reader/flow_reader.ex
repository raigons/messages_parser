defmodule Reader.FlowReader do
  alias Reader.{FileStreamBuilder, Parser}
  alias Repository.Record

  def import(file_name, record) do
    file_name
    |> FileStreamBuilder.build_stream()
    |> build_flow(record)
    |> Flow.run()
  end

  defp build_flow(stream, record) do
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
