defmodule Report.MessagesPerHourTest do
  use ExUnit.Case

  alias Report.MessagesPerHour

  describe "count/1" do
    setup do
      messages = [
        %Message{author: "A", content: "Message 1", datetime: ~N[2020-09-01 10:00:00]},
        %Message{author: "B", content: "Message 2", datetime: ~N[2020-09-01 10:01:00]},
        %Message{author: "B", content: "Message 3", datetime: ~N[2020-09-02 10:01:00]},
        %Message{author: "A", content: "Message 4", datetime: ~N[2020-09-03 11:01:00]},
        %Message{author: "A", content: "Message 5", datetime: ~N[2020-09-03 12:01:00]},
        %Message{author: "B", content: "Message 6", datetime: ~N[2020-09-03 12:05:00]},
        %Message{author: "A", content: "Message 7", datetime: ~N[2020-09-11 16:00:00]},
        %Message{author: "A", content: "Message 8", datetime: ~N[2020-09-11 10:00:00]},
        %Message{author: "B", content: "Message 9", datetime: ~N[2020-09-12 08:00:00]},
        %Message{author: "B", content: "Message 10", datetime: ~N[2020-09-13 11:00:00]}
      ]

      {:ok, record} = Repository.Record.start_link(%{})

      Enum.each(messages, &Repository.Record.save(record, &1.author, &1))

      %{record: record}
    end

    test "returns which hours have more messages at all", %{record: record} do
      result = MessagesPerHour.count(record)

      assert result == [
               {10, 4},
               {12, 2},
               {11, 2},
               {16, 1},
               {8, 1}
             ]
    end
  end
end
