import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/book_card.dart';
import '../models/book.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Book> books = [];
  String query = '';
  final controller = TextEditingController();

  Future<void> searchBooks() async {
    final results = await ApiService.fetchBooks(query);
    setState(() {
      books = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recherche de livres'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FavoritesPage()),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(labelText: 'Mot-clé'),
                    onChanged: (val) => query = val,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: searchBooks,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: books.map((book) => BookCard(book: book)).toList(),
            ),
          )
        ],
      ),
    );
  }
}