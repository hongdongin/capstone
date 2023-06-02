class UserProfileModel {
  final String uid;
  final String name;
  final String link;
  final String birthday;
  final bool hasAvatar;
  final String creator;
  final String email;

  UserProfileModel({
    required this.creator,
    this.hasAvatar = false,
    required this.email,
    required this.uid,
    required this.name,
    required this.link,
    required this.birthday,
  });

  UserProfileModel.empty()
      : hasAvatar = false,
        uid = 'update uid',
        email = 'http:// update email',
        name = 'update name',
        link = 'update link',
        birthday = 'update birthday',
        creator = 'update creator';

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"] ?? '',
        email = json["email"] ?? '',
        name = json["name"] ?? '',
        creator = json["creator"],
        birthday = json["birthday"],
        hasAvatar = json["hasAvatar"] ?? false,
        link = json["link"];

  Map<String, String> toJson() {
    return <String, String>{
      "uid": uid,
      "email": email,
      "name": name,
      "link": link,
      "birthday": birthday,
      "creator": creator,
    };
  }

  UserProfileModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? bio,
    String? link,
    String? birthday,
    String? creator,
    bool? hasAvatar,
  }) {
    return UserProfileModel(
      hasAvatar: hasAvatar ?? this.hasAvatar,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      link: link ?? this.link,
      birthday: birthday ?? this.birthday,
      creator: creator ?? this.creator,
    );
  }
}
