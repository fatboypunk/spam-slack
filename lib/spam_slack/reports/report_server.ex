defmodule SpamSlack.Reports.ReportServer do
  use GenServer
  alias SpamSlack.Reports

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(arg) do
    {:ok, %{spam: [], other: []}}
  end

  def add_report(report) do
    GenServer.call(__MODULE__, {:add_report, report})
  end

  def all do
    GenServer.call(__MODULE__, :get_reports)
  end

  def handle_call({:add_report, report}, _from, reports) do
    reports =
      report
      |> Reports.send_report()
      |> add_report_to_state(reports)

    {:reply, :ok, reports}
  end

  def handle_call(:get_reports, _from, reports) do
    {:reply, reports, reports}
  end

  defp add_report_to_state(%{type: type} = report, reports) do
    Map.update!(reports, type, &([report | &1] |> Enum.reverse()))
  end
end
