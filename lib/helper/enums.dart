enum UserType {
  consumer(0),
  distributor(1),
  admin(2),
  ;

  final int code;

  const UserType(this.code);

  static UserType fromCode(int? code) {
    switch (code) {
      case 0:
        return UserType.consumer;
      case 1:
        return UserType.distributor;
      case 2:
        return UserType.admin;
      default:
        return UserType.consumer;
    }
  }
}

extension FirstWhereOrNullExtension<E> on List<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
