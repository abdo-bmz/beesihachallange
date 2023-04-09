import 'comic_model.dart';

class Character {
  final int id;
  final String name;
  final String description;
  final String thumbnailUrl;
  final String wikiLink;
  final List<Comic> comics;

  Character({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnailUrl,
    required this.wikiLink,
    required this.comics,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    final List<dynamic> urls =
        List<Map<String, dynamic>>.from(json['urls'] ?? []);
    final List<dynamic> comics =
        List<Map<String, dynamic>>.from(json['comics']['items'] ?? []);

    return Character(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      thumbnailUrl:
          '${json['thumbnail']['path'] ?? ''}.${json['thumbnail']['extension'] ?? ''}',
      wikiLink: urls
              .firstWhere(
                (url) => url['type'] == 'wiki',
                orElse: () => {'url': null},
              )['url']
              ?.toString() ??
          '',
      comics: comics.map((comicJson) => Comic.fromJson(comicJson)).toList(),
    );
  }
}


