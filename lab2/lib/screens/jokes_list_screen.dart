import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../models/joke.dart';

class JokesListScreen extends StatelessWidget {
  final String type;
  final ApiService apiService = ApiService();

  JokesListScreen({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${type.isNotEmpty ? type[0].toUpperCase() + type.substring(1) : type} jokes')),
      body: FutureBuilder<List<Joke>>(
        future: apiService.getJokesByType(type),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No jokes found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final joke = snapshot.data![index];
                return ListTile(
                  title: Text(joke.setup),
                  subtitle: Text(joke.punchline),
                );
              },
            );
          }
        },
      ),
    );
  }
}