import 'package:prim_derma_app/models/derma.dart';
import 'package:prim_derma_app/repo/env_variable.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class DermaRepo{
  Future<List<Derma>> getDerma() async{
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
}