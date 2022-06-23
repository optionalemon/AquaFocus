import 'dart:convert';

import 'package:AquaFocus/model/habit_tracker_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

part 'state.g.dart';

@JsonSerializable()
class HabitBoardState {
  final List<Board> boards;
  final Board? selectedBoard;

  HabitBoardState(this.boards, this.selectedBoard);

  factory HabitBoardState.fromJson(Map<String, dynamic> json) => _$HabitBoardStateFromJson(json);
  Map<String, dynamic> toJson() => _$HabitBoardStateToJson(this);
}

class HabitBoardCubit extends Cubit<HabitBoardState> {
  HabitBoardCubit() : super(HabitBoardState([Board('Board from Bloc', [])], null));

  Future<void> load() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    String appDocPath = appDocDir.path;

    var stateFile = File('$appDocPath/habitboardstate.json');
    var exists = await stateFile.exists();

    if (exists) {
      var stateString = await stateFile.readAsString();
      var state = HabitBoardState.fromJson(jsonDecode(stateString));
      emit(state);
    }
  }

  Future<void> saveState() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    String appDocPath = appDocDir.path;

    var stateFile = File('$appDocPath/habitboardstate.json');
    var stateString = jsonEncode(this.state.toJson());

    stateFile.writeAsString(stateString);

    print('Saved state');
  }

  void addBoard(Board board) => emit(HabitBoardState(this.state.boards..add(board), this.state.selectedBoard));

  void editBoard(Board board, String name) {
    var index = this.state.boards.indexOf(board);
    var editedBoard = Board(name, board.entries);
    this.state.boards[index] = editedBoard;
    emit(HabitBoardState(
        this.state.boards, this.state.selectedBoard == board ? editedBoard : this.state.selectedBoard));
  }

  void toggleDate(Board? board, DateTime date) {
    board!.toggle(date);
    emit(HabitBoardState(this.state.boards, this.state.selectedBoard));
  }

  void selectBoard(Board board) {
    emit(HabitBoardState(this.state.boards, board));
  }
}
