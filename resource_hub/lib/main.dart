import 'package:flutter/material.dart';
import 'package:resourcehub/Globals.dart';
import 'package:resourcehub/Pages/Skeleton.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs){
    darkThemeEnabled = prefs.getBool('darkTheme');
    darkThemeEnabled = (darkThemeEnabled==null)?false:darkThemeEnabled;
    runApp(MyApp());
  });
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBuilder(builder: (context) {
      return new MaterialApp(
          title: 'Flutter Demo',
          theme: darkThemeEnabled?darkMode():lightMode(),
          home: Skeleton(),
          debugShowCheckedModeBanner: false,
      );
    });
  }
}

class AppBuilder extends StatefulWidget {
  final Function(BuildContext) builder;

  const AppBuilder(
      {Key key, this.builder})
      : super(key: key);

  @override
  AppBuilderState createState() => new AppBuilderState();

  @deprecated
  static AppBuilderState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<AppBuilderState>());
  }
}

class AppBuilderState extends State<AppBuilder> {

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }

  void rebuild() {
    setState(() {});
  }
}

// class InitialApp extends StatefulWidget{
//   InitialAppState createState() => InitialAppState();
// }

// class InitialAppState extends State<InitialApp>{



//   @override
//   Widget build(BuildContext context) {
//     final theme = Provider.of<ThemeChanger>(context);
//     return ChangeNotifierProvider<ThemeChanger>(
//       create: (_) => ThemeChanger(darkThemeEnabled?darkMode():lightMode()),
//       child: new MaterialApp(
//         title: 'Flutter Demo',
//         theme: theme.getTheme(),
//         home: Skeleton(),
//         debugShowCheckedModeBanner: false,
//     ));
//   }

//   void onChangeTheme(){
//     setState(() {
//     });
//   }
// }


