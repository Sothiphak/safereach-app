class FirstAidTip {
  const FirstAidTip({
    required this.id,
    required this.title,
    required this.summary,
    required this.imageAsset,
    required this.steps,
  });

  final String id;
  final String title;
  final String summary;
  final String imageAsset;
  final List<String> steps;

  factory FirstAidTip.fromJson(Map<String, dynamic> json) {
    return FirstAidTip(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      imageAsset: json['imageAsset'] as String,
      steps: (json['steps'] as List<dynamic>).cast<String>(),
    );
  }
}
