import 'package:flutter/material.dart';
import 'package:prim_derma_app/models/derma.dart';
import 'package:prim_derma_app/repo/env_variable.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class DermaRepo {
  Future<List<Derma>> getDerma() async {
    try {
      var url = '$PRIM_URL/getDerma';
      var uri = Uri.parse(url);

      var response = await http.get(
        uri,
        headers: {'token': '123'},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var list = Derma.processDermaList(data);
        return list;
      } else {
        return [];
      }
    } catch (e) {
      //print("Error: $e");
      return [];
    }
  }

  // https://prim.my/api/auth-handoff/getHandoffToken

  static Future<String> getHandoffToken(
      {required String userToken,
      required String donationId,
      String desc = "Derma Tanpa Name"}) async {
    try {
      final url = "$PRIM_API_AUTH_HANDOFF_TOKEN_URL/getHandoffToken";
      final uri = Uri.parse(url);

      final response = await http.post(uri, body: {
        "user_token": userToken,
        "donation_id": donationId,
        "desc": desc
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["token"];
      } else {
        return "";
      }
    } catch (e) {
      debugPrint("Auth HandOff Error: $e");
      return "";
    }
  }
}
