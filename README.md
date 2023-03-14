## Setup locally

To start locally Phoenix server:

- Run `mix setup` to install and setup dependencies
- Ensure you have a `SLACK_API_TOKEN` environment variable set
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [localhost:4000](http://localhost:4000) from your browser.

API calls can be done to `localhost:4000/api/reports`.

> Note: I've seen that in the examples there was comma after the last element in
> the list of reports. I've removed it because it caused some internal parsing
> errors.

## Deploy to Fly.io

To deploy to Fly.io you need to have a Fly account and have the Fly CLI installed.

- Run `fly launch --now` to create a new Fly app and deploy the app
- Run `flyctl secrets set SLACK_API_TOKEN=<token of slack>` to set the Slack API
  token
- run `flyctl deploy` to deploy the app again after setting the secret

## Things I'd like to improve with more time

### Add more tests

I've added two tests to ensure the flow of sending the message to Slack
correctly works but more would be nice.

I haven't mocked any tests, so it's sending actual calls to Slack now.

### Broadcast the reports to all users

Currently the LiveView uses polling internally to fetch the reports of a
GenServer. When adding broadcasting new values to the LiveView, streams could
be implemented and have a better realtime experience.

### Split up some code

Split up the send_report function. This would allow more flexibility if other
calls had to be made to slack as well.

### Some styling

I've added minimial styling to the root page, and some things are not aligned
properly, especially when opening the displays.
