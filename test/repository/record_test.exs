defmodule Repository.RecordTest do
  use ExUnit.Case, async: true

  alias Repository.Record

  setup do
    {:ok, record} = Record.start_link([])
    %{record: record}
  end

  test "stores message by author", %{record: record} do
    message = %Message{
      datetime: ~N[2020-12-09 22:08:20],
      author: "Ramon Gonçalves",
      content: "Hi, I wanna talk to you in 25/12/2020: test ;)"
    }

    Record.save(record, "Ramon Gonçalves", message)
    assert Record.get_by_author(record, "Ramon Gonçalves") == [message]
  end
end
