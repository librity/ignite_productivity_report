defmodule ProductivityReport do
  alias ProductivityReport.Parser

  def build(file_name) do
    file_name
    |> Parser.call()
    |> Enum.reduce(initialize_report(), &accumulate_fields/2)
  end

  defp accumulate_fields(line, report) do
    all_hours = accumulate_all_hours(line, report.all_hours)
    hours_per_month = accumulate_hours_per_month(line, report.hours_per_month)
    hours_per_year = accumulate_hours_per_year(line, report.hours_per_year)

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp accumulate_all_hours([freelancer, hours | _tails], all_hours) do
    previous = Map.get(all_hours, freelancer, 0)

    Map.put(all_hours, freelancer, previous + hours)
  end

  defp accumulate_hours_per_month([freelancer, hours, _day, month, _year], hours_per_month) do
    previous_freelancer = Map.get(hours_per_month, freelancer, %{})
    previous_month = Map.get(previous_freelancer, month, 0)
    new_month = Map.put(previous_freelancer, month, previous_month + hours)

    Map.put(hours_per_month, freelancer, new_month)
  end

  defp accumulate_hours_per_year([freelancer, hours, _day, _month, year], hours_per_year) do
    previous_freelancer = Map.get(hours_per_year, freelancer, %{})
    previous_year = Map.get(previous_freelancer, year, 0)
    new_year = Map.put(previous_freelancer, year, previous_year + hours)

    Map.put(hours_per_year, freelancer, new_year)
  end

  defp initialize_report, do: %{all_hours: %{}, hours_per_month: %{}, hours_per_year: %{}}

  defp build_report(all_hours, hours_per_month, hours_per_year) do
    %{all_hours: all_hours, hours_per_month: hours_per_month, hours_per_year: hours_per_year}
  end
end
