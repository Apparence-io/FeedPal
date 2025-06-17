import 'package:feedpal/api/feed_api.dart';
import 'package:feedpal/components/article_view.dart';
import 'package:feedpal/components/feed_list.dart';
import 'package:feedpal/components/feed_list_item.dart';
import 'package:flutter/material.dart';

export 'models/article.dart';

typedef WidgetBuilder = Widget Function(BuildContext context);

class Feed {
  final FeedApiConfig config;

  Feed({required this.config});

  Widget buildList(
    BuildContext context, {
    required FeedListItemTapCallback onTapItem,
    WidgetBuilder? headerBuilder,
    FeedListItemBuilder? itemBuilder,
    WidgetBuilder? loaderBuilder,
    WidgetBuilder? errorBuilder,
  }) {
    return FeedList(
      config: config,
      onTapItem: onTapItem,
      header: headerBuilder,
      itemBuilder: itemBuilder,
      errorBuilder: errorBuilder,
    );
  }

  Widget buildArticle(BuildContext context, String slug) {
    return ArticleView(slug: slug, config: config);
  }
}
