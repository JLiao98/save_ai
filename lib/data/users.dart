import 'package:save_ai/model/user.dart';

// ignore: non_constant_identifier_names
String UserID;
// ignore: non_constant_identifier_names
int UserID_Internal;

// ignore: non_constant_identifier_names
String Reg_UID, Reg_Name, Reg_Email;

// ignore: non_constant_identifier_names
var User_Info;

List<int> interests = [];
// ignore: non_constant_identifier_names
List Interests,
    Love_language,
    Goal,
    Education,
    Profession,
    Religion,
    Ethnicity,
    Kids;

int love_language_pri = 1,
    love_language_sec = 1,
    goal = 1,
    education = 1,
    profession = 1,
    religion = 1,
    ethnicity = 1,
    kids = 1;

String birth_date, birth_time, birth_country, birth_state, birth_city, bio, profile_name, current_country, current_state, current_city;

var Gender = ["Male", "Female"], gender;

final List<String> five_love_languages = [
  "Receiving Gifts",
  "Acts of Service",
  "Quality Time",
  "Words of Affirmation",
  "Physical Touch"
];

List<String> Global_tags = [
  "Male",
  "Single",
  "City",
  "Education",
  "Profession",
  "Religion",
  "Ethnicity",
  "Kids"
];

// ignore: non_constant_identifier_names
List<User> Users;

// final dummyUsers = [
//   User(
//       name: 'Lauren Turner',
//       designation: 'Content Writer',
//       ai: 4,
//       bio:
//           'Psychology, science, and art are what helps me to learn the outside world and myself.',
//       age: 24,
//       imgUrl: 'assets/images/user1.jpg',
//       location: 'North London'),
//   User(
//     name: 'Lori Perez',
//     designation: 'UI Designer ',
//     ai: 8,
//     bio:
//         'Travelling, adventures, extreme sports are also an integral part of me, but I like watching and admiring extreme sports rather than doing it ?',
//     location: 'Leeds',
//     age: 26,
//     imgUrl: 'assets/images/user2.jpg',
//   ),
//   User(
//     name: 'Christine Wallace',
//     designation: 'News Reporter',
//     ai: 2,
//     bio:
//         'Psychology, science, and art are what helps me to learn the outside world and myself.',
//     location: 'Liverpool',
//     age: 23,
//     imgUrl: 'assets/images/user3.jpg',
//   ),
//   User(
//     name: 'Rachel Green',
//     designation: 'Architect',
//     ai: 8,
//     bio:
//         'Psychology, science, and art are what helps me to learn the outside world and myself.',
//     location: 'Nottingham',
//     age: 22,
//     imgUrl: 'assets/images/user4.jpg',
//   ),
//   User(
//     name: 'Emma',
//     designation: 'Software Developer',
//     ai: 3,
//     bio:
//         'Psychology, science, and art are what helps me to learn the outside world and myself.',
//     location: 'Manchester',
//     age: 25,
//     imgUrl: 'assets/images/user5.jpg',
//   ),
//   User(
//     name: 'Kim Wexler',
//     designation: 'Accountant',
//     ai: 5,
//     bio:
//         'Psychology, science, and art are what helps me to learn the outside world and myself.',
//     location: 'Birmingham',
//     age: 30,
//     imgUrl: 'assets/images/user6.jpg',
//   ),
// ];
