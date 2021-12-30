import 'dart:io';

import 'package:cccc/model/user.dart';
import 'package:cccc/services/cloud_functions.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cccc/view/recent_transactions_card.dart';
import 'package:cccc/view/settings_screen.dart';
import 'custom_stream_builder.dart';
import 'home_flexible_space_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final database = ref.watch(databaseProvider)!;
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
        SliverAppBar(
          expandedHeight: size.height * 0.6,
          actions: [
            IconButton(
              onPressed: () => SettingsScreen.show(context),
              icon: const Icon(Icons.settings),
            ),
            const SizedBox(width: 8),
          ],
          flexibleSpace: const HomeFlexibleSpaceBar(),
        ),
        if (Platform.isIOS)
          CupertinoSliverRefreshControl(
            onRefresh: () => functions.fetchTransactionsData(context, user),
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
