import 'package:AquaFocus/model/app_task.dart';
import 'package:AquaFocus/model/tag_colors.dart';
import 'package:AquaFocus/model/tags.dart';
import 'package:AquaFocus/widgets/loading.dart';
import 'package:AquaFocus/widgets/reusable_widget.dart';
import 'package:AquaFocus/services/task_firestore_service.dart';
import 'package:AquaFocus/services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:AquaFocus/screens/signin_screen.dart';
import 'package:uuid/uuid.dart';

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
  late List tags;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    isTimeSetted = widget.task?.hasTime ?? false;
    getTags();
  }

  getTags() async {
    tags = await DatabaseServices().getUserTags();
    setState(() {
      loading = false;
    });
  }

  bool dupTags(String newTitle) {
    for (Tags tag in tags) {
      if (newTitle == tag.title) {
        return true;
      }
    }
    return false;
  }

  List<FormBuilderChipOption> getOptions() {
    List<FormBuilderChipOption> lst = [];
    Color realColor = Colors.black;
    for (Tags tag in tags) {
      for (TagColors color in tagColors) {
        if (tag.color == color.title) {
          realColor = color.color;
          break;
        }
      }
      lst.add(FormBuilderChipOption(
          value: tag.title,
          child: Text(tag.title, style: TextStyle(color: realColor,fontWeight: FontWeight.bold))));
    }
    return lst;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return loading
        ? const Loading()
        : Scaffold(
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
                        prefixIcon:
                        Icon(Icons.short_text, color: Colors.white),
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
                      initialValue:
                      widget.task?.time ?? DateTime.now(),
                    ),
                    !isTimeSetted ? Container() : Divider(),
                    !isTimeSetted
                        ? Container()
                        : FormBuilderDropdown(
                      initialValue: widget.task?.reminder ?? "never",
                      dropdownColor:
                      Color.fromARGB(119, 100, 180, 255),
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
                        prefixIcon: Icon(Icons.access_alarm,
                            color: Colors.white),
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
                          value: "ontime",
                          child: Text(
                            'On Time',
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
                        prefixIcon: Icon(Icons.event_repeat_outlined,
                            color: Colors.white),
                        filled: true,
                        fillColor: Colors.cyan.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
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
                    FormBuilderChoiceChip(
                      name: 'tag',
                      spacing: size.width * 0.01,
                      backgroundColor: Colors.grey,
                      selectedColor:Color.fromARGB(54, 255, 255, 255),
                      decoration: InputDecoration(
                        labelText: 'Tags',
                        labelStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.cyan.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.tag, color: Colors.white),
                      ),
                      options: getOptions(),
                    ),
                    TextButton(
                        onPressed: () => newTag(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text(
                              "Add tag",
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ))
                  ])),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              firebaseButton(context, "Save", () async {
                bool validated = _formKey.currentState!.validate();
                if (validated) {
                  _formKey.currentState!.save();
                  final data = Map<String, dynamic>.from(
                      _formKey.currentState!.value);
                  data['date'] =
                      (data['date'] as DateTime).millisecondsSinceEpoch;
                  if (data['hasTime']) {
                    data['time'] =
                        (data['time'] as DateTime).millisecondsSinceEpoch;
                  }
                  if (widget.task == null) {
                    data['userId'] = user!.uid;
                    data['id'] = Uuid().v1();
                    data['isCompleted'] = false;
                    await taskDBS.create(data);
                    widget.updateTaskDetails();
                  } else {
                    //edit and update
                    if (!data['hasTime']) {
                      data['time'] = null;
                      data['reminder'] = 'never';
                    }
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

  newTag() {
    Size size = MediaQuery.of(context).size;
    String color = '';
    TextEditingController _tagController = TextEditingController();
    final _tagFormKey = GlobalKey<FormState>();
    Widget cancelButton = TextButton(
      child: const Text("Cancel", style: TextStyle(color: Colors.blue)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget doneButton = TextButton(
        onPressed: () async {
          if (_tagFormKey.currentState!.validate()) {
            _tagFormKey.currentState!.save();
            Tags newTag = Tags(title: _tagController.text, color: color);
            await DatabaseServices().addTags(newTag);
            setState(() {
              tags.add(newTag);
            });
            Navigator.of(context).pop();
          }
        },
        child: const Text("Done",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)));

    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: const Text("New Tag"),
      content: Form(
        key: _tagFormKey,
        child: Wrap(children: [
          TextFormField(
              controller: _tagController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Tag name cannot be empty";
                } else if (dupTags(value)) {
                  return "Tag name duplicated";
                }
                return null;
              },
              onChanged: ((_) {
                setState(() {});
              }),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.cyan.withOpacity(0.5),
                labelText: 'Tag Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              )),
          Divider(),
          SizedBox(height: 40),
          FormBuilderChoiceChip<String>(
              onSaved: (value) {
                color = value!;
              },
              decoration: InputDecoration(
                labelText: 'Select a color',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              name: "tagColor",
              validator: FormBuilderValidators.compose(
                  [FormBuilderValidators.required()]),
              backgroundColor: Colors.white,
              selectedColor: Color.fromARGB(255, 222, 222, 222),
              options: [
                FormBuilderChipOption(
                    value: 'red', child: colorCircle(Color(0xffF8A3A8))),
                FormBuilderChipOption(
                    value: 'orange', child: colorCircle(Color(0xffF3C6A5))),
                FormBuilderChipOption(
                    value: 'yellow', child: colorCircle(Color(0xffE5E1AB))),
                FormBuilderChipOption(
                    value: 'green', child: colorCircle(Color(0xff9CDCAA))),
                FormBuilderChipOption(
                  value: 'blue',
                  child: colorCircle(Color(0xff96CAF7)),
                ),
                FormBuilderChipOption(
                    value: 'purple', child: colorCircle(Color(0xffBFB2F3))),
              ]),
          Divider(),
        ]),
      ),
      actions: [
        cancelButton,
        doneButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  colorCircle(Color color) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.05,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
