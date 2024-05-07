// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class contactus extends StatefulWidget {
  const contactus({super.key});

  @override
  State<contactus> createState() => _contactusState();
}

final nameController = TextEditingController();
final subjectController = TextEditingController();
final emailController = TextEditingController();
final messageController = TextEditingController();

// Future sendEmail() async{
//   final Url =Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
//   const servicesId = "service_ir3vs4i";
//   const templateId = "";
//   const userId = "";

//   final response = await http.post(Url,
//   headers: {'Contrnt-type':'application/json'},
//   body: json.encode({
//     "service_id":
//   })

//   );
// }

class _contactusState extends State<contactus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contact Us",
          style: TextStyle(color: Colors.orangeAccent),
        ),
        backgroundColor: Colors.white, //shade
        elevation: 0,
      ),
      // backgroundColor: Colors.blueGrey,
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Center(
              child: Image.asset(
            'images/contact_us.png',
            height: 150,
          )),
          const Text(
            "If you need help \n please contact us!",
            style: TextStyle(fontSize: 15, color: Colors.blueGrey),
          ),
          const SizedBox(
            height: 7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 100,
                  width: 150,
                  decoration:
                      const BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 20,
                    ),
                  ]),
                  padding: const EdgeInsets.all(8),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.alternate_email,
                        color: Colors.orange,
                        size: 50,
                      ),
                      Text("Write to Us"),
                      Text("help@gmail.com"),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 100,
                  width: 150,
                  decoration:
                      const BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 20,
                    ),
                  ]),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.help_outline,
                        color: Colors.orange,
                        size: 50,
                      ),
                      Text("FAQs"),
                      Text(
                        "Frequently Asked Questions",
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 100,
                  width: 150,
                  decoration:
                      const BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 20,
                    ),
                  ]),
                  padding: const EdgeInsets.all(8),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.phone,
                        color: Colors.orange,
                        size: 50,
                      ),
                      Text("Phone Number"),
                      Text("+905064066030"),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 100,
                  width: 150,
                  decoration:
                      const BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 20,
                    ),
                  ]),
                  padding: const EdgeInsets.all(8),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.location_city,
                        color: Colors.orange,
                        size: 50,
                      ),
                      Text("Address"),
                      Text("İstanbul"),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Text(
            "Copyright. 2022 Gokdeemir",
            style: TextStyle(color: Colors.blue),
          ),
          const Text(
            "All rights are reserved",
            style: TextStyle(color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
