defmodule MessagesParserTest do
  use ExUnit.Case
  doctest MessagesParser

  test "greets the world" do
    assert MessagesParser.hello() == :world
  end
end
