defmodule DtaParser do
  def main(args) do
    [ file | _ ] = args

    parse(file)
  end

  def parse(file) do
    IO.puts "File: #{file}"

    File.read!(file)
    |> parse_header
    |> parse_rows(1)
    |> parse_footer
  end

  defp parse_header(string) do
    << "0128A", header :: binary-size(123), remaining :: binary >> = string

    <<
      type               :: binary-size( 2),
      receiver_bank_code :: binary-size( 8),
      sender_bank_code   :: binary-size( 8),
      sender_name        :: binary-size(27),
      _                  :: binary-size( 4),
      date               :: binary-size( 6),
      sender_account_no  :: binary-size(10),
      reference          :: binary-size(10),
      _                  :: binary-size(47),
      currency           :: binary-size( 1),
    >> = header

    IO.puts ""
    IO.puts "Header:"
    IO.puts "----------"
    IO.puts ""
    IO.puts "Type               : #{type}"
    IO.puts "Date               : #{date}"
    IO.puts "Receiver Bank Code : #{receiver_bank_code}"
    IO.puts "Sender Bank Code   : #{sender_bank_code}"
    IO.puts "Sender Account No  : #{sender_account_no}"
    IO.puts "Sender Name        : #{sender_name}"
    IO.puts "Reference          : #{reference}"
    IO.puts "Currency           : #{currency}"

    remaining
  end

  defp parse_rows(<< "0128E", footer :: binary >>, _) do
    footer
  end

  defp parse_rows(string, counter) do
    << _ :: binary-size(4), "C", row :: binary-size(251), remaining :: binary >> = string

    <<
      _                    :: binary-size( 8),
      receiver_bank_code   :: binary-size( 8),
      receiver_account_no  :: binary-size(10),
      internal_customer_no :: binary-size(13),
      code                 :: binary-size( 2),
      code_extension       :: binary-size( 3),
      _                    :: binary-size( 1),
      _                    :: binary-size(11),
      sender_bank_code     :: binary-size( 8),
      sender_account_no    :: binary-size(10),
      amount               :: binary-size(11),
      _                    :: binary-size( 3),
      receiver_name        :: binary-size(27),
      _                    :: binary-size( 8),
      sender_name          :: binary-size(27),
      subject              :: binary-size(27),
      currency             :: binary-size( 1),
      _                    :: binary-size( 2),
      extensions_count     :: binary-size( 2),
      _                    :: binary-size(58),
      _                    :: binary-size(11)
    >> = row

    IO.puts ""
    IO.puts "Row #{counter}:"
    IO.puts "----------"
    IO.puts ""
    IO.puts "Sender Name          : #{String.strip(sender_name)}"
    IO.puts "Sender Bank Code     : #{String.strip(sender_bank_code)}"
    IO.puts "Sender Account No    : #{String.strip(sender_account_no)}"
    IO.puts ""
    IO.puts "Receiver Name        : #{String.strip(receiver_name)}"
    IO.puts "Receiver Bank Code   : #{String.strip(receiver_bank_code)}"
    IO.puts "Receiver Account No  : #{String.strip(receiver_account_no)}"
    IO.puts "Internal Customer No : #{String.strip(internal_customer_no)}"
    IO.puts ""
    IO.puts "Subject              : #{String.strip(subject)}"
    IO.puts "Code                 : #{String.strip(code)}"
    IO.puts "Code Extension       : #{String.strip(code_extension)}"
    IO.puts ""
    IO.puts "Amount               : #{String.strip(amount)}"
    IO.puts "Currency             : #{String.strip(currency)}"

    IO.puts "No of Extensions     : #{String.strip(extensions_count)}"

    parse_rows(remaining, counter + 1)
  end

  defp parse_footer(string) do
    <<
      _               :: binary-size( 5),
      bookings_count  :: binary-size( 7),
      _               :: binary-size(13),
      sum_bank_codes  :: binary-size(17),
      sum_account_nos :: binary-size(17),
      sum_amounts     :: binary-size(13),
      _               :: binary
    >> = string

    IO.puts ""
    IO.puts "Footer:"
    IO.puts "----------"
    IO.puts ""
    IO.puts "Bookings Count    : #{bookings_count}"
    IO.puts "SUM Bank Codes    : #{sum_bank_codes}"
    IO.puts "SUM Bank Accounts : #{sum_account_nos}"
    IO.puts "SUM Amounts       : #{sum_amounts}"
  end
end
