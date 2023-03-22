import 'package:flutter/material.dart';

class ItemView extends StatelessWidget {
  const ItemView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Text(
                      "Test Event ",
                      maxLines: 5,
                      style: TextStyle(color: Colors.black, fontSize: 14.0),
                    ),
                  ),
                  const SizedBox(
                    width: 24.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                      color: Colors.red,
                    ),
                    child: const Text(
                      "10:00 - 15:24",
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: double.maxFinite,
          height: 0.5,
          color: Colors.red,
        ),
      ],
    );
  }
}
