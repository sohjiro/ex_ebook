defmodule ExEbookTest do
  use ExUnit.Case
  doctest ExEbook

  test "greets the world" do
    assert ExEbook.hello() == :world
  end
end
