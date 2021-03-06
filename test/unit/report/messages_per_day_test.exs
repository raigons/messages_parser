defmodule Report.MessagesPerDayTest do
  use ExUnit.Case

  alias Report.MessagesPerDay

  describe "count/1" do
    setup do
      messages = [
        %Message{author: "A", content: "Message 1", datetime: ~N[2020-09-01 10:00:00]},
        %Message{author: "B", content: "Message 2", datetime: ~N[2020-09-01 10:01:00]},
        %Message{author: "B", content: "Message 3", datetime: ~N[2020-09-02 10:01:00]},
        %Message{author: "A", content: "Message 4", datetime: ~N[2020-09-03 11:01:00]},
        %Message{author: "A", content: "Message 5", datetime: ~N[2020-09-03 12:01:00]},
        %Message{author: "B", content: "Message 6", datetime: ~N[2020-09-03 12:05:00]},
        %Message{author: "A", content: "Message 7", datetime: ~N[2020-09-11 16:00:00]}
      ]

      {:ok, record} = Repository.Record.start_link(%{})

      Enum.each(messages, &Repository.Record.save(record, &1.author, &1))

      %{record: record}
    end

    test "returns a map with number of messages per day", %{record: record} do
      result = MessagesPerDay.count(record)

      assert result == [
               {~D[2020-09-03], 3},
               {~D[2020-09-01], 2},
               {~D[2020-09-02], 1},
               {~D[2020-09-11], 1}
             ]
    end

    test "counts messages when more than 2 authors have sent messages", %{record: record} do
      message_c = %Message{author: "C", content: "Message 1", datetime: ~N[2020-09-01 10:00:00]}
      message_c2 = %Message{author: "C", content: "Message 2", datetime: ~N[2020-09-01 10:00:03]}
      Repository.Record.save(record, "C", message_c)
      Repository.Record.save(record, "C", message_c2)

      result = MessagesPerDay.count(record)

      assert result == [
               {~D[2020-09-01], 4},
               {~D[2020-09-03], 3},
               {~D[2020-09-02], 1},
               {~D[2020-09-11], 1}
             ]
    end
  end
end
