import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:save_ai/data/chat_data.dart';
import 'package:save_ai/data/users.dart';
import 'package:save_ai/ui/preference_page.dart';
import 'package:save_ai/ui/settings_page.dart';
import 'package:save_ai/ui/update_page.dart';
import 'package:save_ai/utils/router.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
  static Random random = Random();

  List<String> tags = [
    User_Info['education_name'],
    User_Info['profession_name'],
    User_Info['religion_name'],
    User_Info['ethnicity_name'],
    User_Info['kids_name'],
    User_Info['goal_name'],
    User_Info['location_city_name'],
    five_love_languages[User_Info['love_language_ids'][0] - 1],
    five_love_languages[User_Info['love_language_ids'][1] - 1]
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2EB),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 60),
              CircleAvatar(
                backgroundImage: NetworkToFileImage(
                    url: User_Info['pictures'][0], file: null),
                radius: 50,
              ),
              SizedBox(height: 10),
              Text(
                User_Info['display_name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 3),
              Text(
                User_Info['description'] == null
                    ? ''
                    : User_Info['description'],
                style: TextStyle(),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FlatButton(
                    child: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    color: Color(0xFFff8552),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => SettingsPage()));
                    },
                  ),
                  SizedBox(width: 10),
                  FlatButton(
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    color: Color(0xFFff8552),
                    onPressed: () {
                      Navigate.pushPageReplacement(context, UpdatePage());
                    },
                  ),
                ],
              ),
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: _buildCategory_ll("Primary Love Language", tags),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     // _buildCategory("Pictures"),
                //     // SizedBox(width: 15),
                //     _buildCategory_ll("Love Language"),
                //     // SizedBox(width: 15),
                //     // _buildCategory("Matches"),
                //   ],
                // ),
              ),
              SizedBox(height: 20),
              GridView.builder(

                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                primary: false,
                padding: EdgeInsets.all(5),
                itemCount: 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 200 / 200,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Image.network(User_Info['pictures'][0]),
                    // child: Image.asset(
                    //   "assets/images/cm${random.nextInt(10)}.jpeg",
                    //   fit: BoxFit.cover,
                    // ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "upload",
        onPressed: () {},
        backgroundColor: const Color(0xFAfdf6ee),
        child: Icon(Icons.upload_sharp, color: Color(0xFFff8552)),
      ),
    );
  }

  Widget _buildCategory(String title) {
    return Column(
      children: <Widget>[
        Text(
          random.nextInt(20).toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(),
        ),
      ],
    );
  }

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

  Widget _buildCategory_ll(String title, List<String> _items) {
    int index = random.nextInt(4);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        // SizedBox(
        //   width: 250.0,
        //   child: ColorizeAnimatedTextKit(
        //     repeatForever: true,
        //     text: [five_love_languages[User_Info['love_language_ids'][0] - 1]],
        //     textStyle: TextStyle(
        //       fontSize: 25.0,
        //     ),
        //     colors: [
        //       Colors.purple,
        //       Colors.blue,
        //       Colors.yellow,
        //       Colors.red,
        //     ],
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        // SizedBox(height: 4),
        // Text(
        //   "Primary Love Language",
        //   style: TextStyle(),
        // ),
        // SizedBox(height: 15),
        // SizedBox(
        //   width: 250.0,
        //   child: ColorizeAnimatedTextKit(
        //     repeatForever: true,
        //     text: [five_love_languages[User_Info['love_language_ids'][1] - 1]],
        //     textStyle: TextStyle(
        //       fontSize: 25.0,
        //     ),
        //     colors: [
        //       Colors.purple,
        //       Colors.blue,
        //       Colors.yellow,
        //       Colors.red,
        //     ],
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        // SizedBox(height: 4),
        // Text(
        //   "Secondary Love Language",
        //   style: TextStyle(),
        // ),
        SizedBox(height: 10),
        Tags(
          key: _tagStateKey,
          // textField: TagsTextField(
          //   textStyle: TextStyle(fontSize: 16),
          //   constraintSuggestion: true, suggestions: [],
          //   //width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 10),
          //   onSubmitted: (String str) {
          //     // Add item to the data source.
          //     setState(() {
          //       // required
          //       _items.add(str);
          //     });
          //   },
          // ),
          alignment: WrapAlignment.center,
          spacing: 10,
          itemCount: _items.length,
          // required
          itemBuilder: (int index) {
            final item = _items[index];

            return ItemTags(
              // Each ItemTags must contain a Key. Keys allow Flutter to
              // uniquely identify widgets.
              key: Key(index.toString()),
              index: index,
              // required
              // color: Color(0xFFff8552),
              // highlightColor: Color(0xFFff8552),
              // colorShowDuplicate: Color(0xFFff8552),
              activeColor: Color(0xFFff8552),

              title: item,
              textStyle: TextStyle(
                fontSize: 16,
              ),
              combine: ItemTagsCombine.withTextBefore,
              // image: ItemTagsImage(
              //     image: AssetImage("assets/images/user1.jpg") // OR NetworkImage("https://...image.png")
              // ), // OR null,
              // icon: ItemTagsIcon(
              //   icon: Icons.add,
              // ), // OR null,
              // removeButton: ItemTagsRemoveButton(
              //   onRemoved: (){
              //     // Remove the item from the data source.
              //     setState(() {
              //       // required
              //       _items.removeAt(index);
              //     });
              //     //required
              //     return true;
              //   },
              // ), // OR null,
              onPressed: (item) => print(item),
              onLongPressed: (item) => print(item),
            );
          },
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
