import 'package:flutter/material.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';

class MovetoCurrentLocationButton extends StatelessWidget {
  const MovetoCurrentLocationButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final dynamic controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 15,
      bottom: 25,
      child: InkWell(
        onTap: () {
          controller.moveToCurrentLocation();
        },
        child: Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
              color: active,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                    blurRadius: 1,
                    spreadRadius: 1,
                    offset: Offset(1, 1),
                    color: Colors.grey)
              ]),
          child: Icon(
            Icons.gps_fixed,
            color: light,
          ),
        ),
      ),
    );
  }
}
