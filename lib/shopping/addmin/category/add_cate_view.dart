import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/common.dart';
import '../../../util/util.dart';
import 'add_cate_bloc.dart';

class AddCateView extends StatefulWidget {
  final CommonModel? item;

  const AddCateView({Key? key, this.item}) : super(key: key);

  @override
  State<AddCateView> createState() => _AddCateViewState();
}

class _AddCateViewState extends State<AddCateView> {
  final titleController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    if (widget.item != null) {
      titleController.text = widget.item?.title ?? "";
     }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddCateBloc(),
      child: BlocConsumer<AddCateBloc, AddCateState>(
        listener: (context, state) {
          if (state is ErrorState) {
            Util.showToast(state.errorMsg);
          } else if (state is AddCateSuccess) {
            Util.showToast("Category ${widget.item == null ? "added" : "update"} successful");
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text("${widget.item == null ? "Add" : "Update"}Category")),
            body: Container(
              color: Colors.lightGreen[900],
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Enter title",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                  ),
                  const SizedBox(height: 30),
                   const SizedBox(height: 30),
                  state is LoadingState
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : MaterialButton(
                          height: 45,
                          minWidth: double.maxFinite,
                          onPressed: () {
                            if (widget.item == null) {
                              BlocProvider.of<AddCateBloc>(context)
                                  .add(AddCate(title: titleController.text.trim() ));
                            } else {
                              BlocProvider.of<AddCateBloc>(context).add(UpdateNotesTap(
                                  title: titleController.text.trim(),
                                   id: widget.item?.id ?? ""));
                            }
                          },
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: const Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
