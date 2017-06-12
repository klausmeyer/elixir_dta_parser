defmodule DtaParser do
  def parse(file) do
    File.read!(file)
    |> parse_header
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

    %DtaParser.HeaderRecord{
      :type               => String.trim(type),
      :receiver_bank_code => String.trim(receiver_bank_code),
      :sender_bank_code   => String.trim(sender_bank_code),
      :sender_name        => String.trim(sender_name),
      :date               => String.trim(date),
      :sender_account_no  => String.trim(sender_account_no),
      :reference          => String.trim(reference),
      :currency           => String.trim(currency)
    }

    parse_rows(remaining, 1, [])
  end

  defp parse_rows(<< "0128E", footer :: binary >>, _, list) do
    parse_footer(footer, list)
  end

  defp parse_rows(string, counter, list) do
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

    record = %DtaParser.RowRecord{
      :receiver_bank_code   => String.trim(receiver_bank_code),
      :receiver_account_no  => String.trim(receiver_account_no),
      :internal_customer_no => String.trim(internal_customer_no),
      :code                 => String.trim(code),
      :code_extension       => String.trim(code_extension),
      :sender_bank_code     => String.trim(sender_bank_code),
      :sender_account_no    => String.trim(sender_account_no),
      :amount               => String.trim(amount),
      :receiver_name        => String.trim(receiver_name),
      :sender_name          => String.trim(sender_name),
      :subject              => String.trim(subject),
      :currency             => String.trim(currency),
      :extensions_count     => String.trim(extensions_count)
    }

    parse_rows(remaining, counter + 1, [record|list])
  end

  defp parse_footer(string, list) do
    <<
      _               :: binary-size( 5),
      bookings_count  :: binary-size( 7),
      _               :: binary-size(13),
      sum_bank_codes  :: binary-size(17),
      sum_account_nos :: binary-size(17),
      sum_amounts     :: binary-size(13),
      _               :: binary
    >> = string

    [header_record|row_records] = list

    footer_record = %DtaParser.FooterRecord{
      :bookings_count  => String.trim(bookings_count),
      :sum_bank_codes  => String.trim(sum_bank_codes),
      :sum_account_nos => String.trim(sum_account_nos),
      :sum_amounts     => String.trim(sum_amounts)
    }

    %DtaParser.File{
      :header_record => header_record,
      :row_records   => row_records,
      :footer_record => footer_record
    }
  end
end
