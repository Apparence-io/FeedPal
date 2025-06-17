# FeedPal

Grow your app and turn your users into fans Feed your blog and mobile app with
fresh, engaging content automatically and effortlessly.

- show your articles on your blog
- automatically translate to all the locales you want
- AI assistant that helps you to write your articles
- Schedule your articles to be published at the right time
- Publish your articles on your app with this package
- Notify your users with push notifications when a new article is published
- and more...

## Usage

### 1. Create a Feed instance

```dart
import 'package:feedpal/feed.dart';

final feed = Feed(
  config: FeedApiConfig(
    // copied from the FeedPal dashboard
    apiKey: 'hlfkdshdfj...', 
    // the locale of the articles
    // (optional default to default locale configure in the dashboard)
    locale: 'en', 
  ),
);
```

### 2. Build the list

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[100],
    body: SafeArea(
      // build the list with the feed instance
      child: feed.buildList(
        context,
        // provide a header if you want to add a title and a description
        headerBuilder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              "Ressources", 
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 8),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", 
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
        // on tap item, redirect to the article page
        onTapItem: (article) {
          Navigator.pushNamed(context, '/article', arguments: article.slug);
        },
      ),
    ),
  );
}
```

### 3. Build the article view page

You can use our premade article view page with the following code:

```dart
feed.buildArticle(context, slug),
```

```dart
class ArticlePage extends StatelessWidget {
  final String slug;

  const ArticlePage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: feed.buildArticle(context, slug),
    );
  }
}
```

or you can build your own article view page with the following code:

```dart
feed.buildArticle(context, slug, builder: (state, article) {
  return Scaffold(
    body: ..., // your own article view page
  );
});
```

the `state` is the state of the article view and the `article` is the article
object.

```dart
enum ArticleViewState { loading, error, loaded }
```
