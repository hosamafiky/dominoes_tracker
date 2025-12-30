import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  final FirebaseFirestore firestore;

  FirestoreHelper({required this.firestore});

  CollectionReference<Map<String, dynamic>> collection(String path) {
    return firestore.collection(path);
  }

  DocumentReference<Map<String, dynamic>> document(String path) {
    return firestore.doc(path);
  }

  Future<T> getDocument<T>({required String path, required T Function(Map<String, dynamic> data, String id) fromFirestore}) async {
    final snapshot = await firestore.doc(path).get();
    if (!snapshot.exists) {
      throw Exception('Document path $path does not exist');
    }
    return fromFirestore(snapshot.data()!, snapshot.id);
  }

  Future<List<T>> getCollection<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String id) fromFirestore,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)? queryBuilder,
  }) async {
    Query<Map<String, dynamic>> query = firestore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => fromFirestore(doc.data(), doc.id)).toList();
  }

  Stream<T> watchDocument<T>({required String path, required T Function(Map<String, dynamic> data, String id) fromFirestore}) {
    return firestore.doc(path).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        throw Exception('Document path $path does not exist');
      }
      return fromFirestore(snapshot.data()!, snapshot.id);
    });
  }

  Stream<List<T>> watchCollection<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String id) fromFirestore,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)? queryBuilder,
  }) {
    Query<Map<String, dynamic>> query = firestore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => fromFirestore(doc.data(), doc.id)).toList();
    });
  }

  Future<T> addDocument<T>({
    required String path,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic> data, String id) fromFirestore,
  }) async {
    return await firestore.collection(path).add(data).then((docRef) async {
      return await getDocument(path: docRef.path, fromFirestore: fromFirestore);
    });
  }

  Future<T> updateDocument<T>({
    required String path,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic> data, String id) fromFirestore,
  }) async {
    return await firestore.doc(path).update(data).then((_) async {
      return await getDocument(path: path, fromFirestore: fromFirestore);
    });
  }

  Future<void> setDocument({required String path, required Map<String, dynamic> data, bool merge = true}) async {
    await firestore.doc(path).set(data, SetOptions(merge: merge));
  }

  Future<num> count({required String path, Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)? queryBuilder}) async {
    Query<Map<String, dynamic>> query = firestore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshot = await query.count().get();
    return snapshot.count ?? 0;
  }

  Future<void> incrementField({required String path, required String field, num value = 1}) async {
    await firestore.doc(path).update({field: FieldValue.increment(value)});
  }
}
