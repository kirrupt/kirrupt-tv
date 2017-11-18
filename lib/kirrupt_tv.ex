defmodule KirruptTv do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(KirruptTv.Repo, []),
      # Start the endpoint when the application starts
      supervisor(KirruptTv.Endpoint, []),
      # Start your own worker by calling: KirruptTv.Worker.start_link(arg1, arg2, arg3)
      # worker(KirruptTv.Worker, [arg1, arg2, arg3]),
    ]

    if !File.exists?(Path.join(KirruptTv.Helpers.FileHelpers.root_folder, "static/shows")) do
      IO.puts File.ln_s("/app/shows", Path.join(KirruptTv.Helpers.FileHelpers.root_folder, "static/shows"))
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
