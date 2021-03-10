defmodule ProductivityReportTest do
  use ExUnit.Case
  doctest ProductivityReport

  test "greets the world" do
    assert ProductivityReport.hello() == :world
  end
end
