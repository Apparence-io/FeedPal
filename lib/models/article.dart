class Article {
  final String uid;
  final String? previewImageUrl;
  final DateTime publicationDate;
  final String locale;
  final String title;
  final String slug;
  final String contentPreview;
  final String? content;

  Article({
    required this.uid,
    this.previewImageUrl,
    required this.publicationDate,
    required this.locale,
    required this.title,
    required this.slug,
    required this.contentPreview,
    this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      uid: json['uid'] as String,
      previewImageUrl: json['previewImageUrl'] as String?,
      publicationDate: DateTime.parse(json['publicationDate'] as String),
      locale: json['locale'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      contentPreview: json['contentPreview'] as String,
      content: json['content'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'previewImageUrl': previewImageUrl,
      'publicationDate': publicationDate,
      'locale': locale,
      'title': title,
      'slug': slug,
      'contentPreview': contentPreview,
      'content': content,
    };
  }
}

class PaginatedResponse<T> {
  final List<T> content;
  final int totalElements;
  final int page;
  final int totalPages;

  PaginatedResponse({
    required this.content,
    required this.totalElements,
    required this.page,
    required this.totalPages,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      content: (json['content'] as List).map((e) => fromJsonT(e as Map<String, dynamic>)).toList(),
      totalElements: json['totalElements'] as int,
      page: json['page'] as int,
      totalPages: json['totalPages'] as int,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'content': content.map((e) => toJsonT(e)).toList(),
      'totalElements': totalElements,
      'page': page,
      'totalPages': totalPages,
    };
  }
}

class ListOptions {
  final int page;
  final int? itemsPerPage;

  ListOptions({
    required this.page,
    this.itemsPerPage,
  });

} 