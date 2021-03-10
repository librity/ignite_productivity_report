defmodule ProductivityReport.Parser do
  @months %{
    "1" => :january,
    "2" => :february,
    "3" => :march,
    "4" => :april,
    "5" => :may,
    "6" => :june,
    "7" => :july,
    "8" => :august,
    "9" => :september,
    "10" => :october,
    "11" => :november,
    "12" => :december
  }

  def call(file_name) do
    "data/#{file_name}.csv"
    |> File.stream!()
    |> Stream.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> List.update_at(0, &doncase_to_atom/1)
    |> List.update_at(1, &String.to_integer/1)
    |> List.update_at(2, &String.to_integer/1)
    |> List.update_at(3, &parse_month/1)
    |> List.update_at(4, &String.to_integer/1)
  end

  defp doncase_to_atom(string) do
    string
    |> String.downcase()
    |> String.to_atom()
  end

  defp parse_month(string) do
    @months[string]
  end
end
