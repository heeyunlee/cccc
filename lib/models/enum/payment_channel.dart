enum PaymentChannel {
  online,
  inStore,
  other,
}

extension PaymentChannelExtension on PaymentChannel {
  String get str {
    switch (this) {
      case PaymentChannel.online:
        return 'Online';
      case PaymentChannel.inStore:
        return 'In Store';
      case PaymentChannel.other:
        return 'Other';
      default:
        return 'Other';
    }
  }
}
