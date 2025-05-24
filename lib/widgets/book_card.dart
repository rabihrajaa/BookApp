import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/db_service.dart';

class BookCard extends StatefulWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  _BookCardState createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    checkIfFav();
  }

  void checkIfFav() async {
    final fav = await DBService.isSaved(widget.book.id);
    setState(() {
      isFav = fav;
    });
  }

  void toggleFavorite() async {
    if (isFav) {
      await DBService.deleteItem(widget.book.id);
    } else {
      await DBService.insertItem(widget.book);
    }
    checkIfFav();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: widget.book.thumbnail.isNotEmpty ? Image.network(widget.book.thumbnail) : null,
        title: Text(widget.book.title),
        subtitle: Text(widget.book.author),
        trailing: IconButton(
          icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
          onPressed: toggleFavorite,
        ),
      ),
    );
  }
}
