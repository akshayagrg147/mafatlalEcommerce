class Address {
  final String address;
  final String state;
  final String pincode;
  final String district;
  final String city;

  Address({
    required this.address,
    required this.state,
    required this.pincode,
    required this.district,
    required this.city,
  });

  // Factory constructor to create an Address from JSON
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'],
      state: json['state'],
      pincode: json['pincode'],
      district: json['district'],
      city: json['city'],
    );
  }

  String get addressString =>
      "$address, $city, $district, $state, pin : $pincode";

  // Method to convert an Address to JSON
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'state': state,
      'pincode': pincode,
      'district': district,
      'city': city,
    };
  }
}
