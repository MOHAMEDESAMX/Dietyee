



import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../Core/utils/Colors.dart';


class contactus extends StatefulWidget {
  const contactus({super.key});

  @override
  State<contactus> createState() => _contactusState();
}

final nameController = TextEditingController();
final subjectController = TextEditingController();
final emailController = TextEditingController();
final messageController = TextEditingController();

Future sendEmail() async{
  final Url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
  const serviceId="service_ir3vs4i";
  const templateId="template_iusazdn";
  const userId="byhX7VWORhRavq-p1";

  log("enteres response");
  final response = await http.post(Url,
  headers: {
    'origin': 'http:localhost',
    'Content-Type': 'application/json'},
  body: json.encode({
    "service_id": serviceId,
    "template_id": templateId,
    "user_id": userId,
    "template_params":{
      "name":nameController.text,
      "Subject": subjectController.text,
      "message": messageController.text,
      "user_email":emailController.text,
    }
  })
  );
  log(response.body);
  return response.statusCode;

}

class _contactusState extends State<contactus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contact Us",
          style: TextStyle(color: Colors.orangeAccent),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
        onPressed: () {
          //Navigator.of(context).pop();
        },
        icon: Icon(
          Icons.arrow_back,
          size: 33,
          color: AppColors.button,
        ),
      ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            const Text(
              "If you need help \n please contact us!",
              style: TextStyle(fontSize: 15, color: Colors.blueGrey),
            ),
            const SizedBox(
              height: 7,
            ),
            // TextFields to capture user input
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Your Name'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: subjectController,
              decoration: const InputDecoration(labelText: 'Subject'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Your Email'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: messageController,
              decoration: const InputDecoration(labelText: 'Message'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                sendEmail();
                ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "email sent",
                              ),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.green,
                            ));
              },
              child: const Text("Send"),
            ),
          ],
        ),
      ),
    );
  }
}




/*
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../Core/utils/Colors.dart';

class contactus extends StatefulWidget {
  const contactus({super.key});

  @override
  State<contactus> createState() => _contactusState();
}

final nameController = TextEditingController();
final subjectController = TextEditingController();
final emailController = TextEditingController();
final messageController = TextEditingController();

Future<int> sendEmail() async {
  final Url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
  const serviceId = "service_ir3vs4i";
  const templateId = "template_iusazdn";
  const userId = "byhX7VWORhRavq-p1";

  log("enteres response");
  final response = await http.post(Url,
      headers: {
        'origin': 'http:localhost',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        "service_id": serviceId,
        "template_id": templateId,
        "user_id": userId,
        "template_params": {
          "name": nameController.text,
          "Subject": subjectController.text,
          "message": messageController.text,
          "user_email": emailController.text,
        }
      }));
  log(response.body);
  return response.statusCode;
}

class _contactusState extends State<contactus> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contact Us",
          style: TextStyle(color: Colors.orangeAccent),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            //Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            size: 33,
            color: AppColors.button,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              const Text(
                "If you need help \n please contact us!",
                style: TextStyle(fontSize: 15, color: Colors.blueGrey),
              ),
              const SizedBox(
                height: 7,
              ),
              // TextFields to capture user input
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Your Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: subjectController,
                decoration: const InputDecoration(labelText: 'Subject'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the subject';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Your Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: messageController,
                decoration: const InputDecoration(labelText: 'Message'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    sendEmail().then((statusCode) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          statusCode == 200 ? "Email sent" : "Email failed",
                        ),
                        duration: Duration(seconds: 2),
                        backgroundColor:
                            statusCode == 200 ? Colors.green : Colors.red,
                      ));
                    });
                  }
                },
                child: const Text("Send"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


 */