import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:save_ai/data/users.dart';
import 'package:save_ai/ui/update_pages/register_page_five.dart';
import 'package:save_ai/utils/router.dart';
import 'package:save_ai/widget/intro_view.dart';
import 'package:save_ai/ui/update_pages/register_page_one.dart';
import 'package:save_ai/ui/update_pages/register_page_two.dart';
import 'package:save_ai/ui/update_pages/register_page_three.dart';
import 'package:save_ai/ui/update_pages/register_page_four.dart';
import 'package:save_ai/model/user.dart' as U;

import 'main_page.dart';

class UpdatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UpdatePageState();
  }
}

getUser() async {
  Response response;
  Dio dio = new Dio();
  response = await dio.get(
      "https://save-ai-api-staging.herokuapp.com/api/db/v_user?external_user_id=$UserID");
  User_Info = response.data["response"]["data"][0];
  UserID_Internal = response.data["response"]["data"][0]["user_id"];
  print(UserID_Internal);
}

updateUser() async {
  var formData = {
    "display_name":
        profile_name == null ? User_Info["display_name"] : profile_name,
    "first_name": "first name update",
    "last_name": "last name update",
    "location": {"lat": 30.2918842, "long": -81.3927381},
    "location_city_id": 2,
    "height": 5.5,
    "goal_id": goal,
    "interest_ids": interests,
    "love_language_ids": [love_language_pri, love_language_sec],
    "job_title": "SDE",
    "employer": "MS",
    "verified": false,
    "age": 25,
    "gender": gender,
    "user_status": "active",
    "birth_date": birth_date,
    "birth_time": birth_time,
    "birth_city_id": 1,
    "education_id": education,
    "profession_id": profession,
    "religion_id": religion,
    "ethnicity_id": ethnicity,
    "kids_id": kids,
    "description": bio,
    "\$where": {"user_id": UserID_Internal}
  };

  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.patch(
        "https://save-ai-api-staging.herokuapp.com/api/db/user",
        data: formData);

    // UserID_Internal = response.data["response"][0]["user_id"];
    // print(UserID_Internal);

    print('Update user successfully.');
  } on DioError catch (e) {
    print("Update user failed.");
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

class UpdatePageState extends State<UpdatePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return IntroView(
      pages: <Widget>[
        RegisterPageOne(),
        RegisterPageFour(),
        RegisterPageTwo(),
        RegisterPageFive(),
        RegisterPageThree()
      ],
      onIntroCompleted: () async {
        await getUser();
        await updateUser();
        await getUser();
        Navigate.pushPageReplacement(context, HomePage());
      },
    );
  }
}
