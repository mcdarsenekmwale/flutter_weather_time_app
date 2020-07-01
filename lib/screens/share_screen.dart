import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class ShareScreen extends StatefulWidget {
  final   Uint8List image;

  const ShareScreen({Key key, this.image}) : super(key: key);
  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  final String subject = 'OS APP';
  final String imageName = 'OSAPP_Share.png';
  final String text = 'This image is shared from OS APP';
  final GlobalKey globalKey = new GlobalKey();


  @override
  void initState() {
    super.initState();
  }

  void shareImage(){
    Share.file(
        subject, imageName, widget.image.buffer.asUint8List(), 'image/png', text: text);
  }
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: new Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(34, 201, 190, 1),
                        Color.fromRGBO(34, 201, 190, 0.9),
                        Color.fromRGBO(34, 201, 190, 0.8),
                        Color.fromRGBO(34, 201, 190, 0.5),
                        Color.fromRGBO(34, 201, 190, 0.9),
                      ]
                  )
              ),
              child: Column(
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 80.0,
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
                            left: 132.0,
                            child: Text(
                              'Share Preview',
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
                  Container(
                    height: 600.0,
                    width:  400,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        child: Image.memory(widget.image, filterQuality: FilterQuality.high,),
                      ),
                    ),
                  ),
                  SizedBox(height: 25.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 90.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 55.0,
                      child: RaisedButton(onPressed: shareImage,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Icon(Icons.share, color: Color.fromRGBO(34, 201, 190, 1),),
                            Text('Share Now', style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22.0,
                              color: Color.fromRGBO(34, 201, 190, 1),
                            ),),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0)
                        ),
                      ),
                    ),
                  )
                ],
              ),
             )),
    );
  }
}

