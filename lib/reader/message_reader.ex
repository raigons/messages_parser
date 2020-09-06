defmodule Reader.MessageReader do
  alias Reader.{StreamReader, FlowReader}

  @base_file_size 10000

  def import(file_name) do
    _import(file_name, File.stat(file_name))
  end

  defp _import(file_name, {:ok, %File.Stat{ size: size}}) when (size <= @base_file_size), do: StreamReader.import(file_name)
  defp _import(file_name, {:ok, %File.Stat{ size: size}}) when (size > @base_file_size), do: FlowReader.import(file_name)
end
