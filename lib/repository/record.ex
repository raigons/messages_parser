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
    Agent.update(record, &Map.put(&1, author, [message] ++ (&1[author] || [])))
  end
end
