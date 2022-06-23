import 'package:AquaFocus/loading.dart';
import 'package:AquaFocus/model/todo.dart';
import 'package:AquaFocus/services/database_services.dart';
import 'package:flutter/material.dart';

import '../screens/to_do_screen.dart';

class ToDo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: [
        Container(
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                child: const Icon(
                  Icons.add_task,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(
                  width: 15
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('My To-Do',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )
                    ),
                    SizedBox(height: 10),
                    Text(' \n1. Orbital mission control\n \n2. Technical Interview Workshop\n \n3. Go for a run',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ))
                  ]
              )
            ],
          ),
        ),
        Positioned(
            bottom: 15,
            right: 9,
            child: ElevatedButton(
              onPressed: () { Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ToDoScreen())
              );
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.blue.withOpacity(0.5),
                  onPrimary: Colors.white,
                  shadowColor: Colors.blueAccent,
                  elevation: 3,
                  padding: EdgeInsets.all(15),
                  shape: CircleBorder()),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20,
              ),
            )
        ),
      ],
      ),
    );
  }
}

/*
class ToDo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CreateToDo>>(
      stream: DatabaseService().listToDos(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loading();
        }
        List<CreateToDo>? todos = snapshot.data;
        return Container(
          child: Stack(children: [
          Container(
            height: 20,
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20)
            ),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                      child: const Icon(
                        Icons.add_task,
                        color: Colors.white,
                        size: 30,
                      ),
                  ),
                  const SizedBox(
                    width: 15
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: todos!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                              todos[index].title!,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                    },
                  )
                ],
            ),
          ),
             Positioned(
                  bottom: 15,
                  right: 9,
                 child: ElevatedButton(
                  onPressed: () { Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ToDoScreen())
                  );
                    },
                   style: ElevatedButton.styleFrom(
                     primary: Colors.blue.withOpacity(0.5),
                     onPrimary: Colors.white,
                     shadowColor: Colors.blueAccent,
                     elevation: 3,
                     padding: EdgeInsets.all(15),
                     shape: CircleBorder()),
                     child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                       size: 20,
                        ),
                  )
            ),
        ],
            ),
        );
      }
    );
  }
}
*/
