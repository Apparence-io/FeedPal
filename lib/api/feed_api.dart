import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/article.dart';

const String _backendUrl = 'https://back.thefeedpal.app';

/// Configuration for the Feed API.
class FeedApiConfig {
  // The base URL of the API. By default it's the FeedPal backend and you don't need to change it.
  final String baseUrl;

  // The API key to use for the API. (copied from the dashboard)
  final String apiKey;

  // The locale to use for the API.
  final String? locale;

  // Just for debugging purposes, don't use in production.
  final bool debugMode;

  // The base URI of the API.
  final Uri _baseUrl;

  FeedApiConfig({
    required this.apiKey,
    this.baseUrl = _backendUrl,
    this.locale,
    this.debugMode = false,
  }) : _baseUrl = Uri.parse(baseUrl);

  String get baseUrlScheme => _baseUrl.scheme;

  String get baseUrlHost => _baseUrl.host;

  int get baseUrlPort => _baseUrl.port;
}

class ApiClient {
  final FeedApiConfig config;

  ApiClient(this.config);

  Future<T> _request<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    final url = Uri(
      scheme: config.baseUrlScheme,
      host: config.baseUrlHost,
      path: endpoint,
      queryParameters: queryParams,
      port: config.baseUrlPort,
    );
    _log('Requesting $url');
    final response = await http.get(
      url,
      headers: {'Authorization': config.apiKey, ...?headers},
    );

    if (response.statusCode != 200) {
      throw Exception(
        'API request failed: ${response.statusCode} ${response.reasonPhrase}',
      );
    }

    return json.decode(response.body) as T;
  }

  void _log(String message) {
    if (config.debugMode) {
      debugPrint(message);
    }
  }

  Future<String> status() async {
    return _request<String>('/api/status');
  }

  Future<PaginatedResponse<Article>> listArticles(ListOptions options) async {
    try {
      final response = await _request<Map<String, dynamic>>(
        '/api/articles',
        queryParams: {
          'language': config.locale ?? '',
          'page': options.page.toString(),
          'pageSize': (options.itemsPerPage ?? 20).toString(),
        },
      );

      return PaginatedResponse<Article>.fromJson(
        response,
        (json) => Article.fromJson(json),
      );
    } catch (error) {
      _log(
        'Error fetching articles with options ${options.toString()}: $error',
      );
      rethrow;
    }
  }

  Future<Article?> getArticle({required String slug}) async {
    try {
      Map<String, String> queryParams = {'language': config.locale ?? ''};
      final response = await _request<Map<String, dynamic>>(
        '/api/articles/$slug',
        queryParams: queryParams,
      );
      return Article.fromJson(response);
    } catch (error, stackTrace) {
      _log(
        'Error fetching article with slug "$slug" and locale "${config.locale}": $error',
      );
      _log(stackTrace.toString());
      rethrow;
    }
  }
}
