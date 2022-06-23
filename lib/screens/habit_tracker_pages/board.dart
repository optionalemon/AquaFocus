import 'package:AquaFocus/model/habit_tracker_model.dart';
import 'package:AquaFocus/model/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoardPage extends StatefulWidget {
  final Board? board;

  BoardPage(this.board);

  @override
  State<BoardPage> createState() => _BoardPageState(this.board);

}

class _BoardPageState extends State<BoardPage> {
  var controller = TextEditingController();
  var error;

  _BoardPageState(Board? board) {
    controller = TextEditingController(text: board == null ? '' : board.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.board == null ? 'Create a board' : 'Edit ${widget.board?.name}'),
        actions: [
          TextButton(
            child: Text('Save'),
            onPressed: this.error != null ? null : () {
              if (widget.board == null) {
                context
                    .read<HabitBoardCubit>()
                    .addBoard(Board(controller.text, []));
              } else {
                context
                    .read<HabitBoardCubit>()
                    .editBoard(widget.board!, controller.text);
              }
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
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
              //var currentMonth = calendarController.visibleDays.firstWhere((element) => element.day == 1).month;
              return Column(
                children: [
                  TextField(
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.white,
                    ),
                    autofocus: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      isDense: true,
                      labelText: 'Name',
                      errorText: this.error,
                      errorStyle: TextStyle(
                        color: Colors.orangeAccent,
                      ),
                      hintText: 'eg. go for a run once a week!',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                    controller: controller,
                    onChanged: (v) {
                      setState(() {
                        if (state.boards.any((element) => element.name.toLowerCase() == v.toLowerCase() && element != widget.board)) {
                          this.error = 'A board with name ${v} already exists.';
                        } else {
                          this.error = null;
                        }
                      });
                    },
                  ),
                  SizedBox( height: 20.0),

                ],
              );
            }),
        ),
      ]
      ),
    );
  }
}
