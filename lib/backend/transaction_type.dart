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