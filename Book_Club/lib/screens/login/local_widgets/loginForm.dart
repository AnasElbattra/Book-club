import 'package:book_club/states/current_user.dart';
import 'package:book_club/widgets/shadowContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../generated/l10n.dart';
import '../../home/home_screen.dart';
import '../../sign_up/sign_up.dart';

class OurLoginForm extends StatefulWidget {
  const OurLoginForm({Key? key}) : super(key: key);

  @override
  State<OurLoginForm> createState() => _OurLoginFormState();
}

class _OurLoginFormState extends State<OurLoginForm> {
  final aut = FirebaseAuth.instance;

  void loginUser(String email, String password, BuildContext context) async {
    try {
      CurrentUser currentUser =
          Provider.of<CurrentUser>(context, listen: false);
      if (await currentUser.loginInUser(email, password)) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(
            content: Text("invalid log in "),
            backgroundColor: Colors.red,
          ));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    final tr = S.of(context);
    return ShadowContainer(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: Text(
              tr.login,
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.alternate_email),
              hintText: tr.email,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outline),
              hintText: tr.password,
            ),
            obscureText: true,
          ),
          SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Text(
                tr.login,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            onPressed: () async {
              return loginUser(
                  _emailController.text, _passwordController.text, context);
              // setState(() {
              //   S.load(Locale('en'));
              // });
              // print("en");
            },
          ),
          TextButton(
            child: Text(tr.dontHaveAccount),
            style: TextButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SignUp(),
                ),
              );
              // setState(() {
              //   S.load(Locale('ar'));
              // });
              // print ("ar");
            },
          ),
        ],
      ),
    );
  }
}
