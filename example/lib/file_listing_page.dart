// import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_playout/player_state.dart';
import 'package:flutter_playout_example/common/constants.dart';
// import 'package:flutter_playout_example/audio.dart';
import 'package:flutter_playout_example/video.dart';
import 'package:flutter_playout_example/video_player_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

import 'common/circular_material_button.dart';

class FileListingPage extends StatefulWidget {
  @override
  _FileListingPageState createState() => _FileListingPageState();
}

class _FileListingPageState extends State<FileListingPage> {
  PlayerState _desiredState = PlayerState.PLAYING;
  bool _showPlayerControls = true;

  List<String> extdirs = [];

  // String directory = '/storage/emulated/0/Download';
  List<FileSystemEntity> fileSystemEntityList = [];

  var currFilePath = '/storage/emulated/0/Download/dada.mp4';

  UniqueKey currentPlayerKey = UniqueKey();

  String _currentFolderPath = '';

  TextEditingController
      _folderPathTextController; // = extDirectories[1].toString().split('/');

  @override
  void initState() {
    super.initState();
    _folderPathTextController = TextEditingController();
    Future.delayed(Duration.zero, getExternalUsbDriveFileListing);
  }

  getExternalUsbDriveFileListing() async {
    extdirs = [];
    _currentFolderPath = '';
    List<Directory> extDirectories = await getExternalStorageDirectories();

    extDirectories.forEach((e) => extdirs.add(e.path + ' ## '));
    String encVideoDirName = 'dada';

    print("niruma rebuilt path: " + extdirs.toString());

    try {
      if (extDirectories.length > 1) {
        List<String> dirs = extDirectories[1].toString().split('/');
        _currentFolderPath =
            '/' + dirs[1] + '/' + dirs[2] + '/' + encVideoDirName;

          _getVideoFilesListFromFolder();
      }
    } catch (e) {
      print("EX: " + e.toString());
    }

    // return rebuiltPath;
  }

