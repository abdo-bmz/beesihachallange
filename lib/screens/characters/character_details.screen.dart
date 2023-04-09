import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helper.dart';
import '../../models/character_model.dart';
import '../../providers/favorite_characters_provider.dart';

class CharacterDetailsScreen extends StatefulWidget {
  final Character character;

  const CharacterDetailsScreen({Key? key, required this.character})
      : super(key: key);

  @override
  State<CharacterDetailsScreen> createState() => _CharacterDetailsScreenState();
}

class _CharacterDetailsScreenState extends State<CharacterDetailsScreen> {
  late FavoritesCharactersProvider _favoriteProvider;

  @override
  void initState() {
    super.initState();
    _favoriteProvider = FavoritesCharactersProvider();
    _favoriteProvider.loadFavoriteStatus(widget.character.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _favoriteProvider,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.character.name),
          actions: [
            Consumer<FavoritesCharactersProvider>(
              builder: (context, provider, child) => TextButton(
                onPressed: () =>
                    provider.toggleFavorite(widget.character.id.toString()),
                child: Icon(
                  provider.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: provider.isFavorite ? Colors.red : Colors.yellow,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(widget.character.thumbnailUrl),
              const SizedBox(height: 16),
              Text(
                widget.character.description,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              const Text(
                'Comics:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                children: widget.character.comics
                    .map((comic) => ListTile(
                          title: Text(comic.name),
                          trailing: IconButton(
                            icon: const Icon(Icons.open_in_new),
                            onPressed: () async {
                              await HelperFunctions.launchOpenURL(
                                  comic.resourceUri);
                            },
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
