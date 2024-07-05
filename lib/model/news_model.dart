class News {
  final String category;
  final String id;
  final String image;
  final String title;

  News({
    required this.category,
    required this.id,
    required this.image,
    required this.title,
  });

  factory News.fromFirestore(Map<String, dynamic> data, String documentId) {
    return News(
      category: data['category'] ?? '',
      id: documentId,
      image: data['image'] ?? '',
      title: data['title'] ?? '',
    );
  }



  // bu kod dizisi: buradan aldığı cevabı key value şeklinde firebase'e 
  //gönderir. buradaki değerleri convert eder ve aynı şekilde gönderir. aynı isim aynı değerle.
   Map<String, dynamic> toFirestore() {
    return {
      'category': category,
      'id': id,
      'image': image,
      'title': title,
    };

    
  }
   News copyWith({
    String? category,
    String? id,
    String? image,
    String? title,
  }) {
    return News(
      category: category ?? this.category,
      id: id ?? this.id,
      image: image ?? this.image,
      title: title ?? this.title,
    );
  }



 

}