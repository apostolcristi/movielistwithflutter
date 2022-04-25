import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:movielistwithflutter/src/models/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kFavoriteMovieKey = 'user_favorite_movie';

class AuthApi {
  AuthApi(this._auth, this._preferences);

  final FirebaseAuth _auth;
  final SharedPreferences _preferences;

  Future<AppUser?> getCurrentUser() async {
    if (_auth.currentUser != null) {
      final List<int> favorites = _getCurrentFavorites();

      return AppUser(
          email: _auth.currentUser!.email!,
          uid: _auth.currentUser!.uid,
          username: _auth.currentUser!.displayName!,
          favoriteMovies: favorites);
    }
    return null;
  }

  Future<AppUser> login({required String email, required String password}) async {
    final UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);

    final List<int> favorite = _getCurrentFavorites();

    return AppUser(
        email: email, uid: credential.user!.uid, username: credential.user!.displayName!, favoriteMovies: favorite);
  }

  Future<AppUser> create({required String email, required String password, required String username}) async {
    final UserCredential credentials = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _auth.currentUser!.updateDisplayName(username);

    return AppUser(email: email, uid: credentials.user!.uid, username: username);
  }

  Future<void> addFavoriteMovie(int id, {required bool add}) async {
    final List<int> ids = _getCurrentFavorites();
    if (add) {
      ids.add(id);
    } else {
      ids.remove(id);
    }
    await _preferences.setString(_kFavoriteMovieKey, jsonEncode(ids));
  }

  List<int> _getCurrentFavorites() {
    final String? data = _preferences.getString(_kFavoriteMovieKey);
    List<int> ids;
    if (data != null) {
      ids = List<int>.from(jsonDecode(data) as List<dynamic>);
    } else {
      ids = <int>[];
    }
    return ids;
  }
}
