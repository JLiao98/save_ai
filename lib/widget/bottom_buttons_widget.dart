import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

Widget buttonsRow(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 48.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 55,
          width: 55,
          child: FloatingActionButton(
            heroTag: "dislike",
            onPressed: () {},
            backgroundColor: const Color(0xFAfdf6ee),
            child: Icon(
              Icons.close_outlined,
              color: Color(0xFF343d8f),
              size: 35,
            ),
          ),
        ),

        // Padding(padding: EdgeInsets.only(right: 8.0)),
        SizedBox(
          height: 55,
          width: 55,
          child: FloatingActionButton(
            heroTag: "rewind",
            // mini: true,
            onPressed: () {},
            backgroundColor: const Color(0xFAfdf6ee),
            child: Icon(
              Icons.settings_backup_restore,
              color: Color(0xFF343d8f),
              size: 35,
            ),
          ),
        ),
        // Padding(padding: EdgeInsets.only(right: 8.0)),
        SizedBox(
          height: 55,
          width: 55,
          child: FloatingActionButton(
            heroTag: "like",
            onPressed: () {
              AwesomeDialog(
                context: context,
                animType: AnimType.SCALE,
                dialogType: DialogType.NO_HEADER,
                body: Image.asset("assets/images/match.gif"),
                btnOk: null,
                autoHide: Duration(seconds: 2),
              )..show();
            },
            backgroundColor: const Color(0xFAfdf6ee),
            child: Icon(
              Icons.favorite,
              color: Color(0xFFff8552),
              size: 35,
            ),
          ),
        ),

        // Padding(padding: EdgeInsets.only(right: 8.0)),
        // FloatingActionButton(
        //   heroTag: "superlike",
        //   mini: true,
        //   onPressed: () {},
        //   backgroundColor: const Color(0xFAfdf6ee),
        //   child: Icon(Icons.star, color: Colors.blue),
        // ),
      ],
    ),
  );
}

class BottomButtonsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.replay, color: Colors.yellow),
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.close, color: Colors.red),
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.star, color: Colors.blue),
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.favorite, color: Colors.green),
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.flash_on, color: Colors.purple),
          ),
        ],
      );
}
