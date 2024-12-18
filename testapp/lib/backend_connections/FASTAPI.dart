import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:testapp/backend_connections/api%20services/checking_one_group_condition.dart';
import 'package:testapp/backend_connections/api%20services/user_registration.dart';
import 'package:testapp/backend_connections/api%20services/user_login_check.dart';


// fastapi ke msg pathacchi
class FASTAPIhere{

  // for user registration
  Future<void> user_register(
      BuildContext context, String name, String email, String pass) async {
    await user_registration(context, name, email, pass);
  }

  // for user login
  Future<bool> login_check(
      BuildContext context, String email, String pass) async {
    return await user_login_check(context, email, pass);
  }

  // for checking at least one group criteria
  Future<bool> check_one_group_criteria(BuildContext context, String email) async {
    return await checking_one_group_condition(context, email);
  }


}