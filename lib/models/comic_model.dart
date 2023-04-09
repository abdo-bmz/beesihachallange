class Comic {
  final String name;
  final String resourceUri;

  Comic({required this.name, required this.resourceUri});

  factory Comic.fromJson(Map<String, dynamic> json) {
    return Comic(
      name: json['name'] ?? '',
      resourceUri: json['resourceURI'] ?? '',
    );
  }
}