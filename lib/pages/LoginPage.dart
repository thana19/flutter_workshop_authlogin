import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  late SharedPreferences sharedPref;

  _initSharedPreferences() async {
    sharedPref = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  _login(var values) async {
    var url = Uri.parse('https://api.thana.in.th/workshop/login');
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: convert.jsonEncode(
            {'username': values['username'], 'password': values['password']}));
    var body = convert.jsonDecode(response.body);

    if (response.statusCode == 200) {
      final snackBar =
          SnackBar(content: Text('${values['username']} is Logged In'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      //save token to pref
      await sharedPref.setString('token', response.body);
      print(sharedPref.getString('token'));

      _getProfile(body);
    } else {
      final snackBar = SnackBar(content: Text(body['message']));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _getProfile(var token) async {
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
      print('statusCode == 200');
      //save profile to pref
      await sharedPref.setString('profile', response.body);
      print(sharedPref.getString('profile'));

      //open Launcher
      Navigator.pushNamed(
        context,
        '/launcher',
      );
    } else {
      print('get profile fail');
      print(body['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image(
                  image: AssetImage('assets/profile.png'),
                  height: 100,
                ),
                Text('Login',
                    style: TextStyle(fontSize: 20, color: Colors.blue)),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: FormBuilder(
                    key: _formKey,
                    initialValue: {'username': '', 'password': ''},
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          name: 'username',
                          decoration: InputDecoration(
                            labelText: 'Email',
                            filled: true,
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: 'please insert email'),
                            FormBuilderValidators.email(context),
                          ]),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 15),
                        FormBuilderTextField(
                          name: 'password',
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'password',
                            filled: true,
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: 'please insert password'),
                            FormBuilderValidators.minLength(context, 8,
                                errorText: 'min length 8 character'),
                          ]),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          child: MaterialButton(
                            onPressed: () {
                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate()) {
                                _login(_formKey.currentState!.value);
                              } else {
                                print("validation failed");
                              }
                            },
                            child: Text("Login",
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                                child: MaterialButton(
                              onPressed: () {
                                // open Homepage
                                Navigator.pushNamed(context, '/register');
                              },
                              child: Text('Register User',
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
        ),
      ),
    );
  }
}
