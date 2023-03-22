part of 'buy_now_bloc.dart';

@immutable
abstract class BuyNowState {}

class BuyNowInitial extends BuyNowState {}

class BuyNowLoaded extends BuyNowState {
  final bool? loader;
  final bool? buyLoader;
  List<Address>? addressList;
  int? selectedAddressIndex;

  BuyNowLoaded({
    this.loader,
    this.addressList,
    this.selectedAddressIndex,
    this.buyLoader,
  });

  BuyNowLoaded copyWith({
    bool? loader,
    List<Address>? addressList,
    int? selectedAddressIndex,
    bool? buyLoader,
  }) {
    return BuyNowLoaded(
      loader: loader ?? this.loader,
      buyLoader: buyLoader ?? this.buyLoader,
      addressList: addressList ?? this.addressList,
      selectedAddressIndex: selectedAddressIndex ?? this.selectedAddressIndex,
    );
  }
}

class BuyNowErrorState extends BuyNowState {
  final String msg;

  BuyNowErrorState(this.msg);
}

class BuySuccessState extends BuyNowState{}