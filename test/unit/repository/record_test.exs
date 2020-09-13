defmodule Repository.RecordTest do
  use ExUnit.Case, async: true

  alias Repository.Record

  setup do
    {:ok, record} = Record.start_link([])
    %{record: record}
  end

  describe "saves messages from single author" do
    test "saves single mesage", %{record: record} do
      message = %Message{
        datetime: ~N[2020-12-09 22:08:20],
        author: "Ramon Gonçalves",
        content: "Hi, I wanna talk to you in 25/12/2020: test ;)"
      }

      Record.save(record, "Ramon Gonçalves", message)
      assert Record.get_by_author(record, "Ramon Gonçalves") == [message]
    end

    test "saves multiples messages", %{record: record} do
      message = %Message{
        datetime: ~N[2020-12-09 22:08:20],
        author: "Ramon Gonçalves",
        content: "Hi, I wanna talk to you in 25/12/2020: test ;)"
      }

      message_2 = %Message{
        datetime: ~N[2020-12-09 22:09:20],
        author: "Ramon Gonçalves",
        content: "Just let me know when."
      }

      Record.save(record, "Ramon Gonçalves", message)
      Record.save(record, "Ramon Gonçalves", message_2)

      assert Record.get_by_author(record, "Ramon Gonçalves") == [message_2, message]
    end
  end

  describe "saves messages from 2 authors" do
    test "saves single message from each one", %{record: record} do
      author_1_message = %Message{
        datetime: ~N[2020-12-09 22:08:20],
        author: "Ramon Gonçalves",
        content: "Hi, I wanna talk to you in 25/12/2020: test ;)"
      }

      author_2_message = %Message{
        datetime: ~N[2020-12-09 22:09:20],
        author: "John Doe",
        content: "Ok. I call you"
      }

      Record.save(record, "Ramon Gonçalves", author_1_message)
      Record.save(record, "John Doe", author_2_message)

      assert Record.get_by_author(record, "Ramon Gonçalves") == [author_1_message]
      assert Record.get_by_author(record, "John Doe") == [author_2_message]
    end

    test "saves multiples messages from each author", %{record: record} do
      author_1_message = %Message{
        datetime: ~N[2020-12-09 22:08:20],
        author: "Ramon Gonçalves",
        content: "Hi, I wanna talk to you in 25/12/2020: test ;)"
      }

      author_1_message_2 = %Message{
        datetime: ~N[2020-12-09 22:15:20],
        author: "Ramon Gonçalves",
        content: "lorem ipsum dolor sit amet"
      }

      author_2_message = %Message{
        datetime: ~N[2020-12-09 22:09:20],
        author: "John Doe",
        content: "Ok. I call you"
      }

      author_2_message_2 = %Message{
        datetime: ~N[2020-12-09 22:16:20],
        author: "John Doe",
        content: "Nanananan Na Na Na"
      }

      Record.save(record, "Ramon Gonçalves", author_1_message)
      Record.save(record, "Ramon Gonçalves", author_1_message_2)
      Record.save(record, "John Doe", author_2_message)
      Record.save(record, "John Doe", author_2_message_2)

      assert Record.get_by_author(record, "Ramon Gonçalves") == [
               author_1_message_2,
               author_1_message
             ]

      assert Record.get_by_author(record, "John Doe") == [author_2_message_2, author_2_message]
    end
  end

  describe "all_messages/1" do
    test "returns a list with all messages separated by authors", %{record: record} do
      author_1_message = %Message{
        datetime: ~N[2020-12-09 22:08:20],
        author: "Ramon Gonçalves",
        content: "Hi, I wanna talk to you in 25/12/2020: test ;)"
      }

      author_2_message = %Message{
        datetime: ~N[2020-12-09 22:09:20],
        author: "John Doe",
        content: "Ok. I call you"
      }

      Record.save(record, "Ramon Gonçalves", author_1_message)
      Record.save(record, "John Doe", author_2_message)

      assert Record.all_messages(record) == %{
               "Ramon Gonçalves" => [author_1_message],
               "John Doe" => [author_2_message]
             }
    end

    test "rejects message with author nil", %{record: record} do
      author_1_message = %Message{
        datetime: ~N[2020-12-09 22:08:20],
        author: "Ramon Gonçalves",
        content: "Hi, I wanna talk to you in 25/12/2020: test ;)"
      }

      author_2_message = %Message{
        datetime: ~N[2020-12-09 22:09:20],
        author: "John Doe",
        content: "Ok. I call you"
      }

      nil_author_message = %Message{
        author: nil,
        content: "Some exported message",
        datetime: ~N[2020-12-09 22:09:20]
      }

      Record.save(record, "Ramon Gonçalves", author_1_message)
      Record.save(record, "John Doe", author_2_message)
      Record.save(record, nil, nil_author_message)

      assert Record.all_messages(record) == %{
               "Ramon Gonçalves" => [author_1_message],
               "John Doe" => [author_2_message]
             }
    end

    test "returns a flatten list with all messages", %{record: record} do
      author_1_message = %Message{
        datetime: ~N[2020-12-09 22:08:20],
        author: "Ramon Gonçalves",
        content: "Hi, I wanna talk to you in 25/12/2020: test ;)"
      }

      author_2_message = %Message{
        datetime: ~N[2020-12-09 22:09:20],
        author: "John Doe",
        content: "Ok. I call you"
      }

      Record.save(record, "Ramon Gonçalves", author_1_message)
      Record.save(record, "John Doe", author_2_message)

      assert Record.all_messages(record, :flatten) == [
         author_2_message,
         author_1_message
      ]
    end
  end
end
