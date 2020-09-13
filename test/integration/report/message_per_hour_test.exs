defmodule Integration.Report.MessagesPerHourTest do
  use ExUnit.Case
  use Agent

  describe "count messages per day" do
    test "loads ios messages from file and messages per day" do
      file = "test/fixtures/ios/sample_6.txt"

      {:ok, record} = Reader.MessageReader.import(file)

      assert Report.MessagesPerHour.count(record) ==
      [
        {2, 6},
        {3, 4},
        {9, 3},
        {10, 2},
        {8, 1},
        {5, 1}
      ]
    end

    test "loads android messages from file and count by user" do
      file = "test/fixtures/android/sample_6.txt"

      {:ok, record} = Reader.MessageReader.import(file)

      assert Report.MessagesPerHour.count(record) ==
      [
        {2, 6},
        {3, 4},
        {9, 3},
        {10, 2},
        {8, 1},
        {5, 1}
      ]
    end
  end
end
