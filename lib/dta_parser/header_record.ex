defmodule DtaParser.HeaderRecord do
  defstruct [:type,
            :receiver_bank_code,
            :sender_bank_code,
            :sender_name,
            :date,
            :sender_account_no,
            :reference,
            :currency]
end
