defmodule Integration.Report.MessagesByUserTest do
  use ExUnit.Case
  use Agent

  describe "count messages by user" do
    test "loads ios messages from file and count by user" do
      file = "test/fixtures/ios/sample_5.txt"

      {:ok, record} = Reader.MessageReader.import(file)
      assert Report.MessagesByUser.count(record) == [{"John Doe",3},{"Ramon",1}]
    end

    test "loads android messages from file and count by user" do
      file = "test/fixtures/android/sample_5.txt"

      {:ok, record} = Reader.MessageReader.import(file)
      assert Report.MessagesByUser.count(record) == [{"John Doe",3},{"Ramon",1}]
    end

    test "does not count messages of no author" do
      file = "test/fixtures/android/sample_7.txt"

      {:ok, record} = Reader.MessageReader.import(file)
      assert Report.MessagesByUser.count(record) == [{"John Doe",1},{"Ramon",1}]
    end
  end
end
