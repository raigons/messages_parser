defmodule Reader.StreamReader do
  alias Reader.{FileStreamBuilder, Parser}
  alias Repository.Record

  def import(file_name, record) do
    file_name
    |> FileStreamBuilder.build_stream()
    |> build_stream(record)
    |> Stream.run()
  end

  defp build_stream(stream, record) do
    stream
    |> Stream.map(&store_message(record, Parser.parse_message(&1)))
  end

  defp store_message(record, message) do
    %Message{author: author} = message
    Record.save(record, author, message)
    message
  end
end
