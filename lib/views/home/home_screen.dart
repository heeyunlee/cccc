import 'dart:io';

import 'package:cccc/routes/go_routes.dart';
import 'package:cccc/widgets/custom_adaptive_progress_indicator.dart';
import 'package:cccc/widgets/show_adaptive_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cccc/models/user.dart';
import 'package:cccc/providers.dart' show homeModelProvider;
import 'package:cccc/services/logger_init.dart';
import 'package:cccc/view_models/home_model.dart';
import 'package:cccc/widgets/recent_transactions_card.dart';

import '../../widgets/accounts_card.dart';
import '../../widgets/custom_stream_builder.dart';
import '../../widgets/home_flexible_space_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<HomeScreen> {
  Future<void> onRefresh(BuildContext context, User user) async {
    final status = await ref.read(homeModelProvider).transactionsRefresh(user);

    if (!mounted) return;

    if (status == 404) {
      showAdaptiveDialog(
        context,
        title: 'Refresh Error',
        content:
            'We could not refresh the data. Please re-authenticate your account using the Plaid Link',
        defaultActionText: 'OK',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.d('[Home] building... on Web? $kIsWeb');

    final model = ref.watch(homeModelProvider);

    return Scaffold(
      key: const ValueKey('HomeScreenScaffold'),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: CustomStreamBuilder<User?>(
        errorBuilder: (context, error) => Center(
          child: Text('An Error Occurred. Error code: ${error.toString()}'),
        ),
        loadingWidget: const CustomAdaptiveProgressIndicator(),
        stream: model.userStream,
        builder: (context, user) {
          if (user != null) {
            final theme = Theme.of(context);

            switch (theme.platform) {
              case TargetPlatform.iOS:
              case TargetPlatform.macOS:
                return _customScrollWidget(context, user, model);
              case TargetPlatform.android:
              case TargetPlatform.fuchsia:
              case TargetPlatform.linux:
              case TargetPlatform.windows:
                return RefreshIndicator(
                  onRefresh: () => onRefresh(context, user),
                  child: _customScrollWidget(context, user, model),
                );
            }
          } else {
            return const CustomAdaptiveProgressIndicator();
          }
        },
      ),
    );
  }

  Widget _customScrollWidget(
    BuildContext context,
    User user,
    HomeModel model,
  ) {
    final media = MediaQuery.of(context);
    final padding = MediaQuery.of(context).padding;

    return CustomScrollView(
      slivers: [
        if (!kIsWeb && Platform.isIOS)
          CupertinoSliverRefreshControl(
            onRefresh: () => onRefresh(context, user),
            builder: (context, mode, __, ___, ____) {
              return Container(
                height: media.padding.top + 136,
                color: Colors.black,
                child: const Align(
                  alignment: Alignment.bottomCenter,
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            },
          ),
        SliverAppBar(
          stretch: true,
          pinned: true,
          backgroundColor: Colors.black,
          expandedHeight: media.size.height * 0.6,
          stretchTriggerOffset: media.size.height * 0.2,
          centerTitle: true,
          title: Text(model.today),
          leading: IconButton(
            icon: const Icon(Icons.photo_camera),
            onPressed: () => const ScanReceiptRoute().push(context),
          ),
          actions: [
            IconButton(
              onPressed: () => const SettingsRoute().push(context),
              icon: const Icon(Icons.settings),
            ),
            const SizedBox(width: 8),
          ],
          flexibleSpace: const HomeFlexibleSpaceBar(),
        ),
        SliverToBoxAdapter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 16),
              AccountsCard(model: model),
              const SizedBox(height: 16),
              RecentTransactionsCard(
                transactionsStream: model.transactionsStream,
              ),
              SizedBox(height: padding.bottom + 32),
            ],
          ),
        ),
      ],
    );
  }
}
