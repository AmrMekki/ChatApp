import 'dart:io';

import 'package:chatapp/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  final bool isLoading;

  AuthForm(this.submitFn, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = "";
  String _userName = "";
  String _userPassword = "";
  late File _userImageFile;
  bool imagePicked = false;

  void _pickedImage(File image) {
    try {
      _userImageFile = image;
      imagePicked = true;
    } catch (e) {}
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    //close keyboard
    FocusScope.of(context).unfocus();

    if (!imagePicked && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Enter a valid image"),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();

      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: const ValueKey("email"),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains("@")) {
                        return "please enter email address";
                      }
                    },
                    onSaved: (value) {
                      _userEmail = value.toString();
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email address",
                    ),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey("username"),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return "Please enter at least four characters";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _userName = value.toString();
                      },
                      decoration: const InputDecoration(labelText: "User Name"),
                    ),
                  TextFormField(
                    key: const ValueKey("password"),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return "Password must be at least 7 characters long";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _userPassword = value.toString();
                    },
                    decoration: const InputDecoration(labelText: "Password"),
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    // ignore: deprecated_member_use
                    RaisedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? "Login" : "Sign up"),
                    ),
                  if (!widget.isLoading)
                    // ignore: deprecated_member_use
                    FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? "Create new account"
                            : "I already have an account"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
