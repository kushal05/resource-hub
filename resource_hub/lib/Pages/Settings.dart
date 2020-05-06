import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:resourcehub/Globals.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {


  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

    Map<int, Color> color =
  {
    50:Color.fromRGBO(136,14,79, .1),
    100:Color.fromRGBO(136,14,79, .2),
    200:Color.fromRGBO(136,14,79, .3),
    300:Color.fromRGBO(136,14,79, .4),
    400:Color.fromRGBO(136,14,79, .5),
    500:Color.fromRGBO(136,14,79, .6),
    600:Color.fromRGBO(136,14,79, .7),
    700:Color.fromRGBO(136,14,79, .8),
    800:Color.fromRGBO(136,14,79, .9),
    900:Color.fromRGBO(136,14,79, 1),
  };

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
      var iconColor= Theme.of(context).accentColor;
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back),
        title: Text("Settings"),
        actions: <Widget>[
          Padding(
              padding: EdgeInsetsDirectional.only(end: 16),
              child: Icon(Icons.brightness_2)
          )

        ],
      ),
        body: Container(
          child: ListView(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
            children: <Widget>[

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  debugPrint("acc pressed");
                },
                child: ListTile(
                  leading:  Icon(
                      Icons.brightness_2,
                      color: iconColor
                  ),
                  trailing: Switch(
                    value: darkThemeEnabled, 
                    onChanged: (value){
                      darkThemeEnabled=value;
                      setState(() {
                        setTheme(darkThemeEnabled);
                      });
                      // ignore: deprecated_member_use_from_same_package
                      AppBuilder.of(context).rebuild();
                    },
                  ),
                  title: Text("Dark Mode"),
                  ),
              ),

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  showDialog(
                    context: context,
                    child: AlertDialog(
                      title: const Text('Pick a color!'),
                      content: SingleChildScrollView(
                        child: BlockPicker(
                          pickerColor: pickerColor,
                          onColorChanged: changeColor,
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: const Text('Choose'),
                          onPressed: () {
                            currentColor = pickerColor;
                            accentColor = pickerColor;
                            debugPrint("${pickerColor.value}");
                            setState((){
                            });
                            Navigator.of(context).pop();
                            AppBuilder.of(context).rebuild();
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: ListTile(
                  leading:  Icon(
                      Icons.brightness_1,
                      color: iconColor
                  ),
                  title: Text("Accent color"),
                ),
              ),

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  debugPrint("acc pressed");
                },
                child: ListTile(
                  leading:  Icon(
                      Icons.build,
                      color: iconColor
                  ),
                  title: Text("Account"),
                  subtitle: Text("change account, privacy"),
                ),
              ),

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  debugPrint("acc pressed");
                },
                child: ListTile(
                  leading: Icon(
                      Icons.exit_to_app,
                      color: iconColor
                  ),
                  title: Text("Logout"),
                  subtitle: Text("change account, privacy"),
                ),
              ),

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  debugPrint("acc pressed");
                },
                child: ListTile(
                  leading: Icon(
                      Icons.notifications,
                      color: iconColor
                  ),
                  title: Text("Notifications"),
                  subtitle: Text("turn on and off app notifications"),
                ),
              ),

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  debugPrint("acc pressed");
                },
                child: ListTile(
                  leading: Icon(
                      Icons.bug_report,
                      color: iconColor
                  ),
                  title: Text("Bug Report"),
                  subtitle: Text("change account, privacy"),
                ),
              ),

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  debugPrint("acc pressed");
                },
                child: ListTile(
                  leading: Icon(
                    Icons.help,
                    color: iconColor,
                  ),
                  title: Text("Help"),
                  subtitle: Text("FAQ,contact us,privacy policy"),
                ),
              ),

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  final RenderBox box = context.findRenderObject();

                  Share.share("Hey! Checkout this cool new app called ResourceHub",
                      subject: "Hey! Checkout this cool new app called ResourceHub",
                      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
                },
                child: ListTile(
                    leading: Icon(
                      Icons.people,
                      color: iconColor,
                    ),
                    title: Text("Invite a friend")
                ),
              ),

            ],
          ),
        )
    );
  }

  void setTheme(bool darkThemeEnabled) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkTheme', darkThemeEnabled);
    print("Setting dark theme as: $darkThemeEnabled");
  }
}
