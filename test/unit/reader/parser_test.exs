defmodule Reader.ParserTest do
  use ExUnit.Case

  alias Reader.Parser

  describe "default format message" do
    setup do
      %{raw_message: "[11/05/18 02:16:21] Ramon Gonçalves: Hello world!"}
    end

    test "extracts datetime value", %{raw_message: raw_message} do
      assert %Message{datetime: ~N[2018-05-11 02:16:21]} = Parser.parse_message(raw_message)
    end

    test "extracts author name", %{raw_message: raw_message} do
      assert %Message{author: "Ramon Gonçalves"} = Parser.parse_message(raw_message)
    end

    test "extracts message content into type", %{raw_message: raw_message} do
      assert %Message{content: "Hello world!"} = Parser.parse_message(raw_message)
    end

    test "parses messages with special char" do
      raw_message =
        "[09/12/14 22:08:20] Ramon Gonçalves: Hi, I wanna talk to you in 25/12/2014: test ;)"

      assert %Message{
               datetime: ~N[2014-12-09 22:08:20],
               author: "Ramon Gonçalves",
               content: "Hi, I wanna talk to you in 25/12/2014: test ;)"
             } = Parser.parse_message(raw_message)
    end

    test "parses correctly even if the message content includes dates and hours" do
      raw_message =
        "[09/12/14 22:08:20] Ramon Gonçalves: Hi, now is 10/12/2014 22:15:10 - am I correct?"

      assert %Message{
               datetime: ~N[2014-12-09 22:08:20],
               author: "Ramon Gonçalves",
               content: "Hi, now is 10/12/2014 22:15:10 - am I correct?"
             } = Parser.parse_message(raw_message)
    end

    test "parse correctly if the message content includes dates, hours and owner name " do
      raw_message =
        "[01/12/14 23:58:53] Ramon Henrique: Hi Matheus Gonçalves: now is 10/12/2014 13:35:33 - am I correct?"

      assert %Message{
               datetime: ~N[2014-12-01 23:58:53],
               author: "Ramon Henrique",
               content: "Hi Matheus Gonçalves: now is 10/12/2014 13:35:33 - am I correct?"
             } = Parser.parse_message(raw_message)
    end
  end
end
