import 'dart:io';

import 'package:cccc/services/logger_init.dart';
import 'package:cccc/models/user.dart';
import 'package:cccc/view/scan_receipts_screen.dart';
import 'package:cccc/view_models/home_screen_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cccc/widgets/recent_transactions_card.dart';
import 'package:cccc/view/settings_screen.dart';
import '../widgets/accounts_card.dart';
import '../widgets/custom_stream_builder.dart';
import '../widgets/home_flexible_space_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.d('[Home] building... on Web? $kIsWeb');

    final model = ref.watch(homeScreenModelProvider);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: CustomStreamBuilder<User?>(
        stream: model.userStream,
        builder: (context, user) {
          if (kIsWeb) {
            return _customScrollWidget(context, user!, model);
          } else {
            if (Platform.isIOS) {
              return _customScrollWidget(context, user!, model);
            } else {
              return RefreshIndicator(
                onRefresh: () => model.fetchData(context, user!),
                child: _customScrollWidget(context, user!, model),
              );
            }
          }
        },
      ),
    );
  }

  Widget _customScrollWidget(
    BuildContext context,
    User user,
    HomeScreenModel model,
  ) {
    final media = MediaQuery.of(context);

    return CustomScrollView(
      slivers: [
        if (!kIsWeb && Platform.isIOS)
          CupertinoSliverRefreshControl(
            onRefresh: () => model.fetchData(context, user),
            builder: (context, _, __, ___, ____) {
              return Shimmer.fromColors(
                highlightColor: Colors.green,
                baseColor: Colors.lightGreen,
                child: Container(
                  height: media.padding.top + 48,
                  color: Colors.lightGreen,
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
            onPressed: () => ScanReceiptsScreen.show(context),
          ),
          actions: [
            IconButton(
              onPressed: () => SettingsScreen.show(context),
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
              RecentTransactionsCard(model: model),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }
}
