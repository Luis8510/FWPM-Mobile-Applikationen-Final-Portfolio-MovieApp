import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/rating.dart';

class RatingRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> submitRating({
    required int movieId,
    required String movieName,
    required int rating,
    required String userId,
    required String username,
  }) async {
    final batch = _db.batch();

    final movieRef = _db.collection('movies').doc(movieId.toString());
    final movieRatingRef = movieRef.collection('ratings').doc(userId);

    final userRef = _db.collection('users').doc(userId);
    final userRatedMovieRef =
        userRef.collection('ratedMovies').doc(movieId.toString());

    final now = FieldValue.serverTimestamp();

    batch.set(
        movieRef,
        {
          'name': movieName,
        },
        SetOptions(merge: true));

    batch.set(
      movieRatingRef,
      {
        'rating': rating,
        'username': username,
        'userId': userId,
        'createdAt': now,
      },
      SetOptions(merge: true),
    );

    batch.set(
      userRatedMovieRef,
      {
        'rating': rating,
        'createdAt': now,
      },
      SetOptions(merge: true),
    );

    await batch.commit();
  }

  Stream<List<Rating>> friendRatings(int movieId) {
    return _db
        .collection('movies')
        .doc(movieId.toString())
        .collection('ratings')
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Rating.fromDoc(doc)).toList());
  }

  Future<List<int>> loadMovieIdsFromFriends(
    String userId, {
    int pageSize = 500,
  }) async {
    final ratedSnap = await _db
        .collection('users')
        .doc(userId)
        .collection('ratedMovies')
        .get();

    final ratedIds = ratedSnap.docs.map((d) => d.id).toList();

    if (ratedIds.isEmpty) {
      final snap = await _db.collection('movies').get();
      return snap.docs.map((d) => int.parse(d.id)).toList()..sort();
    }

    if (ratedIds.length <= 30) {
      final snap = await _db
          .collection('movies')
          .where(FieldPath.documentId, whereNotIn: ratedIds)
          .get();
      return snap.docs.map((d) => int.parse(d.id)).toList()..sort();
    }

    final ids = <int>[];
    DocumentSnapshot? cursor;

    while (true) {
      Query q = _db
          .collection('movies')
          .orderBy(FieldPath.documentId)
          .limit(pageSize);

      if (cursor != null) q = q.startAfterDocument(cursor);

      final page = await q.get();
      if (page.docs.isEmpty) break;

      for (final doc in page.docs) {
        if (!ratedIds.contains(doc.id)) ids.add(int.parse(doc.id));
      }

      if (page.docs.length < pageSize) break;
      cursor = page.docs.last;
    }

    ids.sort();
    return ids;
  }

  Future<List<int>> fetchMovieIdsOfCurrentUser(String userId) async {
    final snap = await _db
        .collection('users')
        .doc(userId)
        .collection('ratedMovies')
        .get();
    final ids = snap.docs.map((d) => int.parse(d.id)).toList()..sort();
    return ids;
  }

  Future<Map<int, double>> fetchFriendsRatings(List<String> friendIds) async {
    if (friendIds.isEmpty) return {};

    final List<List<String>> chunks = _chunk(friendIds, 10);

    final snaps = await Future.wait(chunks.map((chunk) => _db
        .collectionGroup('ratings')
        .where(FieldPath.documentId, whereIn: chunk)
        .get()));

    final map = <int, double>{};
    for (final snap in snaps) {
      for (final d in snap.docs) {
        final movieId = int.parse(d.reference.parent.parent!.id);
        map[movieId] = (d.data()['rating'] as num).toDouble();
      }
    }
    return map;
  }

  List<List<T>> _chunk<T>(List<T> list, int size) {
    final result = <List<T>>[];
    for (var i = 0; i < list.length; i += size) {
      result.add(list.sublist(i, math.min(i + size, list.length)));
    }
    return result;
  }
}
