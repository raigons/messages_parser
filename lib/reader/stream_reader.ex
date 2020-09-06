defmodule Reader.StreamReader do
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
    |> Stream.filter(&reject_empty_line/1)
    |> Stream.chunk_while(
      [],
      fn element, acc ->
        if Reader.Parser.check_default_format(element) do
          case acc do
            [] -> {:cont, [element]}
            _ -> {:cont, acc |> Enum.reverse() |> Enum.join(" "), [element]}
          end
        else
          {:cont, [element | acc]}
        end
      end,
      fn
        [] -> {:cont, []}
        acc -> {:cont, acc |> Enum.reverse() |> Enum.join(" "), []}
      end
    )
    |> Stream.map(&store_message(record, Parser.parse_message(&1)))
  end

  defp reject_empty_line(""), do: false
  defp reject_empty_line(_line), do: true

  defp store_message(record, message) do
    %Message{author: author} = message
    Record.save(record, author, message)
    message
  end
end
