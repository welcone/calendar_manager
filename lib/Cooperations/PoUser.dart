import 'package:cloud_firestore/cloud_firestore.dart';

class PoUser {
  /// 用于firestore user 集合的名字
  static String keyUsers = 'users'; 
  static String keyName = 'name';
  static String keyPhotoUrl = 'photourl';
  static String keyEmail = 'email';
  static String keydocumentID = 'documentID';

  final String documentID;
  final String name;
  final String photourl;
  final String email;
  final DocumentReference documentReference;
  /// 从外界map以及documentReference 构建对象
  PoUser.fromMap(Map<String, dynamic> map, {this.documentReference})
      : assert(map[PoUser.keydocumentID] != null),
        assert(map[PoUser.keyEmail] != null),
        assert(map[PoUser.keyName] != null),
        assert(map[PoUser.keyPhotoUrl] != null),
        documentID = map[PoUser.keydocumentID],
        name = map[PoUser.keyName],
        photourl = map[PoUser.keyPhotoUrl],
        email = map[PoUser.keyEmail];

  /// 从DocumentSnapshot 构建对象
    PoUser.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, documentReference: snapshot.reference);
}
