defmodule Reader.MessageReaderTest do
  use ExUnit.Case
  use Agent

  alias Reader.MessageReader

  describe "reads single line file" do
    test "loads message from file and parse it" do
      file_name = "test/fixtures/sample_1.txt"

      {:ok, record} = MessageReader.import(file_name)

      expected_message = %Message{
        author: "John Doe",
        datetime: ~N[2020-08-11 02:16:21],
        content: "Olá!"
      }

      assert %{
               "John Doe" => [expected_message]
             } == Agent.get(record, fn state -> state end)
    end
  end

  describe "reads multiple line file for single author" do
    test "loads messages from file" do
      file_name = "test/fixtures/sample_2.txt"

      {:ok, record} = MessageReader.import(file_name)

      expected_messages = [
        %Message{
          author: "Ramon",
          content: "Hi!",
          datetime: ~N[2020-08-25 02:16:21]
        },
        %Message{
          author: "Ramon",
          content: "Another message",
          datetime: ~N[2020-08-25 02:16:34]
        },
        %Message{
          author: "Ramon",
          content: "Plus one",
          datetime: ~N[2020-08-25 02:17:22]
        }
      ]

      assert %{
               "Ramon" => expected_messages
             } == Agent.get(record, fn state -> state end)
    end
  end

  describe "reads file with multiples message for different authors" do
    file_name = "test/fixtures/sample_3.txt"

    {:ok, record} = MessageReader.import(file_name)

    john_messages = [
      %Message{
        author: "John Doe",
        datetime: ~N[2020-08-25 02:16:21],
        content: "Olá!"
      },
      %Message{
        author: "John Doe",
        content: "Some another message",
        datetime: ~N[2020-08-25 03:59:50]
      }
    ]

    ramon_messages = [
      %Message{
        author: "Ramon",
        content: "Hi!",
        datetime: ~N[2020-08-25 02:16:21]
      },
      %Message{
        author: "Ramon",
        content: "Another message",
        datetime: ~N[2020-08-25 02:16:34]
      }
    ]

    assert %{
             "John Doe" => john_messages,
             "Ramon" => ramon_messages
           } == Agent.get(record, fn messages -> messages end)
  end
end
