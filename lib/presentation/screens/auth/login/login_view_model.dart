import 'package:auto_route/auto_route.dart';
import 'package:bogging_app/data/repositories/repository.dart';
import 'package:bogging_app/presentation/router/router_import.gr.dart';
import 'package:flutter/cupertino.dart';

class LoginViewModel{
  final Repository repository;
  LoginViewModel({required this.repository});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();


  login(context) async {

    var loginData = await repository.authRepo
        .userLogin(emailController.text, passwordController.text, context);
    if (loginData.accessToken != null) {
      AutoRouter.of(context).push(const GeneralPageRoute());
    }

  }
}