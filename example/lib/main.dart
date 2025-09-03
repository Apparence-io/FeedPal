import 'package:feedpal/feed.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

final config = FeedApiConfig(
  // Replace with your own API key.
  apiKey: 'hlfkdshdfjkshdf!3234',
  // Replace with device locale or let the API use default locale
  locale: 'en',
);

final feed = Feed(config: config);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      onGenerateRoute:
          (settings) => switch (settings.name) {
            '/' => MaterialPageRoute(builder: (context) => MyHomePage()),
            '/article' => MaterialPageRoute(
              builder:
                  (context) => ArticlePage(slug: settings.arguments as String),
            ),
            _ => throw Exception('Unknown route: ${settings.name}'),
          },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: feed.buildList(
          context,
          headerBuilder:
              (context) => Column(
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
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                ],
              ),
          onTapItem: (article) {
            Navigator.pushNamed(context, '/article', arguments: article.slug);
          },
        ),
      ),
    );
  }
}

class ArticlePage extends StatelessWidget {
  final String slug;

  const ArticlePage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: feed.buildArticle(context, slug));
  }
}
