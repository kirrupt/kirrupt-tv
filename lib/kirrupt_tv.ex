defmodule KirruptTv do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      KirruptTv.Repo,
      # Start the endpoint when the application starts
      KirruptTv.Endpoint,
      # Start the scheduler
      KirruptTv.Scheduler,
      {Phoenix.PubSub, name: KirruptTv.PubSub},
      KirruptTv.Telemetry
      # Start your own worker by calling: KirruptTv.Worker.start_link(arg1, arg2, arg3)
      # worker(KirruptTv.Worker, [arg1, arg2, arg3]),
    ]

    shows_path = Path.join(KirruptTv.Helpers.FileHelpers.root_folder(), "static/shows")
    IO.puts("static/shows path: #{shows_path}")

    if File.exists?("/data/shows") do
      IO.puts("/data/shows exist, using it")
      File.ln_s!("/data/shows", shows_path)
    else
      IO.puts("/data/shows missing, creating new directory")
      File.mkdir_p(shows_path)
    end

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KirruptTv.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    KirruptTv.Endpoint.config_change(changed, removed)
    :ok
  end
end
