class AIItem {
  final String name;
  final String logoPath;
  int tokenCount;
  final String id;

  AIItem({
    required this.name,
    required this.logoPath,
    required this.tokenCount,
    required this.id,
  });

  factory AIItem.fromJson(Map<String, dynamic> json) {
    return AIItem(
      name: json['name'] ?? '',
      logoPath: json['logoPath'] ?? '',
      tokenCount: json['tokenCount'] ?? 0,
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'logoPath': logoPath,
      'tokenCount': tokenCount,
      'id': id,
    };
  }

  AIItem copyWith({
    String? name,
    String? logoPath,
    int? tokenCount,
    String? id,
  }) {
    return AIItem(
      name: name ?? this.name,
      logoPath: logoPath ?? this.logoPath,
      tokenCount: tokenCount ?? this.tokenCount,
      id: id ?? this.id,
    );
  }
}
