import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:osappw/services/startup_service.dart';

class StartUp extends StatefulWidget {
  @override
  _StartUpState createState() => _StartUpState();
}

class _StartUpState extends State<StartUp> {

Future<void> _getReadyData() async{

    StartUpService serviceData = new StartUpService();
    await serviceData.getReadyData();
         return Navigator.pushReplacementNamed(context, '/home', arguments:{
           '_weather':serviceData.service['_weather'],
           '_time':serviceData.service['_time'],
           '_settings':serviceData.service['_settings']
         });

  }

  @override
  void initState() {
    super.initState();
    _getReadyData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: LinearGradient(colors: [
            Colors.white.withOpacity(0.7),
            Colors.white.withOpacity(0.4),
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.8)
          ])
        ),
        child: Container(
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Container(
                        height: 110.0,
                        width: 110.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                              image: AssetImage('assets/icon.png'),
                            fit: BoxFit.cover,
                          )
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Text('OS APP',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 23.0,
                      color: Theme.of(context).primaryColor.withOpacity(0.7)
                    ),
                    ),
                  ],
                ),
                Positioned(
                  left: 180.0,
                  bottom: 100.0,
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,),
                )
              ],
            ),
        ),
      ),
    );
  }
}
