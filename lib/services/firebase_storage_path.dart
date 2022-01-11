class FirebaseStoragePath {
  static String receipts(String uid) => 'users/$uid/receipts';
  static String receipt(String uid, String receiptId) =>
      'users/$uid/receipts/$receiptId';
  static String resizedReceipt(String uid, String receiptId) =>
      'users/$uid/receipts/resized/${receiptId}_800x800';
}
