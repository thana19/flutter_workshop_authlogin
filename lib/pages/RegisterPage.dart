import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  _register(var values) async {
    var url = Uri.parse('https://api.thana.in.th/workshop/register');
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: convert.jsonEncode({
          'username': values['username'],
          'password': values['password'],
          'name': values['name'],
          'surname': values['surname']
        }));

    var body = convert.jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(response.body);
      final snackBar =
          SnackBar(content: Text('${body['username']} is registered'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Future.delayed(Duration(seconds: 3), () {
        Navigator.pop(context);
      });
    } else {
      print(body['message']);

      final snackBar =
          SnackBar(content: Text('${values['username']} is not registered'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('RegisterPage'),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: FormBuilder(
                    key: _formKey,
                    initialValue: {
                      'username': '',
                      'password': '',
                      'name': '',
                      'surname': '',
                    },
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
                          ]),
                        ),
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
                                  print('register');
                                  _formKey.currentState!.save();
                                  _register(_formKey.currentState!.value);
                                } else {
                                  print("validation failed");
                                }
                              },
                              child: Text('Register',
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
