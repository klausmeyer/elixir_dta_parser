defmodule DtaParser.RowRecord do
  defstruct [:receiver_bank_code,
             :receiver_account_no,
             :internal_customer_no,
             :code,
             :code_extension,
             :sender_bank_code,
             :sender_account_no,
             :amount,
             :receiver_name,
             :sender_name,
             :subject,
             :currency,
             :extensions_count]
end
