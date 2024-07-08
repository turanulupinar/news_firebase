import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_firebase/model/tags_model.dart';

class TagsCollection {
  final tagsCollection = FirebaseFirestore.instance
      .collection("tags")
      .withConverter(
          fromFirestore: (snapshot, options) =>
              Tags.fromFirestore(snapshot.data() ?? {}),
          toFirestore: (value, options) => value.toFirestore());

  // Tags koleksiyonunu okuma

  Future<List<Tags>> fetchNews() async {
    QuerySnapshot<Tags> snapshot = await tagsCollection.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
