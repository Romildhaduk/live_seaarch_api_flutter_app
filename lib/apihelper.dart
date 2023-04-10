import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pixelapi/model.dart';

class APIHelper {
  APIHelper._();
  static final APIHelper apiHelper = APIHelper._();
  String apiKey = "27278777-989ed1f6f6b0aad88a9350844";
  String search = "animal";
  int photoSize = 10;
  int page = 1;

  Future<List<Images>?> fetchImagesData() async {
    try {
      String api =
          "https://pixabay.com/api/?key=$apiKey&q=$search&image_type=photo&per_page=$photoSize&page=$page";

      http.Response res = await http.get(Uri.parse(api));

      Map data = jsonDecode(res.body);

      List allData = data['hits'];

      List<Images> response = allData.map((e) => Images.fromJson(e)).toList();
      print("==========>${response.length}");

      return response;
    } catch (e, s) {
      print(e.toString());
      print(s.toString());
    }
  }
}
