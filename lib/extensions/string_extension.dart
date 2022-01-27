import 'package:cccc/extensions/enum_extension.dart';
import 'package:cccc/models/enum/plaid_institution_health_incident_status.dart';
import 'package:cccc/models/enum/plaid_institution_refresh_interval.dart';
import 'package:cccc/models/enum/plaid_product.dart';
import 'package:cccc/models/enum/standing_order_interval.dart';

extension CapExtension on String {
  String get title {
    final split = this.split(' ');
    final iter = split.map((e) => e[0].toUpperCase() + e.substring(1));

    return iter.join(' ');
  }

  T toEnum<T>(List<T> values) {
    if (contains(' ')) {
      final camel = split(' ').sublist(1).map((e) => e.title).join();
      final lower = split(' ')[0];
      final lowerCamel = lower + camel;

      return values.firstWhere((e) => lowerCamel == enumToString(e));
    } else {
      return values.firstWhere((e) => this == enumToString(e));
    }
  }
}

extension PlaidProductFromString on String {
  PlaidProduct get plaidProduct {
    switch (this) {
      case 'assets':
        return PlaidProduct.assets;
      case 'auth':
        return PlaidProduct.auth;
      case 'balance':
        return PlaidProduct.balance;
      case 'identity':
        return PlaidProduct.identity;
      case 'investments':
        return PlaidProduct.investments;
      case 'liabilities':
        return PlaidProduct.liabilities;
      case 'payment_initiation':
        return PlaidProduct.paymentInitiation;
      case 'transactions':
        return PlaidProduct.transactions;
      case 'credit_details':
        return PlaidProduct.creditDetails;
      case 'income':
        return PlaidProduct.income;
      case 'income_verification':
        return PlaidProduct.incomeVerification;
      case 'deposit_switch':
        return PlaidProduct.depositSwitch;
      case 'standing_orders':
        return PlaidProduct.standingOrders;
      case 'transfer':
        return PlaidProduct.transfer;
      case 'employment':
        return PlaidProduct.employment;
      default:
        return PlaidProduct.others;
    }
  }
}

extension PlaidInstitutionRefreshIntervalFromString on String {
  PlaidInstitutionRefreshInterval get refreshInterval {
    switch (this) {
      case 'NORMAL':
        return PlaidInstitutionRefreshInterval.normal;
      case 'DELAYED':
        return PlaidInstitutionRefreshInterval.delayed;
      case 'STOPPED':
        return PlaidInstitutionRefreshInterval.stopped;
      default:
        return PlaidInstitutionRefreshInterval.others;
    }
  }
}

extension PlaidInstitutionHealthIncidentStatusFromString on String {
  PlaidInstitutionHealthIncidentStatus get healthIncidentStatus {
    switch (this) {
      case 'INVESTIGATING':
        return PlaidInstitutionHealthIncidentStatus.investigating;
      case 'IDENTIFIED':
        return PlaidInstitutionHealthIncidentStatus.identified;
      case 'SCHEDULED':
        return PlaidInstitutionHealthIncidentStatus.scheduled;
      case 'RESOLVED':
        return PlaidInstitutionHealthIncidentStatus.resolved;
      case 'UNKNOWN':
        return PlaidInstitutionHealthIncidentStatus.unknown;
      default:
        return PlaidInstitutionHealthIncidentStatus.others;
    }
  }
}

extension StandingOrderIntervalFromString on String {
  StandingOrderInterval get standingOrderInterval {
    switch (this) {
      case 'WEEKLNY':
        return StandingOrderInterval.weekly;
      case 'MONTHLY':
        return StandingOrderInterval.monthly;
      default:
        return StandingOrderInterval.weekly;
    }
  }
}
