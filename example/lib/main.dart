// import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_playout/player_state.dart';
// import 'package:flutter_playout_example/audio.dart';
import 'package:flutter_playout_example/video.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "AV Playout",
      home: PlayoutExample(),
    );
  }
}

class PlayoutExample extends StatefulWidget {
  @override
  _PlayoutExampleState createState() => _PlayoutExampleState();
}

class _PlayoutExampleState extends State<PlayoutExample> {
  PlayerState _desiredState = PlayerState.PLAYING;
  bool _showPlayerControls = true;

  List<String> extdirs = [];

  var currFilePath = '/storage/emulated/0/Download/dada.mp4';

  UniqueKey currentPlayerKey =
      UniqueKey(); // = extDirectories[1].toString().split('/');

  getExternalSdCardPath() async {
    file = [];
    extdirs = [];
    List<Directory> extDirectories = await getExternalStorageDirectories();

    extDirectories.forEach((e) => extdirs.add(e.path + ' ## '));
    String rebuiltPath = '', encVideoDirName = 'dada';

    print("niruma rebuilt path: " + extdirs.toString());

    try {
      if (extDirectories.length > 1) {
        List<String> dirs = extDirectories[1].toString().split('/');
        rebuiltPath = '/' + dirs[1] + '/' + dirs[2] + '/' + encVideoDirName;
        Directory tempDir = Directory(rebuiltPath);
        if (!tempDir.existsSync()) {
          rebuiltPath = '';
        } else {
          file = Directory(rebuiltPath).listSync();
        }
      }
    } catch (e) {
      print("EX: " + e.toString());
    }

    setState(() {});
    // return rebuiltPath;
  }

  // String directory = '/storage/emulated/0/Download';
  List<FileSystemEntity> file = [];

  // Make New Function
  // void _listofFiles() async {
  //   setState(() {
  //     // file = Directory("$directory")
  //     //     .listSync(); //use your folder name insted of resume.
  //     int i = 0;
  //     i++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        // brightness: Brightness.dark,
        // backgroundColor: Colors.grey[900],
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: <Widget>[
          /* toggle show player controls */
          IconButton(
            icon: Icon(Icons.bug_report),
            onPressed: () async {
              Map<Permission, PermissionStatus> statuses = await [
                // Permission.location,
                Permission.storage,
              ].request();
            },
          ),
          IconButton(
            icon: Icon(Icons.adjust),
            onPressed: () async {
              // setState(() {
              //   _showPlayerControls = !_showPlayerControls;
              // });

              getExternalSdCardPath();
            },
          ),
        ],
      ),
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
                child: Column(
              children: [
                VideoPlayout(
                  key: currentPlayerKey,
                  desiredState: _desiredState,
                  showPlayerControls: _showPlayerControls,
                  filePath: currFilePath,
                ),
                FlutterLogo(),
                Text(currFilePath, style: TextStyle(color: Colors.red),),
                Text(extdirs.toString()),
                ListView.builder(
                    itemCount: file.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          title: Text(file[index].path),
                          onTap: () {
                            currFilePath = file[index].path;
                            currentPlayerKey = UniqueKey();
                            setState(() {});
                          },
                        ),
                      );
                    })
              ],
            )),
            // SliverToBoxAdapter(
            //   child: Container(
            //     padding: EdgeInsets.fromLTRB(17.0, 23.0, 17.0, 0.0),
            //     child: Text(
            //       "Audio Player",
            //       style: Theme.of(context).textTheme.headline4.copyWith(
            //           color: Colors.pink[500], fontWeight: FontWeight.w600),
            //     ),
            //   ),
            // ),
            // SliverToBoxAdapter(
            //   child: Container(
            //     padding: EdgeInsets.fromLTRB(17.0, 0.0, 17.0, 30.0),
            //     child: Text(
            //       "Plays audio from a URL with background audio support and lock screen controls.",
            //       style: Theme.of(context).textTheme.subtitle1.copyWith(
            //           color: Colors.white70, fontWeight: FontWeight.w400),
            //     ),
            //   ),
            // ),
            // SliverToBoxAdapter(
            //   child: AudioPlayout(
            //     desiredState: _desiredState,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
