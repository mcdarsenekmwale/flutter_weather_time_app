import 'package:flutter/material.dart';

class SnackBarWidget extends SnackBar {
  final String message;

  const SnackBarWidget({Key key, this.message}) ;

  Widget build(BuildContext context) {
    return  SnackBar(content: Container(
      width: 50.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: Padding(
        padding:  EdgeInsets.only(left:100.0),
        child: Text(message,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white, ), ),
      ),
    ),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
      behavior: SnackBarBehavior.floating, duration: Duration(seconds: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
          bottom:Radius.circular(20),
        ),
      ),
    );
  }
}
