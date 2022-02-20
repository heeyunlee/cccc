class FirestorePath {
  static String users() => 'users';
  static String user(String uid) => 'users/$uid';

  static String transactions(String uid) => 'users/$uid/transactions';
  static String transaction(String uid, String transactionId) =>
      'users/$uid/transactions/$transactionId';

  static String accounts(String uid) => 'users/$uid/accounts';
  static String account(String uid, String accountId) =>
      'users/$uid/accounts/$accountId';

  static String institution(String id) => 'institutions/$id';

  static String merchants() => 'merchants';
  static String merchant(String id) => 'merchants/$id';

  static String products(String merchantId) => 'merchants/$merchantId/products';
  static String product(String merchantId, String productId) =>
      'merchants/$merchantId/products/$productId';
}
