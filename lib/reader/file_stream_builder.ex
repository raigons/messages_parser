defmodule Reader.FileStreamBuilder do
  def build_stream(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.filter(&reject_empty_line/1)
    |> Stream.chunk_while(
      [],
      fn element, acc ->
        if Reader.Parser.is_known_format?(element) do
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

  defp reject_empty_line(""), do: false
  defp reject_empty_line(_line), do: true
end
