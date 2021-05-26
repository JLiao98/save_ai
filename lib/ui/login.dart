import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:save_ai/data/users.dart';
import 'package:save_ai/ui/privacy.dart';
import 'package:save_ai/ui/register_page.dart';
import 'package:save_ai/ui/terms.dart';
import 'package:save_ai/utils/animations.dart';
import 'package:save_ai/utils/const.dart';
import 'package:save_ai/utils/enum.dart';
import 'package:save_ai/utils/router.dart';
import 'package:save_ai/utils/validations.dart';
import 'package:save_ai/widget/custom_button.dart';
import 'package:save_ai/widget/custom_text_field.dart';
import 'package:save_ai/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:save_ai/model/user.dart' as U;

// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';

// import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:dio/dio.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;
  bool validate = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String email, password, name, uid = '';
  FocusNode nameFN = FocusNode();
  FocusNode emailFN = FocusNode();
  FocusNode passFN = FocusNode();
  FormMode formMode = FormMode.LOGIN;

  submit() async {
    FormState form = formKey.currentState;
    form.save();
    if (!form.validate()) {
      validate = true;
      setState(() {});
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      if (formMode == FormMode.LOGIN) {
        await signin();
      } else if (formMode == FormMode.REGISTER) {
        await registration();
      } else if (formMode == FormMode.FORGOT_PASSWORD) {
      } else {}
    }
  }

  getRegisterPages() async {
    Response response;
    Dio dio = new Dio();
    response = await dio
        .get("https://save-ai-api-staging.herokuapp.com/api/db/interest");
    Interests = response.data["response"]["data"];

    response = await dio
        .get("https://save-ai-api-staging.herokuapp.com/api/db/love_language");
    Love_language = response.data["response"]["data"];

    response =
        await dio.get("https://save-ai-api-staging.herokuapp.com/api/db/goal");
    Goal = response.data["response"]["data"];

    response = await dio
        .get("https://save-ai-api-staging.herokuapp.com/api/db/education");
    Education = response.data["response"]["data"];

    response = await dio
        .get("https://save-ai-api-staging.herokuapp.com/api/db/profession");
    Profession = response.data["response"]["data"];

    response = await dio
        .get("https://save-ai-api-staging.herokuapp.com/api/db/religion");
    Religion = response.data["response"]["data"];

    response = await dio
        .get("https://save-ai-api-staging.herokuapp.com/api/db/ethnicity");
    Ethnicity = response.data["response"]["data"];

    response =
        await dio.get("https://save-ai-api-staging.herokuapp.com/api/db/kids");
    Kids = response.data["response"]["data"];
  }

  getRec() async {
    Response response;
    Dio dio = new Dio();
    response = await dio.get(
        "https://save-ai-api-staging.herokuapp.com/api/db/func/recommendation?external_user_id=$UserID");
    List rep = response.data["response"];
    print(rep.length);
    Users = List.generate(
        rep.length,
        (index) => U.User(
            uid: rep[index]["user_id"],
            name: rep[index]["display_name"],
            designation: rep[index]["profession_name"],
            ai: rep[index]["ai"],
            bio: '',
            age: rep[index]["age"],
            imgUrl: rep[index]["pictures"][0],
            location: ''));
  }

  getUser() async {
    Response response;
    Dio dio = new Dio();
    response = await dio.get(
        "https://save-ai-api-staging.herokuapp.com/api/db/v_user?external_user_id=$UserID");
    print(response);
    User_Info = response.data["response"]["data"][0];
    UserID_Internal = response.data["response"]["data"][0]["user_id"];
    print("USERID: " + UserID_Internal.toString());
  }

  registration() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      String token = await userCredential.user.getIdToken();
      uid = userCredential.user.uid;
      UserID = uid;
      Reg_Name = name;
      Reg_Email = email;
      print(uid);
      showInSnackBar(
          "Retrieving the data and directing to the register page...");
      await getRegisterPages();
      Navigate.pushPage(context, RegisterPage());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showInSnackBar('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showInSnackBar('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  signin() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      uid = userCredential.user.uid;
      UserID = uid;
      await getUser();
      await getRec();
      Navigate.pushPageReplacement(context, HomePage());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showInSnackBar('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showInSnackBar('Wrong password provided for that user.');
      }
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFfdf6ee),
      body: SingleChildScrollView(
          child: Container(
        height: 960,
        child: Row(
          children: [
            buildLottieContainer(),
            Expanded(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                child: Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: buildFormContainer(),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  buildLottieContainer() {
    final screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      width: screenWidth < 700 ? 0 : screenWidth * 0.5,
      duration: Duration(milliseconds: 500),
      color: Theme.of(context).accentColor.withOpacity(0.3),
      child: Center(
        child: Lottie.asset(
          AppAnimations.chatAnimation,
          height: 400,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void showAlertDialog(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Align(
                  child: Text(message),
                  alignment: Alignment(0, 0),
                ),
              ],
            ),
            actions: <Widget>[
              // CupertinoDialogAction(
              //   child: Text("取消"),
              //   onPressed: () {
              //     Navigator.pop(context);
              //     print("取消");
              //   },
              // ),
              CupertinoDialogAction(
                child: Text("Confirm"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  buildFormContainer() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SafeArea(
            child: Text(
          '${Constants.appName}',
          style: GoogleFonts.cormorant(
              fontSize: 65,
              fontWeight: FontWeight.bold,
              color: Color(0xFFff8552)),
        ).fadeInList(0, false)),
        Center(
          child: RichText(
            text: TextSpan(
                text: 'LOVE IS MADE IN HEAVEN AND ',
                style: GoogleFonts.cormorant(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF343d8f)),
                children: [
                  TextSpan(
                      text: 'SAVE',
                      style: GoogleFonts.cormorant(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFff8552)),
                      children: []),
                  TextSpan(
                      text: 'D ON EARTH.',
                      style: GoogleFonts.cormorant(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF343d8f)),
                      children: []
                  )
                ]),
          ).fadeInList(0, false),
          // child: Text(
          //   'Love is made in heaven and saved on earth.',
          //   style: GoogleFonts.cormorant(
          //       fontSize: 20,
          //       fontWeight: FontWeight.bold,
          //       color: Color(0xFF343d8f)),
          // ).fadeInList(0, false),
        ),
        SizedBox(height: 40.0),
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: buildForm(),
        ),
        Visibility(
          visible: formMode == FormMode.LOGIN,
          child: Column(
            children: [
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  onPressed: () {
                    formMode = FormMode.FORGOT_PASSWORD;
                    setState(() {});
                  },
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.asul(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF343d8f)),
                  ),
                ),
              ),
            ],
          ),
        ).fadeInList(3, false),
        SizedBox(height: 15.0),
        buildButton(),
        SizedBox(height: 10.0),
        Visibility(
          visible: formMode == FormMode.LOGIN,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Don\'t have an account?',
                  style: GoogleFonts.asul(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF343d8f))),
              FlatButton(
                onPressed: () {
                  formMode = FormMode.REGISTER;
                  setState(() {});
                },
                child: Text('Register',
                    style: GoogleFonts.asul(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF343d8f))),
              ),
            ],
          ),
        ).fadeInList(5, false),
        Visibility(
          visible: formMode != FormMode.LOGIN,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Already have an account?',
                  style: GoogleFonts.asul(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF343d8f))),
              FlatButton(
                onPressed: () {
                  formMode = FormMode.LOGIN;
                  setState(() {});
                },
                child: Text('Login',
                    style: GoogleFonts.asul(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF343d8f))),
              ),
            ],
          ),
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.apple,
              color: Color(0xFFff8552),
              size: 15.0,
            ),
            FlatButton(
              onPressed: () {
                formMode = FormMode.REGISTER;
                setState(() {});
              },
              child: formMode == FormMode.LOGIN
                  ? Text('Sign in with Apple',
                      style: GoogleFonts.asul(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87))
                  : Text('Sign up with Apple',
                      style: GoogleFonts.asul(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87)),
            ),
          ],
        ).fadeInList(3, false),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.google,
              color: Color(0xFFff8552),
              size: 15.0,
            ),
            FlatButton(
              onPressed: () {
                formMode = FormMode.REGISTER;
                setState(() {});
              },
              child: formMode == FormMode.LOGIN
                  ? Text('Sign in with Google',
                      style: GoogleFonts.asul(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87))
                  : Text('Sign up with Google',
                      style: GoogleFonts.asul(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87)),
            ),
          ],
        ).fadeInList(3, false),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.facebook,
              color: Color(0xFFff8552),
              size: 15.0,
            ),
            FlatButton(
              onPressed: () {
                formMode = FormMode.REGISTER;
                setState(() {});
              },
              child: formMode == FormMode.LOGIN
                  ? Text('Sign in with Facebook',
                      style: GoogleFonts.asul(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87))
                  : Text('Sign up with Facebook',
                      style: GoogleFonts.asul(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87)),
            ),
          ],
        ).fadeInList(3, false),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.linkedin,
              color: Color(0xFFff8552),
              size: 15.0,
            ),
            FlatButton(
              onPressed: () {
                formMode = FormMode.REGISTER;
                setState(() {});
              },
              child: formMode == FormMode.LOGIN
                  ? Text('Sign in with LinkedIn',
                      style: GoogleFonts.asul(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87))
                  : Text('Sign up with LinkedIn',
                      style: GoogleFonts.asul(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87)),
            ),
          ],
        ).fadeInList(3, false),
        SizedBox(height: 20),
        SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Don't worry! We never collect your personal data.",
                style: GoogleFonts.asul(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.black54)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                    onPressed: () async {
                      //await _launchURLTerms();
                      //showAlertDialog("Terms of Service", """  """);
                      Navigate.pushPage(context, TermsPage());
                    },
                    child: Text("Terms of Service",
                        style: GoogleFonts.asul(
                            fontSize: 11,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.normal,
                            color: Colors.black38))),
                FlatButton(
                    onPressed: () async {
                      //await _launchURLPrivacy();
                      Navigate.pushPage(context, PrivacyPage());
                    },
                    child: Text("Privacy Policy",
                        style: GoogleFonts.asul(
                            fontSize: 11,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.normal,
                            color: Colors.black38))),
              ],
            )
          ],
        ))
      ],
    ).fadeInList(3, false);
  }

  _launchURLTerms() async {
    const url = 'https://bumble.com/terms';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURLPrivacy() async {
    const url = 'https://bumble.com/privacy';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Visibility(
          visible: formMode == FormMode.REGISTER,
          child: Column(
            children: [
              CustomTextField(
                enabled: !loading,
                hintText: "Name",
                textInputAction: TextInputAction.next,
                validateFunction: Validations.validateName,
                onSaved: (String val) {
                  name = val;
                },
                focusNode: nameFN,
                nextFocusNode: emailFN,
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
        CustomTextField(
          enabled: !loading,
          hintText: "Email",
          textInputAction: TextInputAction.next,
          validateFunction: Validations.validateEmail,
          onSaved: (String val) {
            email = val;
          },
          focusNode: emailFN,
          nextFocusNode: passFN,
        ).fadeInList(1, false),
        Visibility(
          visible: formMode != FormMode.FORGOT_PASSWORD,
          child: Column(
            children: [
              SizedBox(height: 20.0),
              CustomTextField(
                enabled: !loading,
                hintText: "Password",
                textInputAction: TextInputAction.done,
                validateFunction: Validations.validatePassword,
                submitAction: submit,
                obscureText: true,
                onSaved: (String val) {
                  password = val;
                },
                focusNode: passFN,
              ),
            ],
          ),
        ).fadeInList(2, false),
      ],
    );
  }

  buildButton() {
    return loading
        ? Center(child: CircularProgressIndicator())
        : CustomButton(
            label: "Submit",
            onPressed: () => submit(),
          ).fadeInList(4, false);
  }
}
