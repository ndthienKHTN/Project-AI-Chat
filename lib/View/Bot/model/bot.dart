class Bot {
  const Bot(
      {required this.name,
      required this.prompt,
      required this.team,
      required this.imageUrl,
      required this.isPublish});

  final String name;
  final String prompt;
  final String team;
  final String imageUrl;
  final bool isPublish;
}
