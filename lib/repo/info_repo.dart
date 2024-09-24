import 'dart:convert';

import 'package:prim_derma_app/models/donation_streak.dart';
import 'package:prim_derma_app/repo/env_variable.dart';
import 'package:http/http.dart' as http;

class InfoRepo {
  Future<String?> getDermaInfo(String token) async {
    try {
      var url = '$PRIM_URL/getDermaInfo';
      var uri = Uri.parse(url);

      Map<String, dynamic> data = {
        'token': token,
      };

      var response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

       

        var code = data['code'];
        if(code == null){
           return null;
        }

        var prim_medal = data['data']['donation_streak'];
        var sedekah_subuh = data['data']['sedekah_subuh'];
        DonationStreak.primMedal = DonationStreak.fromJson(prim_medal, 'Prim Medal', data['data']['prim_medal_days']);
        DonationStreak.sedekahSubuh =DonationStreak.fromJson(sedekah_subuh, 'Sedekah Subuh', data['data']['prim_medal_days']);
        DonationStreak.donationToday =data['data']['donation_today'] as int;
        DonationStreak.prim_point = double.parse(data['data']['prim_point']??0);

        return data['code'];
        //return (User.fromJson(data) , 'Login Successfully');
      } else {
        return null;
      }
    } catch (e) {
      //print("Error: $e");
      return null;
    }
  }
}
