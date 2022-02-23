import 'package:cccc/services/logger_init.dart';
import 'package:cccc/widgets/show_adaptive_alert_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Very similar to [PaginatedListView] widget I created but instead of simple
/// SingleChildScrollView, this widget uses [CustomScrollView] so that you can
/// put SliverAppBar as a header, for example.
class PaginatedCustomScrollView<T> extends StatefulWidget {
  const PaginatedCustomScrollView({
    Key? key,
    required this.query,
    required this.listItemBuilder,
    this.listViewPadding,
    this.headerSliver,
    this.emptyWidget,
    this.loadingFooterSliver,
  }) : super(key: key);

  /// Query for the [ListView.builder]
  final Query<T> query;

  /// Builder for the itemBuilder in the [ListView]
  final Widget Function(BuildContext context, T item) listItemBuilder;

  /// [ListView] padding.
  final EdgeInsets? listViewPadding;

  /// Widget to be displayed on top of the [ListView] widget
  final Widget? headerSliver;

  /// Widget to be displayed when the fetched data from the Query returns the
  /// empty list
  final Widget? emptyWidget;

  /// Widget to be displayed at the bottom of the [ListView] widget when the
  /// widget is loading, i.e., still fetching the data
  final Widget? loadingFooterSliver;

  @override
  _PaginatedCustomScrollViewState createState() =>
      _PaginatedCustomScrollViewState();
}

class _PaginatedCustomScrollViewState<T>
    extends State<PaginatedCustomScrollView<T>> {
  late ScrollController _controller;
  late List<T> _list;
  late bool _isLoading;
  late QueryDocumentSnapshot<T>? _lastDocumentSnapshot;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _isLoading = false;
    _list = <T>[];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _fetchQuery();

    _controller.addListener(() {
      final maxScroll = _controller.position.maxScrollExtent;
      final currentPosition = _controller.position.pixels;
      final delta = MediaQuery.of(context).size.height * 0.25;

      if (maxScroll - currentPosition <= delta) {
        if (_lastDocumentSnapshot != null) {
          _fetchTransactions();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleIsLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Future<void> _fetchQuery() async {
    _toggleIsLoading();
    final snapshot = await widget.query.get();
    _handleQuerySnapshot(snapshot);

    _toggleIsLoading();
  }

  Future<void> _fetchTransactions() async {
    try {
      if (!_isLoading) {
        if (_lastDocumentSnapshot != null) {
          _toggleIsLoading();

          final nextQuery = widget.query.startAfterDocument(
            _lastDocumentSnapshot!,
          );
          final snapshot = await nextQuery.get();
          _handleQuerySnapshot(snapshot);
        }

        _toggleIsLoading();
      }
    } catch (e) {
      logger.e(e);

      await showAdaptiveDialog(
        context,
        title: 'title',
        content: e.toString(),
        defaultActionText: 'OK',
      );
    }
  }

  void _handleQuerySnapshot(QuerySnapshot<T> snapshot) {
    final docs = snapshot.docs;
    _lastDocumentSnapshot = docs.isNotEmpty ? docs.last : null;

    final newFetchedList = docs.map((e) => e.data()).toList();
    _list.addAll(newFetchedList);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scrollbar(
      child: CustomScrollView(
        controller: _controller,
        slivers: [
          if (widget.headerSliver != null) widget.headerSliver!,
          SliverToBoxAdapter(
            child: _list.isEmpty
                ? widget.emptyWidget ??
                    SizedBox(
                      width: size.width,
                      height: size.height,
                      child: const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _list.length,
                    padding: widget.listViewPadding,
                    itemBuilder: (context, index) {
                      final item = _list[index];

                      return widget.listItemBuilder(context, item);
                    },
                  ),
          ),
          if (_isLoading)
            widget.loadingFooterSliver ??
                SliverToBoxAdapter(
                  child: SizedBox(
                    width: size.width,
                    height: 48,
                    child: const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
