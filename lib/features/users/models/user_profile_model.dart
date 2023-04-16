class UserProfileModel {
  final String uid;
  final String email;
  final String name;
  final String bio;
  final String link;
  final String birthday;
  final String creator;
  final bool hasAvatar;

  UserProfileModel({
    required this.hasAvatar,
    required this.uid,
    required this.email,
    required this.name,
    required this.bio,
    required this.link,
    required this.birthday,
    required this.creator,
  });

  UserProfileModel.empty()
      : hasAvatar = false,
        uid = 'update uid',
        email = 'http:// update email',
        name = 'update name',
        bio = 'update bio',
        link = 'update link',
        birthday = 'update birthday',
        creator = 'update creator';

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : hasAvatar = json['hasAvatar'],
        uid = json['uid'],
        email = json['email'],
        name = json['name'],
        bio = json['bio'],
        link = json['link'],
        birthday = json['birthday'],
        creator = json['creator'];

  Map<String, String> toJson() {
    return {
      "uid ": uid,
      "email ": email,
      " name": name,
      "bio ": bio,
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
      bio: bio ?? this.bio,
      link: link ?? this.link,
      birthday: birthday ?? this.birthday,
      creator: creator ?? this.creator,
    );
  }
}
