import 'package:cccc/extensions/enum_extension.dart';

enum AccountSubtype {
  i401a,
  i401k,
  i403B,
  i457b,
  i529,
  brokerage,
  cashIsa,
  educationSavingsAccount,
  ebt,
  fixedAnnuity,
  gic,
  healthReimbursementArrangement,
  hsa,
  isa,
  ira,
  lif,
  lifeInsurance,
  lira,
  lrif,
  lrsp,
  nonTaxableBrokerageAccount,
  other,
  otherInsurance,
  otherAnnuity,
  prif,
  rdsp,
  resp,
  rlif,
  rrif,
  pension,
  profitSharingPlan,
  retirement,
  roth,
  roth401k,
  rrsp,
  sepIra,
  simpleIra,
  sipp,
  stockPlan,
  thriftSavingsPlan,
  tfsa,
  trust,
  ugma,
  utma,
  variableAnnuity,
  creditCard,
  paypal,
  cd,
  checking,
  savings,
  moneyMarket,
  prepaid,
  auto,
  business,
  commercial,
  construction,
  consumer,
  homeEquity,
  loan,
  mortgage,
  overdraft,
  lineOfCredit,
  student,
  cashManagement,
  keogh,
  mutualFund,
  recurring,
  rewards,
  safeDeposit,
  sarsep,
  payroll,
  nullValue,
}

extension EnumToString on AccountSubtype {
  String get string {
    switch (this) {
      case AccountSubtype.i401a:
        return '401a';
      case AccountSubtype.i401k:
        return '401k';
      case AccountSubtype.i403B:
        return '403B';
      case AccountSubtype.i457b:
        return '457b';
      case AccountSubtype.i529:
        return '529';
      case AccountSubtype.nonTaxableBrokerageAccount:
        return 'non-taxable brokerage account';
      default:
        // return name;
        return enumToString(this);
    }
  }
}

extension EnumToTitle on AccountSubtype {
  String get title {
    switch (this) {
      case AccountSubtype.i401a:
        return '401(a)';
      case AccountSubtype.i401k:
        return '401(k)';
      case AccountSubtype.i403B:
        return '403(b)';
      case AccountSubtype.i457b:
        return '457(b)';
      case AccountSubtype.i529:
        return '529';
      case AccountSubtype.nonTaxableBrokerageAccount:
        return 'Non-taxable Brokerage Account';
      case AccountSubtype.cashIsa:
        return 'Cash ISA';
      case AccountSubtype.roth401k:
        return 'Roth 401(k)';
      case AccountSubtype.simpleIra:
        return 'Simple IRA';
      case AccountSubtype.cd:
      case AccountSubtype.ebt:
      case AccountSubtype.hsa:
      case AccountSubtype.isa:
      case AccountSubtype.ira:
      case AccountSubtype.lif:
      case AccountSubtype.lira:
      case AccountSubtype.lrif:
      case AccountSubtype.lrsp:
      case AccountSubtype.prif:
      case AccountSubtype.rdsp:
      case AccountSubtype.resp:
      case AccountSubtype.sepIra:
      case AccountSubtype.sarsep:
        return enumToString(this).toUpperCase();
      default:
        return enumToTitle(this);
    }
  }
}
