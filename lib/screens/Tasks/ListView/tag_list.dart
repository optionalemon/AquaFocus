import 'package:AquaFocus/screens/Tasks/add_task.dart';
import 'package:flutter/material.dart';

class ListTag extends StatefulWidget {
  const ListTag({Key? key}) : super(key: key);

  @override
  State<ListTag> createState() => _ListTagState();
}

class _ListTagState extends State<ListTag> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Tags'),  
        ),
      body: Stack(
        children:[ Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/mainscreen.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      
    SafeArea(
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(colors: [
              Colors.indigo.withOpacity(0.7),
              Colors.white.withOpacity(0.7)
            ]),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0.0, 5))
            ]),
            child: Column(),
      ),
    ),
    Padding(
      padding:
          EdgeInsets.all(MediaQuery.of(context).size.height * 0.05),
      child: Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton(
              child: Icon(Icons.add, color: Colors.white),
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddEventPage(
                              selectedDate: DateTime.now(),
                              updateTaskDetails: () {},
                            )));
                          })))
    ]));
  }
}