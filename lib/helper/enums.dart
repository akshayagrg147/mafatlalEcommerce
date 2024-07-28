enum UserType {
  consumer(0),
  distributor(1);

  final int code;

  const UserType(this.code);

  static UserType fromCode(int? code) {
    switch (code) {
      case 0:
        return UserType.consumer;
      case 1:
        return UserType.distributor;
      default:
        return UserType.consumer;
    }
  }
}
