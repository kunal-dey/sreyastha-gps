import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/app/core/themes/colors.dart';

class HomePageAppBar extends StatelessWidget {
  final Function _openDrawer;
  HomePageAppBar(this._openDrawer, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
          ),
          _homePageHeading(context, _openDrawer),
          SizedBox(height: 10),
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ["Marker", "Track", "Route"]
                  .map((act) => _selectAction(act))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _homePageHeading(BuildContext context, Function _openDrawer) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => _openDrawer(),
            icon: Icon(
              Icons.menu,
              color: active,
            ),
          ),
          Text(
            "Sreyastha GPS",
            style: GoogleFonts.poppins(color: active),
            textScaleFactor: 1.1,
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: active,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _selectAction(String _action) {
    return Container(
      child: Chip(
        label: InkWell(
          onTap: () {
            switch (_action) {
              case "Marker":
                break;
              case "Route":
                break;
              case "Track":
                break;
            }
          },
          child: Text("Add " + _action),
        ),
        backgroundColor: light,
        elevation: 2,
      ),
    );
  }
}
