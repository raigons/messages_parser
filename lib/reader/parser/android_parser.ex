defmodule Reader.Parser.AndroidParser do
  def parse_message(raw_message) do
    %Message{}
    |> extract_datetime(raw_message)
    |> extract_author(raw_message)
    |> extract_content(raw_message)
  end

  defp extract_datetime(message, raw_message) do
    with [datetime, _] <-
           Regex.run(~r/[0-9]{2}\/[0-9]{2}\/(?<!\d)(\d{2}|\d{4})(?!\d) \d+:\d+/, raw_message),
         {:ok, datetime} <- Timex.parse(datetime, "{0D}/{0M}/{YYYY} {h24}:{m}") do
      %Message{message | datetime: datetime}
    else
      {:error, error_message} -> IO.inspect(error_message, label: "error")
      nil -> message
    end
  end

  defp extract_author(message, raw_message) do
    regex = ~r/([0-9]{2}\/[0-9]{2}\/(?<!\d)(\d{2}|\d{4})(?!\d) \d+:\d+)\s\-\s(.+?):/

    with [_, _, _, author] <- Regex.run(regex, raw_message) do
      %Message{message | author: author}
    else
      nil -> message
    end
  end

  defp extract_content(message, raw_message) do
    regex = ~r/[0-9]{2}\/[0-9]{2}\/[0-9]{4} \d+:\d+\s\-\s.+?:\s(.+?)$/

    with [_, content] <- Regex.run(regex, raw_message) do
      %Message{message | content: content}
    else
      nil -> message
    end
  end
end
