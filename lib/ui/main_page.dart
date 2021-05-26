import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:provider/provider.dart';
import 'package:save_ai/data/users.dart';
import 'package:save_ai/model/user.dart';
import 'package:save_ai/provider/feedback_position_provider.dart';
import 'package:save_ai/ui/profile.dart';
import 'package:save_ai/utils/router.dart';
import 'package:save_ai/widget/bottom_buttons.dart';
import 'package:save_ai/widget/bottom_buttons_widget.dart';
import 'package:save_ai/widget/user_card_widget.dart';
import 'package:tcard/tcard.dart';
import 'chat_page.dart';
import 'package:save_ai/style/theme.dart' as Theme;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User> users = Users;

  bool isUserInFocus = true;
  bool isEmpty = false;
  SwipingDirection swipingDirection_global;
  TCardController _controller = TCardController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
                // GestureDetector(
                //     onHorizontalDragUpdate: (details) {
                //       // Note: Sensitivity is integer used when you don't want to mess up vertical drag
                //       int sensitivity = 8;
                //       if (details.delta.dx > sensitivity) {
                //         // Right Swipe
                //         setState(() {
                //           isUserInFocus = true;
                //           swipingDirection = SwipingDirection.right;
                //         });
                //       } else if (details.delta.dx < -sensitivity) {
                //         //Left Swipe
                //         setState(() {
                //           isUserInFocus = true;
                //           swipingDirection = SwipingDirection.left;
                //         });
                //       }
                //     },
                //     child:
                Stack(
                    children: [
                      TCard(
                        cards: users.map(buildUser).toList(),
                        size: Size(size.width, size.height * 0.78),
                        controller: _controller,
                        onForward: (index, info) {
                          print(index);
                          if (info.direction == SwipDirection.Right) {
                            print('like');
                          } else {
                            print('dislike');
                          }
                        },
                        onBack: (index, info) {
                          setState(() {
                            isEmpty =  false;
                          });
                          print(index);
                        },
                        onEnd: () {
                          setState(() {
                            isEmpty =  true;
                          });
                        },
                      ),
                      if (isUserInFocus)
                        buildLikeBadge(swipingDirection_global)
                      else
                        Container(),
                      isEmpty
                          ? Center(
                              heightFactor: 10,
                              child: Column(
                                children: [
                                  Text(
                                    'We are working hard to find your match.',
                                    style: GoogleFonts.pangolin(
                                        fontSize: 24, color: Color(0xFF343d8f)),
                                  ),
                                  Text(
                                    'Please come back soon :)',
                                    style: GoogleFonts.pangolin(
                                        fontSize: 24, color: Color(0xFF343d8f)),
                                  ),
                                ],
                              ))
                          : Container(),
                    ],
                  ),

            // ),

            // ),
            //Expanded(child: Container()),
            buttonsRow(context),
            // HeartBeatAppBar(
            //   from: 1,
            //   to: 1,
            // ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFfdf6ee),
    );
  }

  Widget buttonsRow(BuildContext context) {
    return Expanded(
      // height: 60,
      // margin: EdgeInsets.symmetric(vertical: 48.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 60,
            width: 60,
            child: FloatingActionButton(
              heroTag: "dislike",
              onPressed: () {
                _controller.forward(direction: SwipDirection.Left);
              },
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
            height: 60,
            width: 60,
            child: FloatingActionButton(
              heroTag: "rewind",
              // mini: true,
              onPressed: () {
                _controller.back();
              },
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
            height: 60,
            width: 60,
            child: FloatingActionButton(
              heroTag: "like",
              onPressed: () {
                _controller.forward(direction: SwipDirection.Right);
                // AwesomeDialog(
                //   context: context,
                //   animType: AnimType.SCALE,
                //   dialogType: DialogType.NO_HEADER,
                //   body: Image.asset("assets/images/match.gif"),
                //   btnOk: null,
                //   autoHide: Duration(seconds: 2),
                // )..show();
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

  Widget buildAppBar() => AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigate.pushPage(context, Chats());
            },
            icon: Icon(Icons.chat, color: Color(0xFFff8552)),
            iconSize: 30,
          ),
          SizedBox(width: 16),
        ],
        leading: IconButton(
          onPressed: () {
            print(User_Info);
            Navigate.pushPage(context, Profile());
          },
          icon: Icon(Icons.person, color: Color(0xFFff8552)),
          iconSize: 30,
        ),
        //title: FaIcon(FontAwesomeIcons.fire, color: Colors.deepOrange),
        title: Text(
          "SAVE",
          style: GoogleFonts.cormorant(
              color: Color(0xFFff8552),
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
      );

  Widget buildUser(User user) {
    final userIndex = users.indexOf(user);
    // final isUserInFocus = userIndex == users.length - 1;

    return Listener(
      onPointerMove: (pointerEvent) {
        final provider =
            Provider.of<FeedbackPositionProvider>(context, listen: false);
        provider.updatePosition(pointerEvent.localDelta.dx);
      },
      onPointerCancel: (_) {
        final provider =
            Provider.of<FeedbackPositionProvider>(context, listen: false);
        provider.resetPosition();
      },
      onPointerUp: (_) {
        final provider =
            Provider.of<FeedbackPositionProvider>(context, listen: false);
        provider.resetPosition();
      },
      child: buildCard(user),
    );
  }

  //deprecated
  // Widget buildUser(User user) {
  //   final userIndex = users.indexOf(user);
  //   final isUserInFocus = userIndex == users.length - 1;
  //
  //   return Listener(
  //     onPointerMove: (pointerEvent) {
  //       final provider =
  //           Provider.of<FeedbackPositionProvider>(context, listen: false);
  //       provider.updatePosition(pointerEvent.localDelta.dx);
  //     },
  //     onPointerCancel: (_) {
  //       final provider =
  //           Provider.of<FeedbackPositionProvider>(context, listen: false);
  //       provider.resetPosition();
  //     },
  //     onPointerUp: (_) {
  //       final provider =
  //           Provider.of<FeedbackPositionProvider>(context, listen: false);
  //       provider.resetPosition();
  //     },
  //     child: Draggable(
  //       child: UserCardWidget(user: user, isUserInFocus: isUserInFocus),
  //       feedback: Material(
  //         type: MaterialType.transparency,
  //         child: UserCardWidget(user: user, isUserInFocus: isUserInFocus),
  //       ),
  //       childWhenDragging: Container(),
  //       onDragEnd: (details) => onDragEnd(details, user),
  //     ),
  //   );
  // }

  Widget buildCard(User user) {
    FeedbackPositionProvider provider =
        Provider.of<FeedbackPositionProvider>(context);
    SwipingDirection swipingDirection = provider.swipingDirection;

    if (swipingDirection == SwipingDirection.right) {
      setState(() {
        isUserInFocus = true;
        swipingDirection_global = swipingDirection;
      });
    } else if (swipingDirection == SwipingDirection.left) {
      setState(() {
        isUserInFocus = true;
        swipingDirection_global = swipingDirection;
      });
    } else if (swipingDirection == SwipingDirection.none) {
      setState(() {
        isUserInFocus = false;
        swipingDirection_global = swipingDirection;
      });
    }

    return Container(
      // height: size.height * 0.7,
      // width: size.width * 0.95,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          //image: AssetImage(user.imgUrl),
          image: NetworkToFileImage(url: user.imgUrl, file: null),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        // make sure we apply clip it properly
        // child: BackdropFilter(
        //   filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          alignment: Alignment.center,
          //color: Colors.grey.withOpacity(1),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black12, spreadRadius: 0.8),
              ],
              gradient: LinearGradient(
                colors: [Colors.black12, Colors.black87],
                begin: Alignment.center,
                stops: [0.4, 1],
                end: Alignment.bottomCenter,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 10,
                  left: 10,
                  bottom: 10,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildUserInfo(user: user),
                      // Padding(
                      //   padding: EdgeInsets.only(bottom: 16, right: 8),
                      //   child: Icon(Icons., color: Colors.white),
                      // )
                    ],
                  ),
                ),
                // if (isUserInFocus) buildLikeBadge(swipingDirection_global),
              ],
            ),
          ),
        ),
        // ),
      ),
    );
  }

  Widget buildLikeBadge(SwipingDirection swipingDirection) {
    final isSwipingRight = swipingDirection == SwipingDirection.right;
    final color = isSwipingRight ? Colors.green : Colors.pink;
    final angle = isSwipingRight ? -0.5 : 0.5;

    if (swipingDirection == SwipingDirection.none) {
      return Container();
    } else {
      return Positioned(
        top: 20,
        right: isSwipingRight ? 20 : null,
        left: isSwipingRight ? null : 20,
        child: Transform.rotate(
          angle: angle,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: color, width: 2),
            ),
            child: Text(
              isSwipingRight ? 'LIKE' : 'NOPE',
              style: TextStyle(
                color: color,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget buildUserInfo({@required User user}) => Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${user.name}, ${user.age}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              user.designation,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 4),
            Text(
              'Match Rating: ${user.ai}',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      );

  like(int likeId) async {
    var formData = {"user_id": UserID_Internal, "like_id": likeId};

    try {
      Response response;
      Dio dio = new Dio();
      response = await dio.post(
          "https://save-ai-api-staging.herokuapp.com/api/db/like",
          data: formData);
      print(response.data);
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        //print(e.response.headers);
        //print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
  }

  dislike(int dislikeID) async {
    var formData = {"user_id": UserID_Internal, "dislike_id": dislikeID};

    try {
      Response response;
      Dio dio = new Dio();
      response = await dio.post(
          "https://save-ai-api-staging.herokuapp.com/api/db/dislike",
          data: formData);
      print(response.data);
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        //print(e.response.headers);
        //print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
  }

  void onDragEnd(DraggableDetails details, User user) async {
    final minimumDrag = 200;
    if (details.offset.dx > minimumDrag) {
      user.isLiked = true;
      setState(() => users.remove(user));
      await like(user.uid);
    } else if (details.offset.dx < -minimumDrag) {
      user.isSwipedOff = true;
      setState(() => users.remove(user));
      await dislike(user.uid);
    }
  }
}
