import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_firebase/model/news_model.dart';

class ManagerData {
  final newsCollection =
      FirebaseFirestore.instance.collection('news').withConverter<News>(
            fromFirestore: (snapshot, _) =>
                News.fromFirestore(snapshot.data() ?? {}, snapshot.id),
            toFirestore: (news, _) => news.toFirestore(),
          );

//DATA oku
  Future<List<News>> fetchNews() async {
    QuerySnapshot<News> snapshot = await newsCollection.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
    // doc.data => dökümanın karşısında yer alan bütün dataalrı key value şeklinde yazar
  }

  // data yaz
  Future<void> addNews(News newses) async {
    final docref = await newsCollection.add(newses);
    final updateNews = newses.copyWith(id: docref.id);
    await docref.set(updateNews);
  }

// data sil
  Future<void> deleteNews(String docId) async {
    await newsCollection.doc(docId).delete();
  }

  // update data
  Future<void> updateNews(String docId, News news) async {
    // Belirli bir belgeyi güncellemek için docId kullanarak referans alıyoruz
    final docRef = newsCollection.doc(docId);

    // Belgeyi güncelliyoruz
    await docRef.update(news.toFirestore());
  }

  // bütün gönderilerin döküman Idsini bulma
  fetchDokId() async {
    var tek = await newsCollection.get();
    for (var eleman in tek.docs) {
      debugPrint(eleman.id);
      debugPrint(eleman.data().title.toString());
    }
  }
}


