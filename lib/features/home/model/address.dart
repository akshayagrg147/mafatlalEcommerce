class Address {
  final String address;
  final String address2;
  final String state;
  final String pincode;
  final String district;
  final String landmark;
  final String city;
  final String mobile;

  Address(
      {required this.address,
      required this.state,
      required this.pincode,
      required this.district,
      required this.city,
      required this.mobile,
      required this.address2,
      required this.landmark});

  // Factory constructor to create an Address from JSON
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
        address: json['street_address_1'],
        address2: json['street_address_2'] ?? "",
        state: json['state'],
        pincode: json['pincode'],
        district: json['district'],
        city: json['city'],
        mobile: json['phone_number'] ?? '',
        landmark: json['landmark'] ?? "");
  }

  String get addressString =>
      "$address,${address2.isNotEmpty ? ' $address2,' : ''} $landmark, $city, $district, $state, pin : $pincode";

  // Method to convert an Address to JSON
  Map<String, dynamic> toJson() {
    return {
      'street_address_1': address,
      'street_address_2': address2,
      'state': state,
      'pincode': pincode,
      'district': district,
      'landmark': landmark,
      'phone_number': mobile,
      'city': city,
    };
  }
}
