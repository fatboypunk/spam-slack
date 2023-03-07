defmodule SpamSlack.Reports.Report do
  defstruct id: nil,
            json: nil,
            status_code: nil,
            type: :other,
            email: nil,
            bounced_at: nil,
            created_at: nil
end
