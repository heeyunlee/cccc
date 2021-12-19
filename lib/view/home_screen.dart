import 'dart:convert';

import 'package:cccc/model/user.dart';
import 'package:cccc/services/firestore_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:cccc/constants/cloud_functions.dart';
import 'package:cccc/constants/keys.dart';
import 'package:cccc/constants/logger_init.dart';
import 'package:cccc/services/firebase_auth.dart';
import 'package:cccc/view/recent_transactions_card.dart';
import 'package:cccc/view/settings_screen.dart';
import 'package:cccc/view/show_adaptive_alert_dialog.dart';

import 'custom_stream_builder.dart';
import 'home_flexible_space_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Future<void> _fetchTransactionData(User user) async {
    if (user.plaidAccessToken != null) {
      try {
        final database = ref.watch(databaseProvider)!;
        final uid = ref.read(authProvider).currentUser!.uid;
        final now = DateTime.now();

        final uri = Uri(
          scheme: 'https',
          host: Keys.cloudFunctionHost,
          path: CloudFunctions.fetchTransactionData,
        );

        final startDate =
            user.lastPlaidSyncTime ?? now.subtract(const Duration(days: 30));

        final response = await http.post(
          uri,
          body: json.encode({
            'uid': uid,
            'start_date': startDate.toString(),
            'end_date': DateTime(now.year, now.month, now.day).toString(),
          }),
        );

        if (response.statusCode == 200) {
          final updatedUserData = {
            'lastPlaidSyncTime': DateTime.now(),
          };

          await database.updateUser(user, updatedUserData);
        }

        logger.d('Response: ${response.statusCode}');
      } catch (e) {
        logger.e(e);

        showAdaptiveAlertDialog(
          context,
          title: 'Refresh failed',
          content: 'Refresh failed. Please try again later.',
          defaultActionText: 'OK',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final database = ref.watch(databaseProvider)!;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: CustomStreamBuilder<User?>(
          stream: database.userStream(),
          builder: (context, user) {
            return RefreshIndicator(
              onRefresh: () => _fetchTransactionData(user!),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: size.height * 0.5,
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
              ),
            );
          }),
    );
  }
}
