defmodule Reader.Parser do
  alias Reader.Parser.{IOSParser, AndroidParser}

  @default_formats [
    {~r/\[[0-9]{2}\/[0-9]{2}\/(?<!\d)(\d{2}|\d{4}) \d+:\d+:\d+\]\s(.+?):\s(.+?)/, :ios_format},
    {~r/[0-9]{2}\/[0-9]{2}\/(?<!\d)(\d{2}|\d{4}) \d+:\d+\s\-\s(.+?):\s(.+?)/, :android_format}
  ]

  def parse_message(""), do: %Message{}

  def parse_message(raw_message) do
    raw_message |> parser |> do_parse
  end

  defp parser(raw_message) do
    {_, type} =
      Enum.find(@default_formats, {nil, :unknown}, fn {regex, _type} ->
        Regex.match?(regex, raw_message)
      end)

    {type, raw_message}
  end

  defp do_parse({:ios_format, raw_message}), do: IOSParser.parse_message(raw_message)
  defp do_parse({:android_format, raw_message}), do: AndroidParser.parse_message(raw_message)
  defp do_parse({:unknown, raw_message}), do: %Message{content: raw_message}

  def is_known_format?(raw_message) when is_binary(raw_message) do
    raw_message |> parser |> is_known_format?
  end

  def is_known_format?({:ios_format, _}), do: true
  def is_known_format?({:android_format, _}), do: true
  def is_known_format?({:unknown, _}), do: false
end
