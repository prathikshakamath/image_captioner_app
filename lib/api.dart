import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String uploadUrl = "http://192.168.1.8:5000/caption";
String downloadUrl = "http://192.168.1.8:5000/result";
const uri = "http://192.168.1.8:5000/caption";
Future getData(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  print(Uri.parse(url));
  return jsonDecode(response.body);
}


Future<String> uploadImage(String imagepath,String url) async
{ 
    String base64Image=base64Encode(File(imagepath).readAsBytesSync());
    Response response= await Dio().post(url,data:base64Image);
    print(response);
    return getCaption(imagepath, url);
}

Future<String> getCaption(String imagepath, String url) async {
  //  var url = 'http://192.168.1.8:5000/caption';
  try{
    var request = http.MultipartRequest('POST', Uri.parse(uri));
    request.files.add(await http.MultipartFile.fromPath(
      'imagepath', imagepath // Replace with the field name expected by your API
      
    ));
     var response = await request.send();

    if (response.statusCode == 200) {
      // Request successful
      print('Image uploaded successfully');
      // Read the response if needed
      var responseBody = await response.stream.bytesToString();
      return responseBody;
    } else {
      // Request failed
      print('Failed to send request. Status code: ${response.statusCode}');
    }
  } catch(error){
    print('$error');
  }
  
  return ""; // Return an empty string as default
}



Future<String> getAnswer(String caption, String question) async {
  const uri = 'http://192.168.1.8:8000/predict'; 
  var headers = {
      'Content-Type': 'application/json'
      
    };// Replace with your actual Flask app URL

   var body = {
      'document': "My name is prateek",
      'question': question,
    };
  // var response = await http.post(
  //   Uri.parse(uri),
  //   headers: headers,
  //   body: {'document': caption, 'question': question},
  // );
  var response = await http.post(
      Uri.parse(uri),
      headers: headers,
      body: json.encode(body),
    );

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    var answer = jsonResponse['result']['answer'];
    return answer;
  } else {
    // Handle error case
    return 'Error occurred';
  }
}

