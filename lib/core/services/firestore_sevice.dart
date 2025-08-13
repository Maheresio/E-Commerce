import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/firestore_constants.dart';
import 'package:flutter/foundation.dart';

class FirestoreServices {
  FirestoreServices._();

  static final FirestoreServices instance = FirestoreServices._();

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<String> getPath() async => (_fireStore.collection(FirestoreConstants.products).doc()).id;

  Future<void> deleteCollection({required String path}) async {
    final CollectionReference<Map<String, dynamic>> collection = _fireStore.collection(path);
    final QuerySnapshot<Map<String, dynamic>> snapshots = await collection.get();

    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final DocumentReference<Map<String, dynamic>> reference = _fireStore.doc(path);
    debugPrint('Request Data: $data');
    await reference.set(data);
  }

  Future<void> updateData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final DocumentReference<Map<String, dynamic>> reference = _fireStore.doc(path);
    debugPrint('Request Data: $data');
    await reference.update(data);
  }

  Future<void> deleteData({required String path}) async {
    final DocumentReference<Map<String, dynamic>> reference = _fireStore.doc(path);
    await reference.delete();
  }

  Stream<T> documentsStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentId) builder,
  }) {
    final DocumentReference<Map<String, dynamic>> reference = _fireStore.doc(path);
    final Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots = reference.snapshots();
    return snapshots.map((DocumentSnapshot<Map<String, dynamic>> snapshot) => builder(snapshot.data(), snapshot.id));
  }

  Stream<List<T>> collectionsStream<T>({
    required String path,
    required T Function(
      Map<String, dynamic>? data,
      String documentId,
      DocumentSnapshot doc,
    )
    builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) {
    Query query = _fireStore.collection(path);

    // 🔁 Apply custom query filters (e.g. where, orderBy)
    if (queryBuilder != null) {
      query = queryBuilder(query);
    } else {
      // 🧱 Apply a fallback orderBy if none provided
      query = query.orderBy(FieldPath.documentId);
    }

    // 🔄 Only apply startAfter after orderBy has been applied
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    // 📦 Always limit last
    query = query.limit(pageSize);

    final Stream<QuerySnapshot<Object?>> snapshots = query.snapshots();

    return snapshots.map((QuerySnapshot<Object?> snapshot) {
      final List<T> result =
          snapshot.docs
              .map(
                (QueryDocumentSnapshot<Object?> doc) =>
                    builder(doc.data()! as Map<String, dynamic>, doc.id, doc),
              )
              .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  /// Fetches a collection once as a Future for pagination purposes
  Future<List<T>> getCollection<T>({
    required String path,
    required T Function(
      Map<String, dynamic>? data,
      String documentId,
      DocumentSnapshot doc,
    )
    builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
    DocumentSnapshot? lastDocument,
    int? pageSize,
  }) async {
    Query query = _fireStore.collection(path);

    if (queryBuilder != null) {
      query = queryBuilder(query);
    } else {
      query = query.orderBy(FieldPath.documentId);
    }

    debugPrint('📄 LastDocument: ${lastDocument?.id}');
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    if (pageSize != null) query = query.limit(pageSize);

    final QuerySnapshot<Object?> snapshot = await query.get();

    final List<T> result =
        snapshot.docs
            .map(
              (QueryDocumentSnapshot<Object?> doc) => builder(doc.data()! as Map<String, dynamic>, doc.id, doc),
            )
            .toList();

    if (sort != null) {
      result.sort(sort);
    }

    return result;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument({
    required String path,
  }) async => await FirebaseFirestore.instance.doc(path).get();
}
