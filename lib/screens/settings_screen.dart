import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:osappw/Initialize/startup.dart';
import 'package:osappw/services/config.dart';
import 'package:osappw/widgets/weather_notifier.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  final  settings;
  const SettingScreen({Key key, this.settings}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  Config config = new Config();
  List<bool> _setting ;

  @override
  initState()  {
    super.initState();
    _getSettings();
  }


  Future<void> _getSettings() async{
    await config.loadSettings();
    setState(() {
      _setting = config.settings??widget.settings;
    });
  }


  @override
  void didChangeDependencies() {
    Provider.of<WeatherNotifier>(context).getSettings();
    setState(() => _setting = _setting??widget.settings??Provider.of<WeatherNotifier>(context).settings);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
   _setting = _setting??widget.settings??Provider.of<WeatherNotifier>(context).settings;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7),
              Theme.of(context).primaryColor.withOpacity(0.6),
              Theme.of(context).primaryColor.withOpacity(0.5),
              Theme.of(context).primaryColor.withOpacity(0.5),
              Theme.of(context).primaryColor.withOpacity(0.5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          )
        ),
        child: Visibility(
          visible: this._setting.isNotEmpty,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 90.0,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 40.0,
                      left: 15.0,
                      child: GestureDetector(
                        onTap: ()=>Navigator.pop(context),
                        child: Icon(Icons.arrow_back_ios, size: 26.0, color: Colors.white,),
                      ),
                    ),
                    Positioned(
                      top: 42.0,
                      left: 150.0,
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 21.0,
                          color: Colors.white,
                          letterSpacing: 1.0
                        ),
                      ),
                    )
                  ],
                )
              ),
              Padding(
                padding: EdgeInsets.only(top:1.0),
                child: Container(
                  height: 600.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    children: <Widget>[
                      buildSpaceTitle('UNITS', 0.0),
                      buildSettingsItem(60.0, 'Temperature', '\u1d52 F | \u1d52 C ',0),
                      buildSettingsItem(60.0, 'Wind Velocity', ' m/s | km/h ',1),
                      buildSpaceTitle('OTHER SETTINGS', 15.0,),
                      buildSettingsItem(60.0, 'Current Location',' OFF | ON ',2),
                      buildSpaceTitle('ABOUT OS APP', 15.0,),
                      buildBottomPad(),
                    ],
                  ),
                ),
              )
            ],

          ),
          replacement: Container(
            child: StartUp(),
          ),
        ),
      ),
    );
  }

  Widget buildSpaceTitle( String title, double top){
    return Padding(
      padding:  EdgeInsets.only(left:20.0, top: top),
      child: SizedBox(height: 20.0,
        child: Text(title,
          style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.8)
          ),
      ),
      ),
    );
  }

Widget buildBottomPad(){
  return Padding(
    padding: EdgeInsets.symmetric(vertical:8.0,horizontal: 10.0 ),
    child: Container(
      height: 235.0,
      child: Padding(
        padding:EdgeInsets.only(left:1.0, top: 8.0),
        child: Column(
          children: <Widget>[
            buildSettingsBtn('About', Icons.info_outline),
            SizedBox(height: 20.0,),
            buildSettingsBtn('Privacy Policy', Icons.lock_outline),
            SizedBox(height: 20.0,),
            buildSettingsBtn('Feedback', Icons.comment),
          ],
        )
      ),
    ),
  );
}


Widget buildSettingsBtn( String sText, IconData dataIcon){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 55.0,
      child: RaisedButton(onPressed: (){},
        color: Theme.of(context).primaryColor.withOpacity(0.7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(sText, style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 22.0,
              color: Colors.white,
            ),),
            Icon(dataIcon, color: Colors.white,)
          ],
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26.0)
        ),
      ),
    );
}
Widget buildSettingsItem(double h, String title, String subtitle , int index){
    return Padding(
      padding: EdgeInsets.symmetric(vertical:8.0,horizontal: 10.0 ),
      child: Container(
        height: h,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(40.0)
        ),
        child: Padding(
          padding:EdgeInsets.only(left:10.0),
          child: ListTile(
            title: Text(
              title,
              style: TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700]
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(left:18.0),
              child: Text(
                subtitle,
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500].withOpacity(0.6)
                ),
              ),
            ),
            onTap: () async{
              setState(() {
                config.setSettings(index);
            });
            },
            trailing: Padding(
              padding: EdgeInsets.only(bottom:15.0),
              child: Icon(
                (!this._setting[index])? FontAwesomeIcons.toggleOff:
                FontAwesomeIcons.toggleOn,
                size: 36.0,
                color: (!this._setting[index])? Colors.grey[300].withOpacity(0.8) : Theme.of(context).primaryColor.withOpacity(0.8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
