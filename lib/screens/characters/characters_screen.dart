import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helper.dart';
import '../../providers/api_service_provider.dart';
import 'character_details.screen.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  _CharactersScreenState createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final apiProvider =
          Provider.of<ApiServiceProvider>(context, listen: false);
      apiProvider.loadCharacters();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final double scrollPercentage = 100 *
        _scrollController.position.pixels /
        _scrollController.position.maxScrollExtent;
    final apiProvider = Provider.of<ApiServiceProvider>(context, listen: false);
    if (scrollPercentage > 80 && !apiProvider.isLoading) {
      apiProvider.loadCharacters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('Characters'),
          automaticallyImplyLeading: false),
      body: Consumer<ApiServiceProvider>(
        builder: (context, apiProvider, _) {
          final characters = apiProvider.characters;
          return ListView.builder(
            controller: _scrollController,
            itemCount: characters.length + 1,
            itemBuilder: (context, index) {
              if (index == characters.length) {
                return _buildLoadingIndicator(apiProvider.isLoading);
              } else {
                final character = characters[index];
                return ListTile(
                  leading: Image.network(character.thumbnailUrl),
                  title: Text(character.name),
                  subtitle: Text('ID: ${character.id}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.open_in_new),
                    onPressed: () async {
                      await HelperFunctions.launchOpenURL(character.wikiLink);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CharacterDetailsScreen(character: character),
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator(bool isLoading) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container();
  }
}
