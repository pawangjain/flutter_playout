// import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_playout/player_state.dart';
import 'package:flutter_playout_example/file_listing_page.dart';
import 'package:flutter_playout_example/services/init_app_service.dart';
// import 'package:flutter_playout_example/audio.dart';
import 'package:flutter_playout_example/video.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'common/constants.dart';
const IS_ANDROID_TV_BUILD =
    bool.fromEnvironment('IS_ANDROID_TV_BUILD', defaultValue: true);//IS_FIRE_TV_BUILD

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  InitAppService.initApp().then((_) {
    runApp(MainApp());
  });
}
class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        // LogicalKeySet(LogicalKeyboardKey.arrowLeft):
        //       const DirectionalFocusIntent(TraversalDirection.left),
        //   LogicalKeySet(LogicalKeyboardKey.arrowRight):
        //       const DirectionalFocusIntent(TraversalDirection.right),
        //   LogicalKeySet(LogicalKeyboardKey.arrowDown):
        //       const DirectionalFocusIntent(TraversalDirection.down),
        //   LogicalKeySet(LogicalKeyboardKey.arrowUp):
        //       const DirectionalFocusIntent(TraversalDirection.up),
      },
      child: StyledToast(
        locale: const Locale('en', 'US'),
        textStyle: TextStyle(fontSize: 16.0, color: Colors.white),
        backgroundColor: Color(0x99000000),
        borderRadius: BorderRadius.circular(5.0),
        textPadding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
        toastPositions: StyledToastPosition.top,
        toastAnimation: StyledToastAnimation.fade,
        reverseAnimation: StyledToastAnimation.fade,
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.fastLinearToSlowEaseIn,
        duration: Duration(seconds: 4),
        animDuration: Duration(seconds: 1),
        dismissOtherOnShow: true,
        // movingOnWindowChange: true,
        child:  MaterialApp(
            title: 'DadaBhagwan TV App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.dark,
              fontFamily: 'Cambria',
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  // onPrimary: Colors.yellow,
                  primary: Constants.highlightColor,
                  shape: StadiumBorder(),
                ),
              ),
              // outlinedButtonTheme: OutlinedButtonThemeData(
              //   style: OutlinedButton.styleFrom(
              //     primary: Colors.purple,
              //     backgroundColor: Colors.green,
              //   ),
              // ),
            ),
            home:
                FileListingPage(), // RecentSatsangPage(), /// App// TestYtPlayer(), // App(),
          ),
        ),
        // child: MultiProvider(
        //   providers: [
        //     // ChangeNotifierProvider(
        //     //     create: (context) => AppChangeNotifierProvider()),
        //     // Provider(create: (context) => SomeOtherClass()),
        //   ],
        //   child: MaterialApp(
        //     title: 'DadaBhagwan TV App',
        //     theme: ThemeData(
        //       primarySwatch: Colors.blue,
        //       brightness: Brightness.dark,
        //       fontFamily: 'Cambria',
        //       elevatedButtonTheme: ElevatedButtonThemeData(
        //         style: ElevatedButton.styleFrom(
        //           // onPrimary: Colors.yellow,
        //           primary: Constants.highlightColor,
        //           shape: StadiumBorder(),
        //         ),
        //       ),
        //       // outlinedButtonTheme: OutlinedButtonThemeData(
        //       //   style: OutlinedButton.styleFrom(
        //       //     primary: Colors.purple,
        //       //     backgroundColor: Colors.green,
        //       //   ),
        //       // ),
        //     ),
        //     home:
        //         FileListingPage(), // RecentSatsangPage(), /// App// TestYtPlayer(), // App(),
        //   ),
        // ),
      
    );
  }
  }

// class PlayoutExample extends StatefulWidget {
//   @override
//   _PlayoutExampleState createState() => _PlayoutExampleState();
// }

// class _PlayoutExampleState extends State<PlayoutExample> {
//   PlayerState _desiredState = PlayerState.PLAYING;
//   bool _showPlayerControls = true;

//   List<String> extdirs = [];

//   var currFilePath = '/storage/emulated/0/Download/dada.mp4';

//   UniqueKey currentPlayerKey =
//       UniqueKey(); // = extDirectories[1].toString().split('/');

//   getExternalSdCardPath() async {
//     file = [];
//     extdirs = [];
//     List<Directory> extDirectories = await getExternalStorageDirectories();

//     extDirectories.forEach((e) => extdirs.add(e.path + ' ## '));
//     String rebuiltPath = '', encVideoDirName = 'dada';

//     print("niruma rebuilt path: " + extdirs.toString());

//     try {
//       if (extDirectories.length > 1) {
//         List<String> dirs = extDirectories[1].toString().split('/');
//         rebuiltPath = '/' + dirs[1] + '/' + dirs[2] + '/' + encVideoDirName;
//         Directory tempDir = Directory(rebuiltPath);
//         if (!tempDir.existsSync()) {
//           rebuiltPath = '';
//         } else {
//           file = Directory(rebuiltPath).listSync();
//         }
//       }
//     } catch (e) {
//       print("EX: " + e.toString());
//     }

