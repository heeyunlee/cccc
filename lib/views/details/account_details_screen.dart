import 'package:cccc/enum/account_type.dart';
import 'package:cccc/extensions/datetime_extension.dart';
import 'package:cccc/models/plaid/account.dart';
import 'package:flutter/material.dart';
import 'package:cccc/enum/account_subtype.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cccc/providers.dart'
    show
        accountProvider,
        accountTransactionsStreamProvider,
        institutionProvider;
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/styles/decorations.dart';
import 'package:cccc/styles/text_styles.dart';
import 'package:cccc/widgets/account_circle_avatar.dart';
import 'package:cccc/widgets/account_detail_bottom_sheet.dart';
import 'package:cccc/widgets/recent_transactions_card.dart';
import 'package:intl/intl.dart';

class AccountDetailScreen extends ConsumerStatefulWidget {
  const AccountDetailScreen({
    required this.accountId,
    super.key,
  });

  final String accountId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountDetailState();
}

class _AccountDetailState extends ConsumerState<AccountDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityTween;
  late Animation<Offset> _offsetTween;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration.zero);

    _opacityTween =
        Tween<double>(begin: 0, end: 1).animate(_animationController);
    _offsetTween =
        Tween<Offset>(begin: const Offset(0, 8), end: const Offset(0, 0))
            .animate(_animationController);
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController.addListener(() {
      final position = _scrollController.position.pixels;
      _animationController.animateTo(
          (position - MediaQuery.of(context).size.height / 10) / 100);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('[AccountDetail] screen building...');

    final asyncAccount = ref.watch(accountProvider(widget.accountId));

    return asyncAccount.when<Widget>(
      data: (account) {
        if (account == null) return const Placeholder();

        return _buildScaffold(account);
      },
      error: (error, stackTrace) => const Placeholder(),
      loading: () => const CircularProgressIndicator.adaptive(),
    );
  }

  Widget _buildScaffold(Account account) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    final mask =
        '**${account.mask} • ${account.subtype?.title ?? account.type.str}';
    final f = NumberFormat.simpleCurrency(
      name: account.balance.isoCurrencyCode,
      decimalDigits: 2,
    );
    final currentAmount = f.format(account.balance.current);
    final accountLastSyncedTime = account.accountLastSyncedTime;

    // if (accountLastSyncedTime != null) {
    //   return 'Last synced ${accountLastSyncedTime.timeago}';
    // } else {
    //   return 'Last synced time not available';
    // }

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: true,
            stretch: true,
            expandedHeight: size.height / 4,
            backgroundColor: Colors.black,
            title: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: _offsetTween.value,
                  child: Opacity(
                    opacity: _opacityTween.value,
                    child: child,
                  ),
                );
              },
              child: Text(account.name),
            ),
            actions: [
              IconButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => AccountDetailBottomSheet(
                    accountId: widget.accountId,
                  ),
                ),
                icon: const Icon(Icons.more_vert),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    decoration: Decorations.gradientFromHexString(
                      ref
                          .watch(institutionProvider(account.institutionId))
                          .when(
                            data: (institution) => institution?.primaryColor,
                            error: (error, stackTrace) => '',
                            loading: () => '',
                          ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            mask,
                            style: TextStyles.body2White38,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentAmount,
                            style: TextStyles.h4W900,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Flexible(
                                child: FittedBox(
                                  child: Text(
                                    account.officialName ?? account.name,
                                    style: TextStyles.subtitle1BoldWhite70,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              InstitutionCircleAvatar(
                                account: account,
                                institution: ref
                                    .watch(institutionProvider(
                                        account.institutionId))
                                    .value,
                                diameter: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            accountLastSyncedTime != null
                                ? 'Last synced ${accountLastSyncedTime.timeago}'
                                : 'Last synced time not available',
                            style: TextStyles.overlineWhite54,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: RecentTransactionsCard(
              transactionsStream: ref.watch(
                accountTransactionsStreamProvider(account.accountId).stream,
              ),
              titleTextStyle: TextStyles.subtitle1Bold,
              bottomPaddingHeight: padding.bottom + 16,
            ),
          ),
        ],
      ),
    );
  }
}
