import 'package:equatable/equatable.dart';

class Organisation extends Equatable {
  final int id;
  final String name;
  final String image;

  const Organisation({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Organisation.fromJson(Map<String, dynamic> json) => Organisation(
        id: json["id"],
        name: json["name"],
        image: json["image"] ?? "",
      );

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
