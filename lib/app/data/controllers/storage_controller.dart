import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sreyastha_gps/app/core/constants/all_files.dart';
import 'package:sreyastha_gps/app/data/enums/feature.dart';
import 'package:sreyastha_gps/app/data/models/file_details.dart';
import 'package:sreyastha_gps/app/modules/add_marker/models/marker_list.dart';

class StorageController extends GetxController {
  static StorageController instance = Get.find();

  ///a marker list is instantiated to hold all the markers in a list
  ///instead of creating it in add marker controller, we are creating it in
  ///storage controller because it can be accessed by entire app
  MarkerList markerList = MarkerList();

  ///Directories to be accessed by the app
  Directory? mainDirectory;
  Directory? markerDirectory;
  Directory? trackDirectory;
  Directory? routeDirectory;

  ///All the folders and sub folders for the app are created before continuing
  ///further
  @override
  void onInit() {
    super.onInit();

    ///After 1 sec when the controller is ready, then it creates all the
    ///necessary folders required for all the files
    Future.delayed(Duration(seconds: 1)).then((value) async {
      if (await requestStoragePermissions(Permission.storage)) createFolders();
    });
  }

  ///this is used to take permission from the user so as to make all the required
  ///folders and subfolders
  Future<bool> requestStoragePermissions(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) return true;
    }
    return false;
  }

  ///Create folders
  void createFolders() async {
    ///create main folder in the same directory in which the android folder is
    ///present
    List<String> paths = (await getExternalStorageDirectory())!.path.split("/");
    String newPath = '';
    for (int i = 1; i < paths.length; i++) {
      String folder = paths[i];
      if (folder != "Android") {
        ///creates the new path unless android folder arrives, after which it
        ///it will creates its own folders
        newPath += "/" + folder;
      } else {
        break;
      }
    }

    ///Sreyastha GPS is in same directory in which there is Android folder
    mainDirectory = Directory(newPath + "/SreyathaGPS");
    _createDirectory(mainDirectory!);

    ///After the main folder is created, then all the sub folders are created
    markerDirectory = Directory(newPath + "/SreyathaGPS/Markers");
    _createDirectory(markerDirectory!);
    routeDirectory = Directory(newPath + "/SreyathaGPS/Routes");
    _createDirectory(routeDirectory!);
    trackDirectory = Directory(newPath + "/SreyathaGPS/Tracks");
    _createDirectory(trackDirectory!);
  }

  ///function to create one folder at a time
  void _createDirectory(Directory directory) async {
    if (await directory.exists()) {
      return;
    } else {
      await directory.create(recursive: true);
    }
  }

  ///A function to convert all data to csv format
  String convertAllMarkerAsCsv(
      List<String> columnNames, List<List<String>> values) {
    ///create List of List of strings which will eventually be converted to csv
    ///Data
    List<List<String>> rawData = [];

    rawData.add(columnNames);
    for (int row = 0; row < values.length; row++) rawData.add(values[row]);

    ///Convert the data to a csv data
    return ListToCsvConverter().convert(rawData);
  }

  ///A function to save all markers by taking a file name
  void saveAllMarkers(String filename) async {
    ///here the markerItem is a temporary markerItem variable
    /// which is stored in the markerlist
    ///with its help we are naming the columns in our csv
    //////here we are expanding all the remaining marker data
    String csvMarkerData = convertAllMarkerAsCsv(
        markerList.markerItem!.nameOfAttributes, markerList.markerListAsList);

    ///save the file to the marker folder
    final finalPath = markerDirectory!.path + "/$filename.csv";

    try {
      ///Create a file in the given path and write all data in the file
      final File? file = File(finalPath);
      file!.writeAsString(csvMarkerData);

      ///add the region in the file_lists
      ALL_FILES["Markers"]!.putIfAbsent(
        finalPath,
        () => FileDetails(
          filename: filename,
          created: DateTime.now(),
          feature: Feature.Marker,
          path: finalPath,
        ),
      );
    } catch (e) {}
  }

  ///A function to delete all markers. Rather than deleting all markers after
  ///saving a region, it is better to give user the chance to decide
  void clearAllMarkers() {
    markerList.deleteAllMarker();
    update();
  }

  ///A function to read all markers from a csv
  Future<bool> fetchMarkersFromCsv({required String filename}) {
    return loadingCsvData(markerDirectory!.path + "/$filename.csv");
  }

  ///To display the csv data we need to convert the csv into a list
  ///csv to list and then plot it
  Future<bool> loadingCsvData(String path) async {
    ///open read creates a new stream of data for the csv
    Stream<List<int>> csvFile;

    ///check whether the filename already exists. If it exists
    ///then load it else display a pop up that it is not present

    try {
      csvFile = new File(path).openRead();

      ///the data is first converted to a string and then it is converted to
      ///list
      List<List<dynamic>> allMarkerCsvList = await csvFile
          .transform(utf8.decoder)
          .transform(new CsvToListConverter())
          .toList();

      ///checking whether the heading column is of the same format as required
      for (String item in markerList.markerItem!.nameOfAttributes) {
        if (!allMarkerCsvList[0].contains(item)) {
          print("is not compatible");
        }
      }

      ///starting from the second row start creating a marker list from the
      ///given file

      for (int i = 1; i < allMarkerCsvList.length; i++) {
        List<String> tempList = [];
        for (int j = 0; j < allMarkerCsvList[i].length; j++) {
          tempList.add(allMarkerCsvList[i][j].toString());
        }
        markerList.createMarkerFromList(tempList);
        update();
      }
      return Future.value(true);
    } catch (e) {
      print("file cant be opened");

      ALL_FILES["Markers"]!.removeWhere((key, value) => key == path);
      return Future.value(false);
    }
  }
}
