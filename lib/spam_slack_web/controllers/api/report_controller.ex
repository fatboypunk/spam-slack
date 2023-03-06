defmodule SpamSlackWeb.Api.ReportController do
  use SpamSlackWeb, :controller

  alias SpamSlack.Reports

  def create(conn, report_params) do
    Reports.create_report(report_params)

    conn
    |> put_status(:created)
    |> json(%{message: "Report created"})
  end
end
