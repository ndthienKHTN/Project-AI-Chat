enum Category {
  business,
  career,
  chatbot,
  coding,
  education,
  fun,
  marketing,
  other,
  productivity,
  seo,
  writing,
}

extension CategoryExtension on Category {
  String get name => toString().split('.').last;
}

class PromptRequest {
  final Category? category;
  final bool? isFavorite;
  final bool? isPublic;
  final int? limit;
  final int? offset;
  final String? query;

  PromptRequest({
    this.category,
    this.isFavorite,
    this.isPublic,
    this.limit,
    this.offset,
    this.query,
  });

  Map<String, dynamic> toJson() {
    return {
      if (category != null) 'category': category!.name,
      if (isFavorite != null) 'isFavorite': isFavorite,
      if (isPublic != null) 'isPublic': isPublic,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (query != null) 'query': query,
    };
  }
}
