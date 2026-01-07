import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();

  String aiResponse = ""; // renamed to avoid conflict

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(100),
          ),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
          "Home",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 30),
          child: Column(
            children: [
              TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "What is in your mind?",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (searchController.text.isNotEmpty) {
                      getResponse();
                    }
                  },
                  child: const Text("Search"),
                ),
              ),
              const SizedBox(height: 30),
              GptMarkdown(
                  aiResponse,
                  style: const TextStyle(fontSize: 18),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getResponse() async {
    const String apiKey = "AIzaSyCzCen9jBJq089I5vQ4xHRvVRAed0z83Vw";
    final String url =
         "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey";
    final Map<String, dynamic> bodyParams = {
      "contents": [
        {
          "parts": [
            {"text": searchController.text}
          ]
        }
      ]
    };

    try {
      final http.Response httpResponse = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyParams),
      );

      if (httpResponse.statusCode == 200) {
        final data = jsonDecode(httpResponse.body);

        setState(() {
          aiResponse =
          data["candidates"][0]["content"]["parts"][0]["text"];
        });
      } else {
        debugPrint("Error: ${httpResponse.statusCode}");
      }
    } catch (e) {
      debugPrint("Exception: $e");
    }
  }
}



//
//
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class Home extends StatefulWidget {
//
//   Home({super.key});
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   TextEditingController searchController = TextEditingController();
//
//   String response = "";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),
//         ),
//         backgroundColor: Colors.deepPurple,
//         centerTitle: true,
//         title: Text(
//           "Home",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 30,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 labelText: "Search",
//                 hintText: "What is in your mind?",
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//             ),
//             SizedBox(height: 15),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                   onPressed: () {
//                     if(searchController.text.isNotEmpty){
//                       getResponse();
//                     }
//                   }, child: Text("Search")),
//             ),
//             SizedBox(height: 30),
//             Text(response, style: TextStyle(fontSize: 20),)
//           ],
//         ),
//       ),
//     );
//   }
//
//  Future<void>  getResponse () async {
//
//     const String apiKey = "AIzaSyCzCen9jBJq089I5vQ4xHRvVRAed0z83Vw";
//     final String url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey";
//
//     final Map<String, dynamic> bodyParms = {
//       "contents": [
//         {
//           "parts": [
//             {
//               "text": searchController.text
//             }
//           ]
//         }
//       ]
//
//     };
//      var response = await http.post(Uri.parse(url),
//         body: jsonEncode(bodyParms));
//      if(response.statusCode == 200){
//        var data  = jsonDecode(response.body);
//        response = data["candidates"][0]["contents"]["parts"][0]["text"];
//        setState(() {
//
//        });
//        print(response.body);
//      }else{
//        print(response.statusCode);
//      }
//
//   }
// }
