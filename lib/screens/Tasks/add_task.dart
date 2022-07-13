import 'package:AquaFocus/model/app_task.dart';
import 'package:AquaFocus/reusable_widgets/reusable_widget.dart';
import 'package:AquaFocus/screens/Tasks/task_screen.dart';
import 'package:AquaFocus/services/task_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:AquaFocus/screens/signin_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:AquaFocus/screens/Tasks/task_details.dart';

class AddEventPage extends StatefulWidget {
  final DateTime? selectedDate;
  final AppTask? task;
  final Function updateTaskDetails;

  const AddEventPage(
      {Key? key, this.selectedDate, this.task, required this.updateTaskDetails})
      : super(key: key);

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  late bool isTimeSetted;

  @override
  void initState() {
    isTimeSetted = widget.task?.hasTime ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text('Add a task'),
            leading: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
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
            child: ListView(padding: const EdgeInsets.all(16.0), children: <
                Widget>[
              FormBuilder(
                  key: _formKey,
                  child: Column(children: [
                    FormBuilderTextField(
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        name: 'title',
                        initialValue: widget.task?.title,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Title",
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.cyan.withOpacity(0.5),
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon:
                              Icon(Icons.star_border, color: Colors.white),
                          contentPadding: EdgeInsets.all(20.0),
                        )),
                    Divider(),
                    FormBuilderTextField(
                      name: 'description',
                      initialValue: widget.task?.description,
                      style: TextStyle(color: Colors.white),
                      maxLines: 5,
                      minLines: 1,
                      decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.cyan.withOpacity(0.5),
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.short_text, color: Colors.white),
                        contentPadding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.025),
                      ),
                    ),
                    Divider(),
                    FormBuilderDateTimePicker(
                      style: TextStyle(color: Colors.white),
                      name: "date",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      initialValue: widget.selectedDate ?? DateTime.now(),
                      initialDatePickerMode: DatePickerMode.day,
                      inputType: InputType.date,
                      format: DateFormat('EEEE, dd MMMM, yyyy'),
                      decoration: InputDecoration(
                        labelText: "Date",
                        labelStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.cyan.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.calendar_today_sharp,
                            color: Colors.white),
                      ),
                    ),
                    Divider(),
                    FormBuilderSwitch(
                      name: 'hasTime',
                      initialValue: isTimeSetted,
                      title: Text(
                        "Time",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      activeColor: Colors.white,
                      activeTrackColor: Colors.lightGreen,
                      inactiveTrackColor: Colors.grey,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.cyan.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon:
                            Icon(Icons.access_time, color: Colors.white),
                      ),
                      onChanged: (initialValue) {
                        setState(() {
                          isTimeSetted = !isTimeSetted;
                        });
                      },
                    ),
                    Divider(),
                    !isTimeSetted
                        ? Container()
                        : FormBuilderDateTimePicker(
                            style: TextStyle(color: Colors.white),
                            name: "time",
                            // onChanged: _onChanged,
                            inputType: InputType.time,
                            decoration: InputDecoration(
                              //labelText: 'Time',
                              //labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.cyan.withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            initialValue: widget.task?.time ?? DateTime.now(),
                          ),
                    !isTimeSetted ? Container() : Divider(),
                    !isTimeSetted
                        ? Container()
                        : FormBuilderDropdown(
                            initialValue: widget.task?.reminder ?? "never",
                            dropdownColor: Color.fromARGB(119, 100, 180, 255),
                            borderRadius: BorderRadius.circular(20.0),
                            decoration: InputDecoration(
                              labelText: 'Reminder',
                              labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.cyan.withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon:
                                  Icon(Icons.access_alarm, color: Colors.white),
                            ),
                            name: "reminder",
                            items: const [
                              DropdownMenuItem(
                                value: "never",
                                child: const Text(
                                  'Never',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DropdownMenuItem(
                                value: "5min",
                                child: Text(
                                  '5 Minutes early',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DropdownMenuItem(
                                value: "10min",
                                child: Text(
                                  '10 Minutes early',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DropdownMenuItem(
                                value: "15min",
                                child: Text(
                                  '15 Minutes early',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                    !isTimeSetted ? Container() : Divider(),
                    FormBuilderDropdown(
                      initialValue: widget.task?.repeat ?? "never",
                      dropdownColor: Color.fromARGB(119, 100, 180, 255),
                      borderRadius: BorderRadius.circular(20.0),
                      decoration: InputDecoration(
                        labelText: 'Repeat',
                        labelStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.cyan.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.event_repeat_outlined,
                            color: Colors.white),
                      ),
                      name: "repeat",
                      items: const [
                        DropdownMenuItem(
                          value: "never",
                          child: Text(
                            'Never',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "daily",
                          child: Text(
                            'Daily',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "weekdays",
                          child: Text(
                            'Weekdays',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "weekends",
                          child: Text(
                            'Weekends',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "weekly",
                          child: Text(
                            'Weekly',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "monthly",
                          child: Text(
                            'Monthly',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                  ])),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              firebaseButton(context, "Save", () async {
                bool validated = _formKey.currentState!.validate();
                if (validated) {
                  _formKey.currentState!.save();
                  final data =
                      Map<String, dynamic>.from(_formKey.currentState!.value);
                  data['date'] =
                      (data['date'] as DateTime).millisecondsSinceEpoch;
                  if (data['time'] != null) {
                    data['time'] =
                        (data['time'] as DateTime).millisecondsSinceEpoch;
                  }
                  if (widget.task == null) {
                    data['userId'] = user!.uid;
                    data['id'] = Uuid().v1();
                    data['isCompleted'] = false;
                    await taskDBS.create(data);
                  } else {
                    //edit and update
                    await taskDBS.updateData(widget.task!.id, data);
                    widget.updateTaskDetails();
                  }

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Submitted')),
                  );
                }
              }),
            ]),
          )
        ]));
  }
}
