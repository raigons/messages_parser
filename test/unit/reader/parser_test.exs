defmodule Reader.ParserTest do
  use ExUnit.Case

  alias Reader.Parser

  describe "parse/1" do
    setup do
      ios_raw_message = "[11/05/18 02:16:21] Ramon Gonçalves: Hello world!"
      android_raw_message = "11/03/2019 16:05 - Ramon Henrique: foi mal meu camarada"

      %{raw_messages: [ios_raw_message, android_raw_message]}
    end

    test "extracts datetime value", %{raw_messages: [ios_raw_message, android_raw_message]} do
      assert %Message{datetime: ~N[2018-05-11 02:16:21]} = Parser.parse_message(ios_raw_message)

      assert %Message{datetime: ~N[2019-03-11 16:05:00]} =
               Parser.parse_message(android_raw_message)
    end

    test "extracts author name", %{raw_messages: [ios_raw_message, android_raw_message]} do
      assert %Message{author: "Ramon Gonçalves"} = Parser.parse_message(ios_raw_message)
      assert %Message{author: "Ramon Henrique"} = Parser.parse_message(android_raw_message)
    end

    test "extracts message content into type", %{
      raw_messages: [ios_raw_message, android_raw_message]
    } do
      assert %Message{content: "Hello world!"} = Parser.parse_message(ios_raw_message)
      assert %Message{content: "foi mal meu camarada"} = Parser.parse_message(android_raw_message)
    end

    test "parses messages with special char" do
      ios_raw_message =
        "[09/12/14 22:08:20] Ramon Gonçalves: Hi, I wanna talk to you in 25/12/2014: test ;)"

      android_raw_message =
        "09/12/2014 22:08 - Ramon Gonçalves: Hi, I wanna talk to you in 25/12/2014: test ;)"

      assert %Message{
               datetime: ~N[2014-12-09 22:08:20],
               author: "Ramon Gonçalves",
               content: "Hi, I wanna talk to you in 25/12/2014: test ;)"
             } = Parser.parse_message(ios_raw_message)

      assert %Message{
               datetime: ~N[2014-12-09 22:08:00],
               author: "Ramon Gonçalves",
               content: "Hi, I wanna talk to you in 25/12/2014: test ;)"
             } = Parser.parse_message(android_raw_message)
    end

    test "parses correctly even if the message content includes dates and hours" do
      ios_raw_message =
        "[09/12/14 22:08:20] Ramon Gonçalves: Hi, now is 10/12/2014 22:15:10 - am I correct?"

      android_raw_message =
        "09/12/2014 22:08 - Ramon Gonçalves: Hi, now is 10/12/2014 22:15:10 - am I correct?"

      assert %Message{
               datetime: ~N[2014-12-09 22:08:20],
               author: "Ramon Gonçalves",
               content: "Hi, now is 10/12/2014 22:15:10 - am I correct?"
             } = Parser.parse_message(ios_raw_message)

      assert %Message{
               datetime: ~N[2014-12-09 22:08:00],
               author: "Ramon Gonçalves",
               content: "Hi, now is 10/12/2014 22:15:10 - am I correct?"
             } = Parser.parse_message(android_raw_message)
    end
  end

  describe "only-content message format" do
    setup do
      %{raw_message: "This is a pure message with no data and author"}
    end

    test "parses pure message and returns message with no datetime nor author info", %{
      raw_message: raw_message
    } do
      assert %Message{
               datetime: nil,
               author: nil,
               content: "This is a pure message with no data and author"
             } = Parser.parse_message(raw_message)
    end

    test "returns empty %Message{} when message is all null" do
      raw_message = ""

      assert %Message{} == Parser.parse_message(raw_message)
    end
  end

  describe "is_known_format?/1" do
    test "returns true for ios format" do
      ios_raw_message = "[11/05/18 02:16:21] Ramon Gonçalves: Hello world!"
      assert Parser.is_known_format?(ios_raw_message) == true
    end

    test "returns true for android format" do
      android_raw_message = "11/03/2019 16:05 - Ramon Henrique: foi mal meu camarada"
      assert Parser.is_known_format?(android_raw_message) == true
    end

    test "returns false for message with unknown pattern" do
      raw_message = "This is a pure message with no data and author"
      assert Parser.is_known_format?(raw_message) == false
    end
  end
end
