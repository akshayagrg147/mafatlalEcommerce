abstract class CheckoutState {}

class CheckoutInitialState extends CheckoutState {}

class UpdateStateAddressCheckBoxState extends CheckoutState {}

class SelectBillingDistrict extends CheckoutState {
  final String districtName;
  SelectBillingDistrict(this.districtName);
}

class SelectBillingState extends CheckoutState {
  final String stateName;
  SelectBillingState(this.stateName);
}

class SelectShippingState extends CheckoutState {
  final String stateName;
  SelectShippingState(this.stateName);
}

class SelectShippingDistrict extends CheckoutState {
  final String districtName;
  SelectShippingDistrict(this.districtName);
}

class SelecteAddressSaveState extends CheckoutState {
  final bool isSaveAddress;
  SelecteAddressSaveState(this.isSaveAddress);
}

class CheckoutOrderLoadingState extends CheckoutState {}

class CheckoutOrderSuccessState extends CheckoutState {}

class CheckoutOrderErrorState extends CheckoutState {
  final String message;
  CheckoutOrderErrorState(this.message);
}

class SaveAddressLoadingState extends CheckoutState {}

class SaveAddressErrorState extends CheckoutState {
  final String message;
  SaveAddressErrorState(this.message);
}

class SaveAddressSuccessState extends CheckoutState {}
