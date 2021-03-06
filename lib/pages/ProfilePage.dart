import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'ScreenArguments.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  SharedPreferences? sharePrefs;
  Map<String, dynamic> profile = {'username': '', 'name': '', "surname": ''};

  _getSharedPreferences() async {
    sharePrefs = await SharedPreferences.getInstance();

    var profileString = sharePrefs!.getString('profile');
    print('profileString');
    print(profileString);
    if (profileString != null) {
      setState(() {
        profile = convert.jsonDecode(profileString);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ProfilePage'),
          actions: [
            IconButton(
                onPressed: () {
                  _openEditPage();
                },
                icon: Icon(Icons.edit))
          ],
        ),
        body: Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text('email: ${profile['username']} ',
                        style: TextStyle(fontSize: 20, color: Colors.grey)),
                    SizedBox(height: 20),
                    Text('name: ${profile['name']} ',
                        style: TextStyle(fontSize: 20, color: Colors.grey)),
                    SizedBox(height: 20),
                    Text('surname: ${profile['surname']} ',
                        style: TextStyle(fontSize: 20, color: Colors.grey)),
                    SizedBox(height: 40),
                    MaterialButton(
                      onPressed: () {
                        _logout();
                      },
                      child:
                          Text("Logout", style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ],
            )));
  }

  _logout() async {
    sharePrefs = await SharedPreferences.getInstance();
    await sharePrefs!.remove('token');
    await sharePrefs!.remove('profile');

    Navigator.of(context, rootNavigator: true)
        .pushNamedAndRemoveUntil('/login', (route) => false);
  }

  _openEditPage() {
    //open EditProfilePage with ScreenArguments
    Navigator.pushNamed(context, '/editprofile',
        arguments: ScreenArguments(
          profile['name'],
          profile['surname'],
        ));
  }
}
