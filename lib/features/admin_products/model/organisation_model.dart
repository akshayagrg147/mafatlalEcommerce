import 'package:equatable/equatable.dart';

class DataObject extends Equatable {
  final int id;
  final String name;
  final String image;

  const DataObject({
    required this.id,
    required this.name,
    required this.image,
  });

  factory DataObject.fromJson(Map<String, dynamic> json) => DataObject(
        id: json["id"],
        name: json["name"],
        image: json["image"] ?? "",
      );

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
      ];
}
