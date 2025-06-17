import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart' as md;
import 'package:intl/intl.dart';
import 'package:markdown/src/ast.dart' as mdast show Element;

import 'package:feedpal/api/feed_api.dart';
import 'package:feedpal/models/article.dart';

enum ArticleViewState { loading, error, loaded }

typedef ArticleViewBuilder =
    Widget Function(ArticleViewState state, Article? article);

class ArticleView extends StatefulWidget {
  final String slug;

  final ArticleViewBuilder? builder;

  final FeedApiConfig config;

  const ArticleView({
    super.key,
    required this.slug,
    required this.config,
    this.builder,
  });

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  late final ApiClient _client;

  Article? _article;

  ArticleViewState _state = ArticleViewState.loading;

  @override
  void initState() {
    super.initState();
    _client = ApiClient(widget.config);
    _fetchArticle();
  }

  void _fetchArticle() async {
    try {
      final article = await _client.getArticle(slug: widget.slug);
      setState(() {
        _state = ArticleViewState.loaded;
        _article = article;
      });
    } catch (e) {
      setState(() {
        _state = ArticleViewState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return widget.builder!(_state, _article);
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: true,
            expandedHeight: 350,
            flexibleSpace: FlexibleSpaceBar(
              background:
                  _article?.previewImageUrl != null
                      ? Hero(
                        tag: '${_article!.slug}-image',
                        child: Image.network(
                          _article!.previewImageUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                      : null,
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: switch (_state) {
              ArticleViewState.loading => const Center(
                child: CircularProgressIndicator(),
              ),
              ArticleViewState.error => const Center(
                child: Text('Error loading article'),
              ),
              ArticleViewState.loaded => Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      DateFormat(
                        'MMM d, yyyy',
                      ).format(_article?.publicationDate ?? DateTime.now()),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _article?.title ?? '',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      _article?.contentPreview ?? '',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 12),
                    Divider(color: Colors.grey[300], thickness: 1),
                    SizedBox(height: 12),
                    md.Markdown(
                      selectable: true,
                      data: _article?.content ?? '',
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      paddingBuilders: {
                        'p': CustomPadding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                        ),
                      },
                    ),
                    SizedBox(height: 80),
                  ],
                ),
              ),
            },
          ),
        ],
      ),
    );
  }
}

class CustomPadding implements md.MarkdownPaddingBuilder {
  final EdgeInsets padding;

  CustomPadding({required this.padding});

  @override
  EdgeInsets getPadding() {
    return padding;
  }

  @override
  void visitElementBefore(mdast.Element element) {}
}
