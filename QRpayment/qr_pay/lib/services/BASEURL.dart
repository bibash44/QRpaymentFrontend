import 'package:shared_preferences/shared_preferences.dart';

class BASEURL {
  // String baseurl = 'http://localhost:51235/';
  // String baseurl = 'http://10.0.2.2:51235/';
  String baseurl = 'http://192.168.0.21:51235/';
  // String baseurl = 'https://agendamemphis-remarkkarate-3000.codio-box.uk/';
  // String runFlutterWeb =flutter run -d chrome --web-renderer html --target lib/screens/splash_screen.dart;

  String setBASEURL() {
    return baseurl;
  }

  getUserToken() async {
    SharedPreferences sharedPreferenceUserData =
        await SharedPreferences.getInstance();

    String? token = sharedPreferenceUserData.getString("_token");

    return token;
  }
}
