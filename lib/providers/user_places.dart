import 'dart:io';

import 'package:favorite_palces/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
    return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY ,title TEXT ,image TEXT ,lat REAL ,lng REAL)');
  },
      version:
          1 // this fuction will be executed if the file is created for first time
      );
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final db = await getDatabase();
    final data = await db.query('user_places');
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
                latitude: row['lat'] as double,
                longitude: row['lng'] as double),
          ),
        )
        .toList();

    state = places;
  } //accessing data from database

  void addPlace(String title, File image, PlaceLocation location) async {
    final appDir =
        await syspath.getApplicationDocumentsDirectory(); //directory object

    final fileName = path.basename(image.path); //getting path

    final copiedImage = await image.copy(
        '${appDir.path}/$fileName'); //copying image using path of that image
    final newPlace =
        Place(title: title, image: copiedImage, location: location);
    // Forwarded copird image to image argument
    final db = await getDatabase();
    db.insert(
      'user_places',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'lat': newPlace.location.latitude,
        'lng': newPlace.location.longitude,
      },
    ); //inserting values

    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
