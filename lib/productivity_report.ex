defmodule ProductivityReport do
  alias ProductivityReport.Parser

  def build(file_name) do
    file_name
    |> Parser.call()
    |> Enum.reduce(initialize_report(), &accumulate_fields/2)
  end

  defp accumulate_fields(line, report) do
    all_hours = accumulate_all_hours(line, report.all_hours)
    hours_per_month = %{}
    hours_per_year = %{}

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp accumulate_all_hours([freelancer, hours | _tails], all_hours) do
    previous = Map.get(all_hours, freelancer, 0)
    Map.put(all_hours, freelancer, previous + hours)
  end

  defp initialize_report, do: %{all_hours: %{}, hours_per_month: %{}, hours_per_year: %{}}

  defp build_report(all_hours, hours_per_month, hours_per_year) do
    %{all_hours: all_hours, hours_per_month: hours_per_month, hours_per_year: hours_per_year}
  end
end

# %{
#   all_hours: %{
#         danilo: 500,
#         rafael: 854,
#         ...
#     },
#   hours_per_month: %{
#         danilo: %{
#             janeiro: 40,
#             fevereiro: 64,
#             ...
#         },
#         rafael: %{
#             janeiro: 52,
#             fevereiro: 37,
#             ...
#         }
#     },
#   hours_per_year: %{
#         danilo: %{
#             2016: 276,
#             2017: 412,
#             ...
#         },
#         rafael: %{
#             2016: 376,
#             2017: 348,
#             ...
#         }
#     }
# }
