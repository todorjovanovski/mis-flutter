import 'package:flutter/material.dart';
import 'package:lab2/screens/jokes_list_screen.dart';
import 'package:lab2/widgets/joke_card.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_jokes_provider.dart';

class FavoriteJokesScreen extends StatelessWidget {
  const FavoriteJokesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Jokes'),
      ),
      body: Consumer<FavoriteJokesProvider>(
        builder: (context, favoriteProvider, _) {
          final favoriteJokes = favoriteProvider.favoriteJokes;

          return favoriteJokes.isEmpty
              ? const Center(child: Text('No favorite jokes yet.'))
              : ListView.builder(
                  itemCount: favoriteJokes.length,
                  itemBuilder: (context, index) {
                    final joke = favoriteJokes[index];
                    return JokeCard(
                      title: joke,
                      isFavorite: favoriteProvider.isFavorite(joke),
                      onFavorite: () => favoriteProvider.toggleFavorite(joke),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => JokesListScreen(type: joke),
                          ),
                        );
                      },
                    );
                  },
                );
        },
      ),
    );
  }
}
