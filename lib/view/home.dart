import 'dart:io';

import 'package:cccc/constants/logger_init.dart';
import 'package:cccc/model/user.dart';
import 'package:cccc/services/cloud_functions.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cccc/view/recent_transactions_card.dart';
import 'package:cccc/view/settings_screen.dart';
import 'custom_stream_builder.dart';
import 'home_flexible_space_bar.dart';
import 'package:shimmer/shimmer.dart';

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    logger.d('[Home] building...');

    final auth = ref.watch(authProvider);
    final uid = auth.currentUser?.uid;
    final database = ref.watch(databaseProvider(uid))!;
    final functions = ref.watch(cloudFunctionsProvider);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: CustomStreamBuilder<User?>(
        stream: database.userStream(),
        builder: (context, user) {
          if (Platform.isIOS) {
            return _customScrollWidget(user!);
          } else {
            return RefreshIndicator(
              onRefresh: () => functions.fetchTransactionsData(context, user!),
              child: _customScrollWidget(user!),
            );
          }
        },
      ),
    );
  }

  Widget _customScrollWidget(User user) {
    final size = MediaQuery.of(context).size;
    final functions = ref.watch(cloudFunctionsProvider);

    return CustomScrollView(
      slivers: [
        if (Platform.isIOS)
          CupertinoSliverRefreshControl(
            onRefresh: () => functions.fetchTransactionsData(context, user),
            builder: (context, _, __, ___, ____) {
              return Shimmer.fromColors(
                highlightColor: Colors.green,
                baseColor: Colors.lightGreen,
                child: Container(
                  height: MediaQuery.of(context).padding.top + 48,
                  color: Colors.lightGreen,
                ),
              );
            },
          ),
        SliverAppBar(
          stretch: true,
          pinned: true,
          expandedHeight: size.height * 0.6,
          stretchTriggerOffset: 120,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              SizedBox(height: 16),
              RecentTransactionsCard(),
              SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }
}
