import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'services/db_service.dart';
import 'models/book.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await seedTestBooks();
  runApp(BookApp());
}

class BookApp extends StatelessWidget {
  const BookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

// Fonction pour insérer des livres de test
Future<void> seedTestBooks() async {
  final books = [
    Book(
      id: 'test1',
      title: 'Book 1',
      author: 'Rajaa Rabih',
      thumbnail: 'https://via.placeholder.com/100x150.png?text=Flutter1',
    ),
    Book(
      id: 'test2',
      title: 'Book 2',
      author: 'Soufiane Rabih',
      thumbnail: 'https://via.placeholder.com/100x150.png?text=Dart',
    ),
    Book(
      id: 'test3',
      title: 'Book3',
      author: 'Marwa Rabih',
      thumbnail: 'https://via.placeholder.com/100x150.png?text=SQLite',
    ),
  ];

  for (var book in books) {
    final exists = await DBService.isSaved(book.id);
    if (!exists) {
      await DBService.insertItem(book);
    }
  }

  print('Livres de test insérés dans la base SQLite');
}
