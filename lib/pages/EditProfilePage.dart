import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'ScreenArguments.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormBuilderState>();
  SharedPreferences? sharePrefs;
  Map<String, dynamic> profile = {'username': '', 'name': '', "surname": ''};
  Map<String, dynamic> token = {'access_token': ''};

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

    var tokenString = sharePrefs!.getString('token');
    print('tokenString');
    print(tokenString);
    if (tokenString != null) {
      setState(() {
        token = convert.jsonDecode(tokenString);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getSharedPreferences();
  }

  _updateProfile(var values) async {
    var url = Uri.parse('https://api.thana.in.th/workshop/updateprofile');
    var response = await http.patch(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${token['access_token']}',
        },
        body: convert.jsonEncode({
          'userId': profile['userid'],
          'name': values['name'],
          'surname': values['surname']
        }));

    var body = convert.jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(response.body);

      Navigator.pushNamed(context, '/launcher');
      _updateSharedPreferences();
    } else {
      print(response.body);
      print(body['message']);
      // _logout();
    }
  }

  _updateSharedPreferences() async {
    //http get profile
    var url = Uri.parse('https://api.thana.in.th/workshop/getprofile');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token['access_token']}',
      },
    );
    var body = convert.jsonDecode(response.body);

    if (response.statusCode == 200) {
      print('response.body');
      print(response.body);
      print(body['username']);

      //save profile to pref
      await sharePrefs!.setString('profile', response.body);
      print(sharePrefs!.getString('username'));
    } else {
      print('fail');
      print(body['message']);
      // _logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenAgr =
        ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Scaffold(
        appBar: AppBar(title: Text('${screenAgr.name} ${screenAgr.surname}')),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: FormBuilder(
                    key: _formKey,
                    initialValue: {
                      'name': screenAgr.name,
                      'surname': screenAgr.surname,
                    },
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        FormBuilderTextField(
                          name: 'name',
                          decoration: InputDecoration(
                            labelText: 'name',
                            filled: true,
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: 'please insert name'),
                          ]),
                        ),
                        SizedBox(height: 15),
                        FormBuilderTextField(
                          name: 'surname',
                          decoration: InputDecoration(
                            labelText: 'surname',
                            filled: true,
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: 'please insert surname'),
                          ]),
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                                child: MaterialButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  print('updateprofile');
                                  _formKey.currentState!.save();
                                  //update profile
                                  _updateProfile(_formKey.currentState!.value);
                                } else {
                                  print("validation failed");
                                }
                              },
                              child: Text('Save',
                                  style: TextStyle(color: Colors.blue)),
                            ))
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
