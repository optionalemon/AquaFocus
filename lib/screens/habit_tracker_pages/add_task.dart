import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class AddEventPage extends StatefulWidget {
  final DateTime? selectedDate;

  const AddEventPage({Key? key, this.selectedDate}) : super(key: key);

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Add a task'),
        leading: IconButton(
          icon: Icon(Icons.clear, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
         actions: [
           Center(
               child: ElevatedButton(
                 onPressed: () async {
                   bool validated = _formKey.currentState!.validate();
                   print(validated);
                   _formKey.currentState!.save();
                 },
                 child: Text('Save'),
               )
           )
         ]
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
      child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget> [
            FormBuilder(
              key: _formKey,
                child: Column(
              children: [
                FormBuilderTextField(
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  name: 'title',
                  decoration: InputDecoration(
                      filled: true,
                    fillColor: Colors.cyan.withOpacity(0.5),
                    hintText: "Add Title",
                    hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    prefixIcon: Icon(Icons.star_border, color: Colors.white),
                    contentPadding: EdgeInsets.all(20.0),
                  )
                ),
                Divider(),
                FormBuilderTextField(
                  name: 'description',
                  maxLines: 5,
                  minLines: 1,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.cyan.withOpacity(0.5),
                      hintText: "Add Description",
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    prefixIcon: Icon(Icons.short_text, color: Colors.white),
                    contentPadding: EdgeInsets.all(20.0),
                  ),
                ),
                Divider(),
                FormBuilderDateTimePicker(
                  style: TextStyle(color: Colors.white),
                  name: "date",
                  initialValue: widget.selectedDate ?? DateTime.now(),
                  fieldHintText: "Add Date",
                  initialDatePickerMode: DatePickerMode.day,
                  inputType: InputType.date,
                  format: DateFormat('EEEE, dd MMMM, yyyy'),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.cyan.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.calendar_today_sharp, color: Colors.white),
                  ),
                ),
              ]
            ))
          ]
        ),
    )]
    ));
  }
}

