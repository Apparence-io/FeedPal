import 'package:feedpal/models/article.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

typedef FeedListItemTapCallback = void Function(Article article);

class FeedListItem extends StatelessWidget {
  final Article article;
  final FeedListItemTapCallback onTap;

  const FeedListItem({super.key, required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap(article);
      },
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        height: 400,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (article.previewImageUrl != null)
              Expanded(
                child: Hero(
                  tag: '${article.slug}-image',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      article.previewImageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 12),
            Text(
              DateFormat('MMM d, yyyy').format(article.publicationDate),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            SizedBox(height: 4),
            Text(
              article.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(
              article.contentPreview,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
