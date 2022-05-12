enum PlaidProduct {
  assets,
  auth,
  balance,
  identity,
  investments,
  liabilities,
  paymentInitiation,
  transactions,
  creditDetails,
  income,
  incomeVerification,
  depositSwitch,
  standingOrders,
  transfer,
  employment,
  others,
}

extension PlaidProductToString on PlaidProduct {
  String get string {
    switch (this) {
      case PlaidProduct.assets:
        return 'assets';
      case PlaidProduct.auth:
        return 'auth';
      case PlaidProduct.balance:
        return 'balance';
      case PlaidProduct.identity:
        return 'identity';
      case PlaidProduct.investments:
        return 'investments';
      case PlaidProduct.liabilities:
        return 'liabilities';
      case PlaidProduct.paymentInitiation:
        return 'payment_initiation';
      case PlaidProduct.transactions:
        return 'transactions';
      case PlaidProduct.creditDetails:
        return 'credit_details';
      case PlaidProduct.income:
        return 'income';
      case PlaidProduct.incomeVerification:
        return 'income_verification';
      case PlaidProduct.depositSwitch:
        return 'deposit_switch';
      case PlaidProduct.standingOrders:
        return 'standing_orders';
      case PlaidProduct.transfer:
        return 'transfer';
      case PlaidProduct.employment:
        return 'employment';
      case PlaidProduct.others:
        return 'others';
    }
  }
}
