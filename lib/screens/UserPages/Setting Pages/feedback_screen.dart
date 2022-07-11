import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:flutter/material.dart';

class feedbackScreen extends StatefulWidget {
  const feedbackScreen({Key? key}) : super(key: key);

  @override
  State<feedbackScreen> createState() => _feedbackScreenState();
}

class _feedbackScreenState extends State<feedbackScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final feedbackController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey();

    @override
    void dispose() {
      // Clean up the controller when the widget is disposed.
      feedbackController.dispose();
      super.dispose();
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("Feedback Channel"),
          backgroundColor: Color.fromARGB(40, 0, 0, 0),
        ),
        body: Stack(children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
              child: Container(
            padding: EdgeInsets.all(size.height * 0.01),
            child: Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(colors: [
                      Colors.blue.withOpacity(0.5),
                      Colors.white.withOpacity(0.5)
                    ]),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0.0, 5))
                    ]),
                child: Column(
                    children: [
                  ListTile(
                    contentPadding: EdgeInsets.all(size.height * 0.02),
                    leading: Icon(
                      Icons.feedback_outlined,
                      size: size.height * 0.03,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Your opinion is important to us. This way we can keep improving our app. Please let us know if you have any feedback.",
                      style: TextStyle(
                          fontSize: size.height * 0.02,
                          color: Colors.white),
                    ),
                  ),
                  const Divider(
                    color: Colors.white70,
                    indent: 10,
                    endIndent: 10,
                  ),
                  SizedBox(height: size.height * 0.01),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(size.height * 0.02),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: feedbackController,
                            maxLines: null,
                            autofocus: true,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                                hintText: 'Your feedback is greatly appreciated. :)',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                              )
                            ),
                            //textInputAction: TextInputAction.done,
                            validator: (String? text) {
                              if (text == null || text.isEmpty) {
                                return "Feedback is empty! Please enter your feedback.";
                              }
                              return null;
                            },
                            onChanged: (text) {
                              // do something with text
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue.withOpacity(0.5),
                              fixedSize: Size(size.width*0.8, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                          onPressed: () async {
                            if(_formKey.currentState!.validate()) {
                              String message;
                              try {
                                final feedbackCollection = FirebaseFirestore.instance.collection('feedback');

                                await feedbackCollection.doc().set(
                                  {
                                    'timestamp': FieldValue.serverTimestamp(),
                                    'feedback': feedbackController.text,
                                  }
                                );
                                message = 'Feedback submitted successfully';
                              } catch (_) {
                                message = 'Error when sending feedback';
                              }
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                              Navigator.pop(context);
                            }
                        },
                          child: const Text(
                            'Submit Feedback Form',
                            style: TextStyle(
                                color: Colors.white),
                          )
                      ),
                    ],
                  )
                ]
                )
            ),
          )
          )
        ]
        )
    );
  }
}
