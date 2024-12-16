class Knowledge {
  const Knowledge({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.id,
    this.listFiles = const [],
    this.listGGDrives = const [],
    this.listUrlWebsite = const [],
    this.listSlackFiles = const [],
    this.listConfluenceFiles = const [],
  });

  final String name;
  final String description;
  final String imageUrl;
  final String id;
  final List<String> listFiles;
  final List<String> listGGDrives;
  final List<String> listUrlWebsite;
  final List<String> listSlackFiles;
  final List<String> listConfluenceFiles;

  factory Knowledge.fromJson(Map<String, dynamic> json) {
    return Knowledge(
      name: json['knowledgeName'] ?? '',
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      imageUrl:
          "https://img.freepik.com/premium-photo/green-white-graphic-stack-barrels-with-green-top_1103290-132885.jpg",
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'title': title,
  //     'id': id,
  //     'createdAt': createdAt,
  //   };
  // }
}
