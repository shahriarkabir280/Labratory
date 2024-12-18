import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:testapp/backend_connections/api%20services/all_groups_info.dart';
import 'package:testapp/backend_connections/api%20services/checking_one_group_condition.dart';
import 'package:testapp/backend_connections/api%20services/user_join_group.dart';
import 'package:testapp/backend_connections/api%20services/user_registration.dart';
import 'package:testapp/backend_connections/api%20services/user_login_check.dart';
import 'package:testapp/backend_connections/api%20services/user_create_group.dart';


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

  // for creating a group
  Future<void> group_create(
      BuildContext context,String email, String newgroup , String groupcode) async {
      await user_group_create(context, email, newgroup, groupcode);
  }

  // for checking at least one group criteria
  Future<bool> check_one_group_criteria(BuildContext context, String email) async {
    return await checking_one_group_condition(context, email);
  }

  // all groups record
  Future<void> all_groups(
      BuildContext context,String g_name, String g_pass) async {
      await all_groups_info(context, g_name, g_pass);
  }

  // for joining group
  Future<String> find_group(BuildContext context, String groupCode) async {
    return await finding_group(context, groupCode);
  }
}