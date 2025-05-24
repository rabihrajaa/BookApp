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
  backgroundColor: Colors.grey[100],
  body: Column(
    children: [
      Container(
        decoration: BoxDecoration(
          color: Colors.blue[700],
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 20),
        margin: const EdgeInsets.only(bottom: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '📚 Recherche de livres',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.white),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FavoritesPage()),
              ),
            ),
          ],
        ),
      ),

      //Zone de recherche et résultats
      Expanded(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: 'Mot-clé',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onChanged: (val) => query = val,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
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
      ),
    ],
  ),
);

  }
}