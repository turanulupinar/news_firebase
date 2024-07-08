
import 'package:equatable/equatable.dart';

class Tags with EquatableMixin {
  String? tagname;
  bool? active;
  String? id;

  Tags({
    this.tagname,
    this.active,
    this.id,
  });

  @override
  List<Object?> get props => [tagname, active, id];

  Tags copyWith({
    String? tagname,
    bool? active,
    String? id,
  }) {
    return Tags(
      tagname: tagname ?? this.tagname,
      active: active ?? this.active,
      id: id ?? this.id,
    );
  }

  factory Tags.fromFirestore(Map<String, dynamic> data) {
    return Tags(
      tagname: data['tagname'] ?? '',
      active: data['active'] ?? '',
      id: data['id'] ?? '',
    );
  }

  // bu kod dizisi: buradan aldığı cevabı key value şeklinde firebase'e
  //gönderir. buradaki değerleri convert eder ve aynı şekilde gönderir. aynı isim aynı değerle.
  Map<String, dynamic> toFirestore() {
    return {
      'tagname': tagname,
      'active': active,
      'id': id,
    };
  }
}
