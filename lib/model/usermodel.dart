class UserModel {
  String? uid;
  String? email;
  String? userName;
  String? imageUrl;
  UserModel({this.uid, this.email, this.userName, this.imageUrl});

  factory UserModel.fromMap(map) => UserModel(
      uid: map['uid'],
      email: map['email'],
      userName: map['userName'],
      imageUrl: map['imageUrl']);

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'userName': userName,
        'imageUrl': imageUrl,
      };
}
