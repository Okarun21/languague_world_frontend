class ProfileIcon {
  final String id;
  final String name;
  final String imageUrl;

  ProfileIcon({required this.id, required this.name, required this.imageUrl});

  factory ProfileIcon.fromJson(Map<String, dynamic> json) {
    return ProfileIcon(
      id: json['_id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }
}
