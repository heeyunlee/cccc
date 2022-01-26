import 'dart:io';

import 'package:cccc/services/logger_init.dart';
import 'package:cccc/models/user.dart';
import 'package:cccc/view/scan_receipt.dart';
import 'package:cccc/view_models/home_screen_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cccc/widgets/recent_transactions_card.dart';
import 'package:cccc/view/settings.dart';
import '../widgets/accounts_card.dart';
import '../widgets/custom_stream_builder.dart';
import '../widgets/home_flexible_space_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.d('[Home] building... on Web? $kIsWeb');

    final model = ref.watch(homeScreenModelProvider);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: CustomStreamBuilder<User?>(
        errorBuilder: (context, error) => Center(
          child: Text('An Error Occurred. Error code: ${error.toString()}'),
        ),
        loadingWidget: const Center(child: CircularProgressIndicator()),
        stream: model.userStream,
        builder: (context, user) {
          if (user != null) {
            if (kIsWeb) {
              return _customScrollWidget(context, user, model);
            } else {
              if (Platform.isIOS) {
                return _customScrollWidget(context, user, model);
              } else {
                return RefreshIndicator(
                  onRefresh: () => model.transactionsRefresh(context, user),
                  child: _customScrollWidget(context, user, model),
                );
              }
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
            onRefresh: () => model.transactionsRefresh(context, user),
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
            onPressed: () => ScanReceipt.show(context),
          ),
          actions: [
            IconButton(
              onPressed: () => Settings.show(context),
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
              SizedBox(height: 32 + MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ],
    );
  }
}
