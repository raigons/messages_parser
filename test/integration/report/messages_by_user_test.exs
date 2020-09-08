defmodule Integration.Report.MessagesByUserTest do
  use ExUnit.Case
  use Agent

  describe "count messages by user" do
    test "loads messages from file and count by user" do
      file = "test/fixtures/sample_5.txt"

      {:ok, record} = Reader.MessageReader.import(file)
      assert Report.MessagesByUser.count(record) == %{"John Doe" => 3, "Ramon" => 1}
    end
  end
end
