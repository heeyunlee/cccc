import 'package:cccc/extensions/enum_extension.dart';
import 'package:cccc/enum/account_subtype.dart';
import 'package:cccc/enum/plaid_institution_health_incident_status.dart';
import 'package:cccc/enum/plaid_institution_refresh_interval.dart';
import 'package:cccc/enum/plaid_product.dart';
import 'package:cccc/enum/standing_order_interval.dart';

extension CapExtension on String {
  String get title {
    final split = this.split(' ');
    final iter = split.map(
      (e) => e[0].toUpperCase() + e.substring(1).toLowerCase(),
    );

    return iter.join(' ');
  }

  String get lowerCamelCase {
    if (contains(' ')) {
      final camel = split(' ').sublist(1).map((e) => e.title).join();
      final lower = split(' ')[0].toLowerCase();
      final lowerCamel = lower + camel;

      return lowerCamel;
    } else if (contains('_')) {
      final camel = split('_').sublist(1).map((e) => e.title).join();
      final lower = split('_')[0].toLowerCase();
      final lowerCamel = lower + camel;

      return lowerCamel;
    } else {
      final firstLetter = this[0].toLowerCase();
      final remainderLetters = substring(1);

      return firstLetter + remainderLetters;
    }
  }

  T toEnum<T>(List<T> values) {
    return values.firstWhere((e) => lowerCamelCase == enumToString(e));
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

extension AccountSubtypeFromString on String {
  AccountSubtype get accountSubtype {
    switch (this) {
      case '401a':
        return AccountSubtype.i401a;
      case '401k':
        return AccountSubtype.i401k;
      case '403B':
        return AccountSubtype.i403B;
      case '457b':
        return AccountSubtype.i457b;
      case '529':
        return AccountSubtype.i529;
      case 'non-taxable brokerage account':
        return AccountSubtype.nonTaxableBrokerageAccount;
      default:
        return toEnum(AccountSubtype.values);
    }
  }
}
