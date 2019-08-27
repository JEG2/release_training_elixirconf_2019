defmodule Exercise.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Exercise.RPNCalculator, [options: [name: Exercise.RPNCalculator]]},
      {Exercise.SimulatedUser, [options: [name: Exercise.SimulatedUser]]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Exercise.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
