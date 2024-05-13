import 'dart:convert';
import 'package:http/http.dart' as http;

String token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiIyOWQ0OWE4MS0xYmVmLTQxZGYtOGIxNy04MzM4MmU1YTYzZjQiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTcxNTU1NTIyOCwiZXhwIjoxNzQ3MDkxMjI4fQ.7yAMK85UJL4NO-SV4u-Zw0Cj4oqTfuZ5G6uNcHH512Y";

Future<String> createRoom() async {
  final http.Response httpResponse = await http.post(
    Uri.parse("https://api.videosdk.live/v2/rooms"),
    headers: {'Authorization': token},
  );

  return json.decode(httpResponse.body)['roomId'];
}
