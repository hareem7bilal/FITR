import 'dart:convert';
import 'package:http/http.dart' as http;

String token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiIyZDllMzNjNy04OTUzLTQ4OWItODA3ZC03YjZlNWI4ZWVjZDYiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTcxNTQ0NzE5MSwiZXhwIjoxNzE1NTMzNTkxfQ.F9_lHIo4afj-fEuHaS-xqE7UIGKAJ2LYDUd5CMhqiww";

Future<String> createRoom() async {
  final http.Response httpResponse = await http.post(
    Uri.parse("https://api.videosdk.live/v2/rooms"),
    headers: {'Authorization': token},
  );

  return json.decode(httpResponse.body)['roomId'];
}
