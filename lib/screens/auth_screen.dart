import 'package:flutter/material.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(1),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Container(
              height: deviceSize.height * 0.61,
              width: deviceSize.width * 0.8,
              child: AuthCard(),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  AuthMode _authMode = AuthMode.Login;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  bool _isLoading = false;

  void _switchAuthMode() {
    setState(() {
      if (_authMode == AuthMode.Login) {
        _authMode = AuthMode.Signup;
      } else {
        _authMode = AuthMode.Login;
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_authMode == AuthMode.Login) {
      // Log user in
    } else {
      // Sign user up
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 3,
                  ),
                ),
                child: Text(
                  'SHOP APP',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'E-Mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) {
                  _authData['email'] = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter Your Email!';
                  } else if (!value.contains('@') || value.length < 6) {
                    return 'Please Enter a valid mail';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (value) {
                  _authData['password'] = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter Your Password';
                  } else if (value.length < 5) {
                    return 'Password Is Too Short';
                  }
                  return null;
                },
              ),
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: _authMode == AuthMode.Login
                      ? null
                      : (value) {
                          if (value.isEmpty) {
                            return 'Please Confirm Your Password';
                          } else if (value != _passwordController.text) {
                            return 'Password Does Not Match';
                          }
                          return null;
                        },
                ),
              SizedBox(
                height: 20,
              ),
              _isLoading
                  ? CircularProgressIndicator()
                  : RaisedButton(
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      onPressed: _submit,
                      child: Text(
                        '${_authMode == AuthMode.Login ? 'LOGIN' : 'SIGNUP'}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
              FlatButton(
                onPressed: _switchAuthMode,
                child: Text(
                  '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
