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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 181, 213, 239).withOpacity(0.2),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 181, 213, 239).withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: widget.book.thumbnail.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(widget.book.thumbnail, width: 50, fit: BoxFit.cover),
              )
            : null,
        title: Text(
          widget.book.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
        subtitle: Text(
          widget.book.author,
          style: TextStyle(
            color: Colors.blue[700],
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            isFav ? Icons.favorite : Icons.favorite_border,
            color: isFav ? Colors.red : Colors.grey,
          ),
          onPressed: toggleFavorite,
        ),
      ),
    );
  }
}
