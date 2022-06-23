import 'dart:convert';

import 'package:AquaFocus/model/habit_tracker_model.dart';
import 'package:AquaFocus/model/state.dart';
import 'package:AquaFocus/screens/habit_tracker_pages/board.dart';
import 'package:AquaFocus/screens/habit_tracker_pages/view_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HabitTrackerScreen extends StatelessWidget {
  final String title;

  HabitTrackerScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(title),
        actions: [
          //TextButton(
           //   onPressed: () async {
            //    context.read<HabitBoardCubit>().saveState();
            //  },
           //   child: Text('Test JSON')),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BoardPage(null)));
              },
          ),
        ],
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
        SafeArea(child: BlocBuilder<HabitBoardCubit, HabitBoardState>(
          builder: (context, state) {
            return ListView.builder(
                itemCount: state.boards.length,
                itemBuilder: (context, index) =>
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      color: Colors.blue[200]?.withOpacity(0.5),
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(state.boards[index].name,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            )
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.auto_graph,
                            color:
                            state.boards[index].isDateChecked(DateTime.now())
                                ? Colors.lightGreenAccent : Colors.grey,
                          ),
                          onPressed: () {
                            context.read<HabitBoardCubit>().toggleDate(state.boards[index], DateTime.now());
                          },
                        ),
                        onTap: () {
                          context.read<HabitBoardCubit>().selectBoard(state.boards[index]);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ViewBoardPage()));
                          print('Board ${state.boards[index].name} was tapped');
                        }
                      ),
                    )
            );
          }),
        ),
      ]
      ),
    );
  }
}
