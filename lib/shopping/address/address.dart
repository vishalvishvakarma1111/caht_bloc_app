import 'package:chat_bloc_app/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../add_address/add_address.dart';
import 'bloc/address_bloc.dart';

class AddressView extends StatelessWidget {
  const AddressView({Key? key}) : super(key: key);

  _btn(context) => FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const AddAddressScreen();
          }));
        },
        child: const Icon(Icons.add),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddressBloc()..add(LoadAddressEvent()),
      child: BlocConsumer<AddressBloc, AddressState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            body: state is AddressLoadedState
                ? state.loader ?? false
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : state.addressList?.isEmpty ?? false
                        ? const Center(
                            child: Text(
                              "No Address added",
                              style: TextStyle(),
                            ),
                          )
                        : ListView.separated(
                            itemCount: state.addressList?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              var item = state.addressList![index];
                              return Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(20)),
                                child: ListTile(
                                  title: Text(
                                    item.address ?? '',
                                    style: TextStyle().bold,
                                  ),
                                  subtitle: Text(
                                    item.city ?? '',
                                    style: TextStyle().semiBold,
                                  ),
                                  trailing: Text(
                                    item.zipCode ?? '',
                                    style: TextStyle().bold,
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return const Divider();
                            },
                          )
                : const SizedBox.shrink(),
            floatingActionButton: _btn(context),
          );
        },
      ),
    );
  }
}