  _getVideoFilesListFromFolder([bool isCheckForUsb = false]) {
    fileSystemEntityList = [];

    Directory tempDir = Directory(_currentFolderPath);

    if (tempDir.existsSync()) {
      fileSystemEntityList = tempDir
          .listSync()
          .where((element) => element.path.split('/').last.endsWith('.mp4'))
          .toList();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
                child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          // width: 430,
                          child: TextFormField(
                            // initialValue: _currentFolderPath,
                            readOnly: true,
                            controller: _folderPathTextController,

                            ///AppData.currIcardId,
                            // decoration: InputDecoration(

                            //   // labelText: contact_email_id,
                            //   prefixIcon: Icon(Icons.folder),
                            //   // contentPadding: gTextEdgeInsets,
                            //   // border: gOutlineInputBorder,
                            //   // hintText: contact_email_id,
                            //   border: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(24)),
                            // ),
                          ),
                        ),
                      ),
                    ),
                    CircularMaterialButton(
                      iconWidget: Icon(
                        Icons.file_copy,
                        size: 28,
                        color: Color(0xFF666763),
                      ),
                      onPressed: () async {
                        _currentFolderPath =
                            await FilePicker.platform.getDirectoryPath();

                        if (_currentFolderPath != null) {
                          print('DADA $_currentFolderPath');
                          _folderPathTextController.text = _currentFolderPath;
                          _getVideoFilesListFromFolder();
                          // _currentFolderPath = ;
                          setState(() {});
                        }
                      },
                    ),
                    CircularMaterialButton(
                      iconWidget: Icon(
                        Icons.refresh,
                        size: 28,
                        color: Color(0xFF666763),
                      ),
                      onPressed: () {
                        getExternalUsbDriveFileListing();
                      },
                    )
                  ],
                ),
                Row(
                  children: _testBtnsRow(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(fileSystemEntityList.isEmpty
                      ? 'No files found'
                      : '${fileSystemEntityList.length} files found'),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.extent(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    maxCrossAxisExtent: 220.0,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    children: fileSystemEntityList
                        .map(
                          (currFile) => InkWell(
                            onTap: () {
                              currFilePath = currFile.path;
                              currentPlayerKey = UniqueKey();
                              setState(() {});

                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return VideoPlayerPage(
                                  key: currentPlayerKey,
                                  desiredState: _desiredState,
                                  showPlayerControls: _showPlayerControls,
                                  filePath: currFilePath,
                                  aesKey: Constants.WMHT_AES_KEY,
                                );
                              }));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Stack(
                                children: [
                                  Container(
                                      height: double.maxFinite,
                                      child: Image.asset(
                                        'assets/images/film_frame.png',
                                        fit: BoxFit.fill,
                                      )),
                                  Container(
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          currFile.path.split('/').last,
                                          style: TextStyle(fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
//                       children: elements
//                           .map((el) => Card(
//                               child: Center(
//                                   child: Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(el + '''app is using a deprecated version of the Android embedding.
// To avoid unexpected runtime failures, or future build failures, try to migrate this app to the V2 embedding.
// Take a look at the docs for migrating an app: https://github.com/flutte''')))))
//                           .toList(),
                  ),
                ),
                // ListView.builder(
                //     itemCount: fileSystemEntityList.length,
                //     shrinkWrap: true,
                //     physics: NeverScrollableScrollPhysics(),
                //     itemBuilder: (BuildContext context, int index) {
                //       return Card(
                //         child: ListTile(
                //           title: Text(
                //               fileSystemEntityList[index].path.split('/').last),
                //           onTap: () {
                //             currFilePath = fileSystemEntityList[index].path;
                //             currentPlayerKey = UniqueKey();
                //             setState(() {});

                //             Navigator.push(context,
                //                 MaterialPageRoute(builder: (_) {
                //               return VideoPlayerPage(
                //                 key: currentPlayerKey,
                //                 desiredState: _desiredState,
                //                 showPlayerControls: _showPlayerControls,
                //                 filePath: currFilePath,
                //               );
                //             }));
                //           },
                //         ),
                //       );
                //     })
              ],
            )),
          ],
        ),
      ),
    );
  }

  _testBtnsRow() => <Widget>[
        /* toggle show player controls */
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            var affine = Caesar(20);
            String encrypt = affine.encrypt("KP@GF5L6DBTJHA1#*3K");
            String decrypt = affine.decrypt(encrypt);

            print(encrypt); // Armmv Tvemo!
            print(decrypt); // Hello World!
          },
        ),
        // IconButton(
        //   icon: Icon(Icons.bug_report),
        //   onPressed: () async {},
        // ),
        // IconButton(
        //   icon: Icon(Icons.adjust),
        //   onPressed: () async {
        //     // setState(() {
        //     //   _showPlayerControls = !_showPlayerControls;
        //     // });

        //     getExternalSdCardPath();
        //   },
        // ),
      ];
}

class Caesar {
  int shift;

  /// [shift] is greater than 0 and less than or eqaul to 26.
  Caesar(int shift) {
    this.shift = (shift <= 0 || shift > 26) ? 1 : shift;
  }

  String _convert(String text, int key) {
    StringBuffer cipher = new StringBuffer();

    for (int i = 0; i < text.length; i++) {
      int code = text.codeUnitAt(i);

      if (code >= "A".codeUnitAt(0) && code <= "Z".codeUnitAt(0)) {
        int aCode = "A".codeUnitAt(0);
        String t = String.fromCharCode(aCode + (code - aCode + key) % 26);
        cipher.write(t);
      } else if (code >= "a".codeUnitAt(0) && code <= "z".codeUnitAt(0)) {
        int aCode = "a".codeUnitAt(0);
        String t = String.fromCharCode(aCode + (code - aCode + key) % 26);
        cipher.write(t);
      } else {
        cipher.write(text[i]);
      }
    }

    return cipher.toString();
  }

  /// Encrypt [text].
  String encrypt(String text) {
    return _convert(text, this.shift);
  }

  /// Decrypt [text].
  String decrypt(String text) {
    return _convert(text, 26 - shift);
  }
}
