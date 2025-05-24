import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../models/book.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<Book>> futureBooks;

  @override
  void initState() {
    super.initState();
    futureBooks = DBService.getItems();
  }

  void refresh() {
    setState(() {
      futureBooks = DBService.getItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favoris')),
      body: FutureBuilder<List<Book>>(
        future: futureBooks,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final books = snapshot.data!;
          return ListView(
            children: books.map((book) => ListTile(
              leading: book.thumbnail.isNotEmpty ? Image.network(book.thumbnail) : null,
              title: Text(book.title),
              subtitle: Text(book.author),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  await DBService.deleteItem(book.id);
                  refresh();
                },
              ),
            )).toList(),
          );
        },
      ),
    );
  }
}
