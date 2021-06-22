import 'dart:convert';
import 'package:http/http.dart';

class Contact{
  String? imageURL;

  Contact();

  Future<void> getURL() async{
    try{
      Response response = await get(Uri.parse("https://fakeface.rest/face/json"));
      Map data = jsonDecode(response.body);

      imageURL = data["image_url"];
      print(data);
    }catch(error){
      print(error);
    }
  }
}