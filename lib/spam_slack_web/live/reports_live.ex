defmodule SpamSlackWeb.ReportsLive do
  use SpamSlackWeb, :live_view

  alias SpamSlack.Reports
  alias SpamSlack.Reports

  def mount(_params, _session, socket) do
    socket = update_socket_with_reports(socket)
    :timer.send_interval(1000, self(), :refresh)

    {:ok, socket}
  end

  def handle_info(:refresh, socket) do
    socket = update_socket_with_reports(socket)

    {:noreply, socket}
  end

  def update_socket_with_reports(socket) do
    %{spam: spam_reports, other: other_reports} = Reports.all()

    socket =
      socket
      |> assign(:spam_reports, spam_reports |> Enum.sort_by(& &1.created_at, {:desc, Date}))
      |> assign(:other_reports, other_reports |> Enum.sort_by(& &1.created_at, {:desc, Date}))
  end
end
