defmodule SpamSlack.Reports do
  alias SpamSlack.Reports.Report

  alias SpamSlack.Reports.ReportServer

  def create_report(params) do
    params
    |> to_report()
    |> ReportServer.add_report()
  end

  defp to_report(%{"Type" => "SpamNotification"} = report_params),
    do: %Report{type: :spam, json: report_params}

  defp to_report(report_params), do: %Report{type: :other, json: report_params}

  def send_report(%{type: :spam} = report) do
    token = Application.get_env(:spam_slack, :slack_api_token)

    {:ok, %{status_code: code}} =
      HTTPoison.post(
        "https://slack.com/api/chat.postMessage",
        %{
          channel: "#spam",
          text: "Spam detected: ```#{report.json |> Jason.encode!(pretty: true)}```"
        }
        |> Jason.encode!(),
        [
          {"Authorization", "Bearer #{token}"},
          {"Content-Type", "application/json; charset=utf-8"}
        ]
      )

    %{report | status_code: code}
  end

  def send_report(report), do: report

  def handle_report(_), do: :noop
end
