import 'package:flutter/material.dart';

import '/app/core/constants/controllers.dart';
import '/app/core/themes/colors.dart';

///this is the button shown in the map in each of the map screen

class MapZoomButton extends StatelessWidget {
  const MapZoomButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 10,
      top: MediaQuery.of(context).size.height / 2,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.1,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: light,
            boxShadow: [
              BoxShadow(
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset: Offset(1, 1),
                  color: Colors.grey)
            ]),
        child: _mapZoomButton(),
      ),
    );
  }

  Widget _mapZoomButton() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <IconData>[Icons.add, Icons.minimize]
            .map(
              (iconData) => IconButton(
                icon: Icon(
                  iconData,
                  color: active,
                ),
                onPressed: () {
                  iconData == Icons.add
                      ? mapController.zoom + 1 <= 18.499
                          ? mapController.move(
                              mapController.center, mapController.zoom + 1)
                          : mapController.move(
                              mapController.center, mapController.zoom)
                      : mapController.zoom - 1 >= 3
                          ? mapController.move(
                              mapController.center, mapController.zoom - 1)
                          : mapController.move(
                              mapController.center, mapController.zoom);
                },
              ),
            )
            .toList());
  }
}
