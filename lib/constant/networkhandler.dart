import 'package:http/http.dart' as http;
class networkhandler {
  static final client = http.Client();

  static Uri buildUrl(String endpoint){
    String host = "https://hsmart.onrender.com/api/";
    final apipath = host + endpoint;
    
    return Uri.parse(apipath);
  }
}