defmodule Mix.Tasks.ParseDta do
  use Mix.Task

  @shortdoc "Parse DTA file and output it's content"
  def run(args) do
    case args do
      [] -> parse()
      _  -> parse(hd(args))
    end
  end

  defp parse(file \\ "data/sample.dta") do
    DtaParser.parse(file)
  end
end
