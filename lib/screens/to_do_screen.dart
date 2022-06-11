import 'package:AquaFocus/services/database_services.dart';
import 'package:flutter/material.dart';

class ToDoScreen extends StatefulWidget {
  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  bool isComplete = false; //just for now
  TextEditingController todoTitleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('To-Do'),
      ),
      body: Stack(children: <Widget>[
      Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/mainscreen.png'),
            fit: BoxFit.cover,
          ),
        ),
    ),
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: const Text(
                    'All My To-Dos',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
              ),
              const Divider(),
              const SizedBox(height: 15),
              ListView.separated(
                separatorBuilder: (context, index) => Divider(color: Colors.white70),
                shrinkWrap: true,
                  itemCount: 5,
                itemBuilder: (context, index) {
                  return Dismissible(
                      key: Key(index.toString()),
                      background: Container(
                        padding: EdgeInsets.only(left: 20),
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,),
                        color: Colors.red[300],
                      ),
                      onDismissed: (direction) {
                        print('removed'!);
                      },
                      child: ListTile(
                        onTap:(){
                          setState(() {
                            isComplete = !isComplete;
                          });
                          },
                        leading: Container(
                          padding: EdgeInsets.all(2),
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.5),
                              shape: BoxShape.circle
                          ),
                          child: isComplete
                              ? Icon(
                            Icons.check,
                            color: Colors.white,
                          )
                              : Container(),
                        ),
                        title: const Text('To-Do title',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                  );
                },
              )
            ]
          )
        ),
      ),
      ]
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
        onPressed:() {
          showDialog(
              context: context,
              builder: ((context) => SimpleDialog(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 20,
                ),
                backgroundColor: Colors.cyan.withOpacity(0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                  title: Row(
                      children: [
                        const Text('Create a new To-Do!',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () => Navigator.pop(context),
                        )
                      ]
                  ),
                children: [
                  Divider(),
                  TextFormField(
                    controller: todoTitleController,
                    style: const TextStyle(
                        fontSize: 18,
                        height: 1.5,
                        color: Colors.white,
                    ),
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'eg. exercise',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Add'),
                      color: Colors.lightBlue.withOpacity(0.8),
                      textColor: Colors.white,
                      onPressed: () async {
                        if (todoTitleController.text.isNotEmpty) {
                          await DatabaseService().createNewToDo(todoTitleController.text.trim());
                          Navigator.pop(context);
                        }
                      },
                    ),
                  )
                ],
              )
              ),
          );
        },
      ),
    );
  }
}
