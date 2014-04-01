defmodule Mix.Tasks.Hexweb.Stats do
  use Mix.Task
  require Lager

  @shortdoc "Calculates yesterdays download stats"

  def run(_args) do
    Mix.Task.run "app.start"

    try do
      { time, memory } = :timer.tc fn -> HexWeb.Stats.Job.run(yesterday()) end
      Lager.info "STATS_JOB_COMPLETED (#{div time, 1000}ms, #{div memory, 1024}kb)"
    catch
      kind, error ->
        stacktrace = System.stacktrace
        Lager.error "STATS_JOB_FAILED"
        HexWeb.Util.log_error(kind, error, stacktrace)
        System.halt(1)
    end
  end

  defp yesterday do
    { today, _time } = :calendar.universal_time()
    today_days = :calendar.date_to_gregorian_days(today)
    :calendar.gregorian_days_to_date(today_days - 1)
  end
end