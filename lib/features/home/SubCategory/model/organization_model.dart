// Main model class to hold the response

class Organization {
  final int id;
  final String name;

  Organization({
    required this.id,
    required this.name,
  });

  // Factory method to create an instance from JSON
  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'],
      name: json['name'],
    );
  }

  // Method to convert the instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
