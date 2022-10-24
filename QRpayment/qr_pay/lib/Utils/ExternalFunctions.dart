import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class ExternalFunctions {
  var uuid = const Uuid();
  String _sessionToken = "326412";
  List placesList = [];

  Future getPlacesSuggestionAPI(String query) async {
    _sessionToken = uuid.v4();

    String placeApiKey = "AIzaSyB2Q4az6sbEyA5MZuqKlnoMw_2ZwkSJ_GY";
    String baseUrl =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    String request =
        '$baseUrl?input=$query&key=$placeApiKey&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      placesList = jsonDecode(response.body.toString())["predictions"];
      return placesList;
    } else {
      throw Exception("Failed to load places");
    }
  }
}
