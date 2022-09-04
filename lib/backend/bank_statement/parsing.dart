const String bankStatementEntryDelimiter = ';';
const Map<String, int> col2Index = {
  'date': 0,
  'type': 2,
  'partner': 3,
  'purpose': 4,
  'expense': 15,
  'revenue': 16,
  'currency': 17
};

enum TransactionType{
  sepaDirectDebit,
  sepaCredit,
  sepaStandingOrder,
  sepaTransactionOut,
  cardPayment,
  atmCashOut,
  unknown
}

const Map<TransactionType, String> transactionTypeName = {
  TransactionType.sepaDirectDebit: 'SEPA Direct Debit',
  TransactionType.sepaCredit: 'SEPA Credit',
  TransactionType.sepaStandingOrder: 'SEPA Standing Order',
  TransactionType.sepaTransactionOut: 'SEPA Transaction Out',
  TransactionType.cardPayment: 'Card Payment',
  TransactionType.atmCashOut: 'ATM Cash Out',
  TransactionType.unknown: 'Unknown'
};

const Map<String, TransactionType> identifier2TransactionType = {
  'SEPA-Lastschrift von': TransactionType.sepaDirectDebit,
  'SEPA-Lastschrift (ELV) von': TransactionType.sepaDirectDebit,

  'SEPA-Gutschrift von': TransactionType.sepaCredit,
  'SEPA-Dauerauftrag an': TransactionType.sepaStandingOrder,
  'SEPA-Überweisung an': TransactionType.sepaTransactionOut,
  'Kartenzahlung': TransactionType.cardPayment,
  'Auszahlung Geldautomat': TransactionType.atmCashOut
};

const Map<String, String> currencyRepresentation2Target = {
  'EUR': '€'
};