class UserProfileModel {
  final String uid;
  final String email;
  final String name;
  final String bio;
  final String link;
  final String birthday;
  final String hasAvatar;

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
      : hasAvatar = 'empty',
        uid = 'empty uid',
        email = 'empty email',
        name = 'empty name',
        bio = 'empty bio',
        link = 'empty link',
        birthday = 'empty birthday';

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
}
