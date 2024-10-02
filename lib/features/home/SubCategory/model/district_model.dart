// CategoryModel.dart

import 'package:equatable/equatable.dart';

class DistrictModel extends Equatable {
  final int id;
  final String name;
  final int stateId;
  final String stateName;

  DistrictModel({
    required this.id,
    required this.name,
    required this.stateId,
    required this.stateName,
  });

  // Factory constructor to create a CategoryModel from JSON
  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json['id'],
      name: json['name'],
      stateId: json['state_id'],
      stateName: json['state_name'],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, stateId, stateName];
}
