defmodule SpamSlackWeb.Api.ReportsControllerTest do
  use SpamSlackWeb.ConnCase
  alias SpamSlack.Reports.{ReportServer, Report}

  @spam %{
    "RecordType" => "Bounce",
    "Type" => "SpamNotification",
    "TypeCode" => 512,
    "Name" => "Spam notification",
    "Tag" => "",
    "MessageStream" => "outbound",
    "Description" =>
      "The message was delivered, but was either blocked by the user, or classified as spam, bulk mail, or had rejected content.",
    "Email" => "zaphod@example.com",
    "From" => "notifications@honeybadger.io",
    "BouncedAt" => "2023-02-27T21:41:30Z"
  }
  @bounce %{
    "RecordType" => "Bounce",
    "MessageStream" => "outbound",
    "Type" => "HardBounce",
    "TypeCode" => 1,
    "Name" => "Hard bounce",
    "Tag" => "Test",
    "Description" =>
      "The server was unable to deliver your message (ex: unknown user, mailbox not found).",
    "Email" => "arthur@example.com",
    "From" => "notifications@honeybadger.io",
    "BouncedAt" => "2019-11-05T16:33:54.9070259Z"
  }

  describe "CREATE /api/reports" do
    test "Sends a report to slack", %{conn: conn} do
      conn = post conn, "/api/reports", @spam

      assert %{spam: [%Report{type: spam, json: @spam}], other: []} =
               GenServer.call(ReportServer, :get_reports)
    end

    test "Sends a bounce report", %{conn: conn} do
      conn = post conn, "/api/reports", @bounce

      assert %{spam: [], other: [%Report{type: :other, json: @bounce}]} =
               GenServer.call(ReportServer, :get_reports)
    end
  end
end
