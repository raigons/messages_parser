defmodule Reader.MessageReader do
  alias Reader.{StreamReader, FlowReader}
  alias Repository.Record

  @base_file_size 10000

  def import(file_name) do
    {:ok, record} = Record.start_link([])

    case _import(file_name, record, File.stat(file_name)) do
      :ok -> {:ok, record}
      _ -> :error
    end
  end

  defp _import(file_name, record, {:ok, %File.Stat{size: size}}) when size <= @base_file_size,
    do: StreamReader.import(file_name, record)

  defp _import(file_name, record, {:ok, %File.Stat{size: size}}) when size > @base_file_size,
    do: FlowReader.import(file_name, record)
end
