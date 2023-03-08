defmodule ReportComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div id="report-\#{@id}" class="report">
      <div class={["send-status", status(@report)]}>
        <time datetime={@report.bounced_at} class="time">
          <%= @report.bounced_at %>
        </time>

        <div>
          <%= @report.email %>
        </div>
      </div>

      <details class="details">
        <summary>Full JSON</summary>
        <code>
          <pre><%= Jason.encode!(@report.json, pretty: true) %></pre>
        </code>
      </details>
    </div>
    """
  end

  def status(%{status_code: 200}), do: "success"
  def status(%{status_code: nil}), do: nil
  def status(%{status_code: _}), do: "fail"
end