//     setState(() {});
//     // return rebuiltPath;
//   }

//   // String directory = '/storage/emulated/0/Download';
//   List<FileSystemEntity> file = [];

//   // Make New Function
//   // void _listofFiles() async {
//   //   setState(() {
//   //     // file = Directory("$directory")
//   //     //     .listSync(); //use your folder name insted of resume.
//   //     int i = 0;
//   //     i++;
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey,
//       appBar: AppBar(
//         // brightness: Brightness.dark,
//         // backgroundColor: Colors.grey[900],
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.menu),
//           onPressed: () {},
//         ),
//         actions: <Widget>[
//           /* toggle show player controls */
//           IconButton(
//             icon: Icon(Icons.edit),
//             onPressed: () {
//               var affine = Caesar(5);
//               String encrypt = affine.encrypt("KP@GF5L6DBTJHA1#*3K");
//               String decrypt = affine.decrypt(encrypt);

//               print(encrypt); // Armmv Tvemo!
//               print(decrypt); // Hello World!
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.bug_report),
//             onPressed: () async {
//               Map<Permission, PermissionStatus> statuses = await [
//                 // Permission.location,
//                 Permission.storage,
//               ].request();
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.adjust),
//             onPressed: () async {
//               // setState(() {
//               //   _showPlayerControls = !_showPlayerControls;
//               // });

//               getExternalSdCardPath();
//             },
//           ),
//         ],
//       ),
//       body: Container(
//         child: CustomScrollView(
//           slivers: <Widget>[
//             SliverToBoxAdapter(
//                 child: Column(
//               children: [
//                 VideoPlayout(
//                   key: currentPlayerKey,
//                   desiredState: _desiredState,
//                   showPlayerControls: _showPlayerControls,
//                   filePath: currFilePath,
//                 ),
//                 FlutterLogo(),
//                 Text(
//                   currFilePath,
//                   style: TextStyle(color: Colors.red),
//                 ),
//                 Text(extdirs.toString()),
//                 ListView.builder(
//                     itemCount: file.length,
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemBuilder: (BuildContext context, int index) {
//                       return Card(
//                         child: ListTile(
//                           title: Text(file[index].path),
//                           onTap: () {
//                             currFilePath = file[index].path;
//                             currentPlayerKey = UniqueKey();
//                             setState(() {});
//                           },
//                         ),
//                       );
//                     })
//               ],
//             )),
//             // SliverToBoxAdapter(
//             //   child: Container(
//             //     padding: EdgeInsets.fromLTRB(17.0, 23.0, 17.0, 0.0),
//             //     child: Text(
//             //       "Audio Player",
//             //       style: Theme.of(context).textTheme.headline4.copyWith(
//             //           color: Colors.pink[500], fontWeight: FontWeight.w600),
//             //     ),
//             //   ),
//             // ),
//             // SliverToBoxAdapter(
//             //   child: Container(
//             //     padding: EdgeInsets.fromLTRB(17.0, 0.0, 17.0, 30.0),
//             //     child: Text(
//             //       "Plays audio from a URL with background audio support and lock screen controls.",
//             //       style: Theme.of(context).textTheme.subtitle1.copyWith(
//             //           color: Colors.white70, fontWeight: FontWeight.w400),
//             //     ),
//             //   ),
//             // ),
//             // SliverToBoxAdapter(
//             //   child: AudioPlayout(
//             //     desiredState: _desiredState,
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Caesar {
//   int shift;

//   /// [shift] is greater than 0 and greater than or eqaul to 26.
//   Caesar(int shift) {
//     this.shift = (shift <= 0 || shift > 26) ? 1 : shift;
//   }

//   String _convert(String text, int key) {
//     StringBuffer cipher = new StringBuffer();

//     for (int i = 0; i < text.length; i++) {
//       int code = text.codeUnitAt(i);

//       if (code >= "A".codeUnitAt(0) && code <= "Z".codeUnitAt(0)) {
//         int aCode = "A".codeUnitAt(0);
//         String t = String.fromCharCode(aCode + (code - aCode + key) % 26);
//         cipher.write(t);
//       } else if (code >= "a".codeUnitAt(0) && code <= "z".codeUnitAt(0)) {
//         int aCode = "a".codeUnitAt(0);
//         String t = String.fromCharCode(aCode + (code - aCode + key) % 26);
//         cipher.write(t);
//       } else {
//         cipher.write(text[i]);
//       }
//     }

//     return cipher.toString();
//   }

//   /// Encrypt [text].
//   String encrypt(String text) {
//     return _convert(text, this.shift);
//   }

//   /// Decrypt [text].
//   String decrypt(String text) {
//     return _convert(text, 26 - shift);
//   }
// }
