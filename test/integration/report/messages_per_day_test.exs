defmodule Integration.Report.MessagesPerDayTest do
  use ExUnit.Case
  use Agent

  describe "count messages per day" do
    test "loads ios messages from file and messages per day" do
      file = "test/fixtures/ios/sample_6.txt"

      {:ok, record} = Reader.MessageReader.import(file)
      assert Report.MessagesPerDay.count(record) ==
            %{
              ~D[2020-08-25] => 4,
              ~D[2020-08-26] => 8,
              ~D[2020-08-27] => 5
            }
    end

    test "loads android messages from file and count by user" do
      file = "test/fixtures/android/sample_6.txt"

      {:ok, record} = Reader.MessageReader.import(file)
      assert Report.MessagesPerDay.count(record) ==
            %{
              ~D[2020-08-25] => 4,
              ~D[2020-08-26] => 8,
              ~D[2020-08-27] => 5
            }
    end

    test "does not count messages of no author" do
      file = "test/fixtures/android/sample_7.txt"

      {:ok, record} = Reader.MessageReader.import(file)
      assert Report.MessagesPerDay.count(record) ==
            %{
              ~D[2019-03-11] => 2,
            }
    end
  end
end
