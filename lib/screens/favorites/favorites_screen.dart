import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorite_characters_provider.dart';
import '../characters/character_details.screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<FavoritesCharactersProvider>(context, listen: false)
        .loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('Favorites'),
          automaticallyImplyLeading: false),
      body: Consumer<FavoritesCharactersProvider>(
        builder: (context, favoritesProvider, child) {
          if (favoritesProvider.favorites.isEmpty) {
            return const Center(child: Text('No favorites YET!!'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: favoritesProvider.favorites.length,
              itemBuilder: (context, index) {
                final character = favoritesProvider.favorites[index];
                return ListTile(
                  title: Text(character.name),
                  subtitle: Text(character.description),
                  leading: Image.network(character.thumbnailUrl),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CharacterDetailsScreen(character: character),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
