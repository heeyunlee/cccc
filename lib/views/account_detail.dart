import 'package:cccc/models/plaid/account.dart';
import 'package:cccc/models/plaid/institution/institution.dart';
import 'package:cccc/models/plaid/transaction.dart';
import 'package:cccc/routes/route_names.dart';
import 'package:cccc/styles/button_styles.dart';
import 'package:cccc/styles/decorations.dart';
import 'package:cccc/styles/text_styles.dart';
import 'package:cccc/view_models/account_detail_screen_model.dart';
import 'package:cccc/widgets/account_circle_avatar.dart';
import 'package:cccc/widgets/account_detail_bottom_sheet.dart';
import 'package:cccc/widgets/custom_stream_builder.dart';
import 'package:cccc/widgets/transaction_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountDetail extends ConsumerStatefulWidget {
  const AccountDetail({
    Key? key,
    required this.account,
    required this.institution,
  }) : super(key: key);

  final Account account;
  final Institution? institution;

  static Future<void> show(
    BuildContext context, {
    required Account account,
    required Institution? institution,
  }) async {
    await Navigator.of(context).pushNamed(
      RouteNames.account,
      arguments: {'account': account, 'institution': institution},
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountDetailState();
}

class _AccountDetailState extends ConsumerState<AccountDetail>
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
    final size = MediaQuery.of(context).size;
    final model = ref.watch(accountDetailScreenModelProvider(widget.account));

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
              child: Text(model.name),
            ),
            actions: [
              IconButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => AccountDetailBottomSheet(
                    account: widget.account,
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
                      widget.institution?.primaryColor,
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
                            model.mask,
                            style: TextStyles.body2White38,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            model.currentAmount,
                            style: TextStyles.h4W900,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Flexible(
                                child: FittedBox(
                                  child: Text(
                                    model.name,
                                    style: TextStyles.subtitle1BoldWhite70,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              InstitutionCircleAvatar(
                                institution: widget.institution,
                                diameter: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                model.lastSyncedDate,
                                style: TextStyles.overlineWhite54,
                              ),
                              const SizedBox(width: 8),
                              model.connectionStateIcon,
                            ],
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 32,
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Transactions',
                          style: TextStyles.subtitle1Bold,
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          style: ButtonStyles.text2,
                          child: Row(
                            children: const [
                              Text('View More'),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward, size: 16)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Colors.white12,
                    child: CustomStreamBuilder<List<Transaction?>>(
                      stream: model.transactionsStream,
                      loadingWidget: const SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorBuilder: (context, error) => SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Row(
                          children: [
                            const Icon(Icons.error, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(
                              'An Error Occurred. Error code: ${error.toString()}',
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      builder: (context, data) {
                        if (data != null && data.isNotEmpty) {
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final transaction = data[index]!;

                              return TransactionListTile(
                                transaction: transaction,
                              );
                            },
                          );
                        } else {
                          return const SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: Center(
                              child: Text('No transactions'),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
