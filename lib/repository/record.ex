defmodule Repository.Record do
  use Agent

  @doc """
  Starts a new record.
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Gets a value from the `record` by `key`.
  """
  def get_by_author(record, author) do
    Agent.get(record, &Map.get(&1, author))
  end

  @doc """
  Puts the `value` for the given `key` in the `record`.
  """
  def save(record, author, message) do
    Agent.update(record, fn data ->
      author_messages = (data[author] || []) ++ [message]
      Map.merge(data, %{author => author_messages}, fn _k, previous_record, new_record ->
        previous_record ++ new_record
      end)
    end)
  end
end
