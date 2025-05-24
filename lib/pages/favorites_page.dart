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
                  color: const Color.fromARGB(255, 181, 213, 239).withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 20),
            child: Row(
              children: [
                // 🔙 Flèche retour
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 8),
                const Text(
                  'Vos favoris',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          //Liste des livres favoris
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: futureBooks,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final books = snapshot.data!;
                if (books.isEmpty) {
                  return const Center(
                    child: Text("Aucun livre favori.", style: TextStyle(fontSize: 16)),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        leading: book.thumbnail.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(book.thumbnail, width: 50, fit: BoxFit.cover),
                              )
                            : null,
                        title: Text(
                          book.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                        subtitle: Text(
                          book.author,
                          style: TextStyle(color: Colors.blue[700]),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await DBService.deleteItem(book.id);
                            refresh();
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
