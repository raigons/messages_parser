defmodule Parser.Parser do
  def parse_message(raw_message) do
    %Message{
      datetime: extract_datetime(raw_message),
      author: extract_author(raw_message),
      content: extract_content(raw_message)
    }
  end

  defp extract_datetime(raw_message) do
    with [datetime, _] <-
           Regex.run(~r/[0-9]{2}\/[0-9]{2}\/(?<!\d)(\d{2}|\d{4})(?!\d) \d+:\d+:\d+/, raw_message),
         {:ok, datetime} <- Timex.parse(datetime, "{0D}/{0M}/{YY} {h24}:{m}:{s}") do
      datetime
    else
      {:error, _message} -> nil
    end
  end

  defp extract_author(raw_message) do
    with [_, author] <- Regex.run(~r/\[.+?\]\s(.+?):/, raw_message) do
      author
    end
  end

  defp extract_content(raw_message) do
    with [_, content] <- Regex.run(~r/\[.+?\]\s.+?:\s(.+?)$/, raw_message) do
      content
    end
  end
end
