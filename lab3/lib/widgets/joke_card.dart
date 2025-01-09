import 'package:flutter/material.dart';

class JokeCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final bool isFavorite;

  const JokeCard({
    Key? key,
    required this.title,
    required this.onTap,
    required this.onFavorite,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          title.isNotEmpty
              ? title[0].toUpperCase() + title.substring(1)
              : title,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: onFavorite,
            ),
            const Icon(Icons.arrow_forward),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}