import 'package:flutter/material.dart';
import 'package:save_ai/ui/profile.dart';
import 'package:save_ai/utils/router.dart';
import 'package:save_ai/widget/intro_view.dart';
import 'package:save_ai/ui/preference_pages/register_page_two.dart';
import 'package:save_ai/ui/preference_pages/register_page_four.dart';

import 'main_page.dart';

class PreferencePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PreferencePageState();
  }
}

class PreferencePageState extends State<PreferencePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return IntroView(
      pages: <Widget>[
        RegisterPageFour(),
        RegisterPageTwo(),
      ],
      onIntroCompleted: () {
        Navigate.pushPageReplacement(context, Profile());
      },
    );
  }
}
