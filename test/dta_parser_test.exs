defmodule DtaParserTest do
  use ExUnit.Case
  doctest DtaParser

  test "parsing a complete file" do
    result = DtaParser.parse("data/sample.dta")

    assert result == %DtaParser.File{
      header_record: %DtaParser.RowRecord{
        :amount               => "00000004223",
        :code                 => "05",
        :code_extension       => "000",
        :currency             => "1",
        :extensions_count     => "00",
        :internal_customer_no => "0000000000000",
        :receiver_account_no  => "0987654321",
        :receiver_bank_code   => "70080000",
        :receiver_name        => "RECEIVER NAME",
        :sender_account_no    => "0123456789",
        :sender_bank_code     => "70022200",
        :sender_name          => "FIDOR BANK",
        :subject              => "THE SUBJECT"
      },
      row_records: [
        %DtaParser.RowRecord{
          :amount               => "00000004223",
          :code                 => "05",
          :code_extension       => "000",
          :currency             => "1",
          :extensions_count     => "00",
          :internal_customer_no => "0000000000000",
          :receiver_account_no  => "0987654321",
          :receiver_bank_code   => "70080000",
          :receiver_name        => "RECEIVER NAME",
          :sender_account_no    => "0123456789",
          :sender_bank_code     => "70022200",
          :sender_name          => "FIDOR BANK",
          :subject              => "THE SUBJECT"
        },
        %DtaParser.RowRecord{
          :amount               => "00000004223",
          :code                 => "05",
          :code_extension       => "000",
          :currency             => "1",
          :extensions_count     => "00",
          :internal_customer_no => "0000000000000",
          :receiver_account_no  => "0987654321",
          :receiver_bank_code   => "70080000",
          :receiver_name        => "RECEIVER NAME",
          :sender_account_no    => "0123456789",
          :sender_bank_code     => "70022200",
          :sender_name          => "FIDOR BANK",
          :subject              => "THE SUBJECT"
        }
      ],
      footer_record: %DtaParser.FooterRecord{
        :bookings_count  => "0000003",
        :sum_account_nos => "00000003333333330",
        :sum_amounts     => "0000000012669",
        :sum_bank_codes  => "00000000420306600"
      }
    }
  end
end
