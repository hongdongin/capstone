class UserProfileModel {
  final String uid;
  final String email;
  final String name;
  final String bio;
  final String link;
  final String birthday;
  final bool hasAvatar;

  UserProfileModel({
    required this.hasAvatar,
    required this.uid,
    required this.email,
    required this.name,
    required this.bio,
    required this.link,
    required this.birthday,
  });

  UserProfileModel.empty()
      : hasAvatar = false,
        uid = 'update uid',
        email = 'http:// update email',
        name = 'update name',
        bio = 'update bio',
        link = 'update link',
        birthday = 'update birthday';

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : hasAvatar = json['hasAvatar'],
        uid = json['uid'],
        email = json['email'],
        name = json['name'],
        bio = json['bio'],
        link = json['link'],
        birthday = json['birthday'];

  Map<String, String> toJson() {
    return {
      "uid ": uid,
      "email ": email,
      " name": name,
      "bio ": bio,
      "link": link,
      "birthday": birthday,
    };
  }

  UserProfileModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? bio,
    String? link,
    String? birthday,
    bool? hasAvatar,
  }) {
    return UserProfileModel(
        hasAvatar: hasAvatar ?? this.hasAvatar,
        uid: uid ?? this.uid,
        email: email ?? this.email,
        name: name ?? this.name,
        bio: bio ?? this.bio,
        link: link ?? this.link,
        birthday: birthday ?? this.birthday);
  }
}
