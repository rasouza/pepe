use Mix.Config

config :logger, :console, metadata: :all

import_config "#{Mix.env()}.exs"
