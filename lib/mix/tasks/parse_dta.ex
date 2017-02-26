defmodule Mix.Tasks.ParseDta do
  use Mix.Task

  @shortdoc "Parse DTA file and output it's content"
  def run(_) do
    DtaParser.parse
  end
end
