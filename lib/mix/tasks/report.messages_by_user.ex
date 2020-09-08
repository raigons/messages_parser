defmodule Mix.Tasks.Report.MessagesByUser do
  use Mix.Task

  def run(file_path) do
    report(file_path, File.exists?(file_path))
  end

  defp report(_, false), do: Mix.shell().error("File does not exist")

  defp report(file_path, true) do
    {:ok, record} = Reader.MessageReader.import(file_path)
    IO.inspect(Report.MessagesByUser.count(record))
  end
end
