import 'package:driver/services/user_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController = TextEditingController();

  final UserService userService = UserService();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Logo(),
                TextField(
                  title: "Email",
                  description: "Enter your email",
                  icon: Icons.person_outline,
                  validator: emailValidator,
                  editingController: emailEditingController,
                ),
                TextField(
                  title: "Password",
                  description: "Enter your password",
                  icon: Icons.lock_open,
                  validator: passwordValidator,
                  editingController: passwordEditingController,
                ),
                LoginButton(
                  onPressed: login,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? emailValidator(String? email) {
    return email != null && EmailValidator.validate(email)
        ? null
        : "Please enter a valid email";
  }

  String? passwordValidator(String? password) {
    return password != null && password.length >= 8
        ? null
        : "Password must be at least 8 characters";
  }

  login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String email = emailEditingController.text;
    String password = passwordEditingController.text;

    await userService.login(email, password);
  }
}

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            alignment: Alignment.center,
            child: Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.contain,
            ),
            padding: const EdgeInsets.only(left: 100.0, right: 100.0)));
  }
}

class TextField extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final FormFieldValidator<String> validator;
  final TextEditingController editingController;

  const TextField(
      {Key? key,
      required this.title,
      required this.description,
      required this.icon,
      required this.validator,
      required this.editingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 16.0),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 15.0),
                child: Icon(
                  icon,
                  color: Colors.grey,
                ),
              ),
              Container(
                height: 30.0,
                width: 1.0,
                color: Colors.grey.withOpacity(0.5),
                margin: const EdgeInsets.only(left: 00.0, right: 10.0),
              ),
              Expanded(
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: validator,
                  controller: editingController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: description,
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).splashColor;
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 100.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              splashColor: primaryColor,
              color: primaryColor,
              child: Row(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Transform.translate(
                    offset: const Offset(15.0, 0.0),
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0)),
                        splashColor: Colors.white,
                        color: Colors.white,
                        child: Icon(
                          Icons.arrow_forward,
                          color: primaryColor,
                        ),
                        onPressed: () => onPressed(),
                      ),
                    ),
                  )
                ],
              ),
              onPressed: () => onPressed(),
            ),
          ),
        ],
      ),
    );
  }
}
