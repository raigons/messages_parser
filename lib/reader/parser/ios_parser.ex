defmodule Reader.Parser.IOSParser do
  def parse_message(raw_message) do
    if check_default_format(raw_message) do
      %Message{}
      |> extract_datetime(raw_message)
      |> extract_author(raw_message)
      |> extract_content(raw_message)
    else
      build_only_content_message(raw_message)
    end
  end

  def check_default_format(raw_message) do
    Regex.match?(
      ~r/\[[0-9]{2}\/[0-9]{2}\/(?<!\d)(\d{2}|\d{4}) \d+:\d+:\d+\]\s(.+?):\s(.+?)/,
      raw_message
    )
  end

  defp build_only_content_message(_raw_message = ""), do: %Message{}
  defp build_only_content_message(raw_message), do: %Message{content: raw_message}

  defp extract_datetime(message, raw_message) do
    with [datetime, _] <-
           Regex.run(~r/[0-9]{2}\/[0-9]{2}\/(?<!\d)(\d{2}|\d{4})(?!\d) \d+:\d+:\d+/, raw_message),
         {:ok, datetime} <- Timex.parse(datetime, "{0D}/{0M}/{YY} {h24}:{m}:{s}") do
      %Message{message | datetime: datetime}
    else
      {:error, error_message} -> IO.inspect(error_message, label: "error")
      nil -> message
    end
  end

  defp extract_author(message, raw_message) do
    with [_, author] <- Regex.run(~r/\[.+?\]\s(.+?):/, raw_message) do
      %Message{message | author: author}
    else
      nil -> message
    end
  end

  defp extract_content(message, raw_message) do
    with [_, content] <- Regex.run(~r/\[.+?\]\s.+?:\s(.+?)$/, raw_message) do
      %Message{message | content: content}
    else
      nil -> message
    end
  end
end
