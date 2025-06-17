import 'package:feedpal/api/feed_api.dart';
import 'package:feedpal/components/feed_list_item.dart';
import 'package:feedpal/models/article.dart';
import 'package:flutter/material.dart';

enum FeedListState { loading, error, loaded }

typedef FeedListItemBuilder = Widget Function(Article article);

const int itemsPerPage = 20;

/// A list of articles.
/// this component is responsible for fetching the articles and displaying them.
/// it also handles the pagination and the scroll listener.
class FeedList extends StatefulWidget {
  /// the configuration to call our api
  final FeedApiConfig config;

  /// provide it if you want to add some widgets before the first element of the list
  final WidgetBuilder? header;

  /// customize the error page (when no connection for ex)
  final WidgetBuilder? errorBuilder;

  /// provide this if you want to build your own items
  /// (don't forget to add a onTap to redirect the user to the article)
  final FeedListItemBuilder? itemBuilder;

  /// provide this if you want to build your own loader
  final WidgetBuilder? loaderBuilder;

  /// action when a user tap on an item
  /// usually redirect to the article page
  final FeedListItemTapCallback onTapItem;

  const FeedList({
    super.key,
    required this.config,
    required this.onTapItem,
    this.header,
    this.itemBuilder,
    this.errorBuilder,
    this.loaderBuilder,
  });

  @override
  State<FeedList> createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  late ApiClient client;

  final ScrollController scrollController = ScrollController();

  final ValueNotifier<List<Article>?> articles = ValueNotifier<List<Article>?>(
    null,
  );

  int page = 0;

  FeedListState? state;

  PaginatedResponse<Article>? _lastPage;

  @override
  void initState() {
    super.initState();
    client = ApiClient(widget.config);
    _fetchArticles(0);
    scrollController.addListener(_onScroll);
  }

  void _fetchArticles(int page) async {
    if (state == FeedListState.loading) {
      return;
    }
    if (_lastPage != null && _lastPage!.content.length < itemsPerPage) {
      return;
    }
    setState(() => state = FeedListState.loading);
    client
        .listArticles(ListOptions(page: page, itemsPerPage: itemsPerPage)) //
        .then((value) {
          this.page = value.page;
          if (articles.value != null) {
            articles.value = [...articles.value!, ...value.content];
          } else {
            articles.value = value.content;
          }
          _lastPage = value;
          setState(() => state = FeedListState.loaded);
        });
  }

  void _onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      _fetchArticles(page + 1);
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Article>?>(
      valueListenable: articles,
      builder: (context, value, child) {
        if (value == null) {
          return Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              if (widget.header != null)
                SliverToBoxAdapter(child: widget.header!(context)),
              switch (state) {
                FeedListState.error when widget.errorBuilder != null =>
                  SliverToBoxAdapter(child: widget.errorBuilder!(context)),
                FeedListState.error => SliverToBoxAdapter(
                  child: Center(child: Text('Error')),
                ),
                FeedListState.loading when widget.loaderBuilder != null =>
                  SliverToBoxAdapter(child: widget.loaderBuilder!(context)),
                FeedListState.loading when value.isEmpty => SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
                FeedListState.loaded ||
                FeedListState.loading => SliverList.separated(
                  itemBuilder: (context, index) {
                    if (widget.itemBuilder != null) {
                      return widget.itemBuilder!(value[index]);
                    }
                    return FeedListItem(
                      article: value[index],
                      onTap: widget.onTapItem,
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 16),
                  itemCount: value.length,
                ),
                _ => SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
              },
            ],
          ),
        );
      },
    );
  }
}
