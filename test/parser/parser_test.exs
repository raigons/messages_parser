defmodule Parser.ParserTest do
  use ExUnit.Case

  alias Parser.Parser

  @raw_message "[11/05/18 02:16:21] Ramon Gonçalves: Hello world!"

  test "extracts datetime value" do
    assert %Message{datetime: ~N[2018-05-11 02:16:21]} = Parser.parse_message(@raw_message)
  end

  test "extracts author name" do
    assert %Message{author: "Ramon Gonçalves"} = Parser.parse_message(@raw_message)
  end

  test "extracts message content into type" do
    assert %Message{content: "Hello world!"} = Parser.parse_message(@raw_message)
  end
end
