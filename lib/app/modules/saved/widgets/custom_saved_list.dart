import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sreyastha_gps/app/core/constants/all_files.dart';
import 'package:sreyastha_gps/app/core/themes/colors.dart';

import 'package:sreyastha_gps/app/modules/saved/controllers/saved_controller.dart';
import 'package:sreyastha_gps/app/modules/saved/widgets/file_card.dart';

class CustomSavedList extends GetView<SavedController> {
  const CustomSavedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: ALL_FILES["Markers"]!
          .values
          .map(
            (specificFile) => Container(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              child: Card(
                elevation: 2,
                child: Container(
                  color: light,
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: FileCard(
                    fileDetails: specificFile,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}