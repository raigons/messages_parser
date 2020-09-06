defmodule Reader.MessageReader do
  alias Reader.{StreamReader, FlowReader}
  alias Repository.Record

  @base_file_size 10000

  def import(file_name) do
    {:ok, record} = Record.start_link([])

    file_name
    |> build_stream
    |> _import(record, File.stat(file_name))
  end

  def build_stream(file_name) do
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
  end

  defp _import(stream, record, {:ok, %File.Stat{size: size}}) when size <= @base_file_size,
    do: StreamReader.import(stream, record)

  defp _import(stream, record, {:ok, %File.Stat{size: size}}) when size > @base_file_size,
    do: FlowReader.import(stream, record)

  defp reject_empty_line(""), do: false
  defp reject_empty_line(_line), do: true
end
