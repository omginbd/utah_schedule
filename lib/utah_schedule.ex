defmodule UtahSchedule do
  @months %{
    "Jan" => 1,
    "Feb" => 2,
    "Mar" => 3,
    "Apr" => 4,
    "May" => 5,
    "Jun" => 6,
    "Jul" => 7,
    "Aug" => 8,
    "Sep" => 9,
    "Oct" => 10,
    "Nov" => 11,
    "Dec" => 12
  }
  @moduledoc """
  UtahSchedule keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def get_schedule() do
    games =
      Finch.build(:get, "https://utahutes.com/services/schedule_txt.ashx?schedule=1552")
      |> Finch.request(UtahSchedule.Finch)
      |> case do
        {:ok, %Finch.Response{status: 200, body: body}} ->
          games_lines =
            body
            |> String.split("\n\r")
            |> Enum.split(11)
            |> elem(1)

          Enum.map(games_lines, fn line ->
            [date_string, time_string, home?, against, location] =
              line
              |> String.split(~r/\s{2,}/)
              |> Enum.take(5)

            %{
              start_time: parse_time(time_string),
              date: parse_date(date_string),
              home_game: home? === "Home",
              against: against
            }
          end)
      end

    :ets.lookup(:games, "games")
    |> case do
      [] ->
        :ets.insert(:games, {"games", games})

      [{_, existing_games}] ->
        Enum.zip(games, existing_games)
        |> Enum.map(fn {new, old} -> MapDiff.diff(new, old) end)
        |> Enum.reject(&(&1.changed === :equal))
        |> case do
          [] ->
            nil

          changes ->
            Finch.build(:post, "https://ntfy.sh/michaelsutahutesschedule", [], inspect(changes))
            |> Finch.request(UtahSchedule.Finch)
        end
    end
  end

  def parse_date(date_string) do
    [month, day, _] = String.split(date_string, " ")

    case Date.new(2023, @months[month], String.to_integer(day)) do
      {:ok, date} -> date
      _ -> nil
    end
  end

  @add_seconds %{
    "AM" => 0,
    "PM" => 43200
  }
  def parse_time("TBD"), do: nil

  def parse_time(time_string) do
    [hour, ampm] = String.split(time_string, " ")
    [hour, _] = String.split(hour, ":")
    Time.from_seconds_after_midnight(String.to_integer(hour) * 60 * 60 + @add_seconds[ampm])
  end
end
