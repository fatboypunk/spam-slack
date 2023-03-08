defmodule SpamSlack.Reports do
  alias SpamSlack.Reports.Report
  alias SpamSlack.Reports.ReportServer

  def all do
    ReportServer.all()
  end

  def create_report(params) do
    params
    |> to_report()
    |> ReportServer.add_report()
  end

  defp to_report(%{"Type" => "SpamNotification"} = report_params),
    do: to_report(%Report{type: :spam}, report_params)

  defp to_report(report_params), do: to_report(%Report{type: :other}, report_params)

  defp to_report(%Report{} = report, report_params),
    do: %{
      report
      | json: report_params,
        email: report_params["Email"],
        bounced_at: report_params["BouncedAt"],
        id: UUID.uuid4(),
        created_at: DateTime.utc_now()
    }

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
end
