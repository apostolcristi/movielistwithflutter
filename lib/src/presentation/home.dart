import 'package:flutter/cupertino.dart';
import 'package:movielistwithflutter/src/containers/user_container.dart';
import 'package:movielistwithflutter/src/models/index.dart';
import 'package:movielistwithflutter/src/presentation/home_page.dart';
import 'package:movielistwithflutter/src/presentation/login_page.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserContainer(
      builder: (BuildContext context, AppUser? user) {
        if (user != null) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
