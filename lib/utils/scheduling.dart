import 'package:dio/dio.dart';
import 'package:save_ai/data/users.dart';

List calendar = [];
// ignore: non_constant_identifier_names
List schedule_rec = [];

getCalendar() async {
  Response response;
  Dio dio = new Dio();
  response = await dio.get(
      'https://save-ai-api-staging.herokuapp.com/api/db/v_calendar?\$q={"\$where":{"\$or":[ { "inviter":"$UserID_Internal"}, { "invitee":"$UserID_Internal"} ]}}');

  print(response);

  try {
    List rep = response.data["response"]["data"];
    print(rep.length);
    calendar = List.generate(
        rep.length,
        (index) => {
              "calendar_id": rep[index]["calendar_id"],
              "inviter": rep[index]["inviter"],
              "invitee": rep[index]["invitee"],
              "start_time": rep[index]["start_time"],
              "end_time": rep[index]["end_time"],
              "status": rep[index]["status"],
              "inviter_name": rep[index]["inviter_name"],
              "invitee_name": rep[index]["invitee_name"],
              "inviter_pictures": rep[index]["inviter_pictures"][0],
              "invitee_pictures": rep[index]["invitee_pictures"][0],
              "location": rep[index]["location"][0],
            });
  } catch (e) {
    calendar = [];
  }
}

updateUserCal(List<List<int>> availability) async {
  var formData = {
    "availability": availability,
    "\$where": {"user_id": UserID_Internal}
  };

  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.patch(
        "https://save-ai-api-staging.herokuapp.com/api/db/user",
        data: formData);

    print(response.data);

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

updateCalendar(String status, int calendarID) async {
  var formData = {
    "status": status,
    "\$where": {"calendar_id": calendarID}
  };

  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.patch(
        "https://save-ai-api-staging.herokuapp.com/api/db/calendar",
        data: formData);

    print(response.data);

    print('Update calendar successfully.');
  } on DioError catch (e) {
    print("Update calendar failed.");
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

getScheduleRec() async {
  Response response;
  Dio dio = new Dio();
  response = await dio.get(
      'https://save-ai-api-staging.herokuapp.com/api/db/func/schedule_recommendation?user_id=$UserID_Internal');

  print(response);

  try {
    List rep = response.data["response"];
    print(rep.length);
    schedule_rec = List.generate(
        rep.length,
        (index) => {
              "name": rep[index]["display_name"],
              "dp": rep[index]["pictures"][0],
              "user_id": rep[index]["user_id"],
              "matched_availability": rep[index]["matched_availability"],
              "ai": rep[index]["ai"],
              "location_city": rep[index]["location_city"],
            });
  } catch (e) {
    schedule_rec = [];
  }
}

Future<String> getZoomLink() async {
  var formData = {};

  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.post(
        "https://save-ai-api-staging.herokuapp.com/api/meeting/create",
        data: formData);

    print('Get zoom link');

    return response.data['response']['start_url'];
  } on DioError catch (e) {
    print("Get zoom link failed.");
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

addCalendar(int invitee, String stime, String etime) async {
  var formData = {
    "inviter": "$UserID_Internal",
    "invitee": "$invitee",
    "start_time": stime,
    "end_time": etime
  };

  try {
    Response response;
    Dio dio = new Dio();
    response = await dio.post(
        "https://save-ai-api-staging.herokuapp.com/api/db/calendar",
        data: formData);

    print('Add calendar successfully.');
  } on DioError catch (e) {
    print("Add calendar failed.");
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
