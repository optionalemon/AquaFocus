import 'package:AquaFocus/model/app_task.dart';
import 'package:AquaFocus/model/tag_colors.dart';
import 'package:AquaFocus/model/tags.dart';
import 'package:AquaFocus/screens/Tasks/add_task.dart';
import 'package:AquaFocus/screens/Tasks/task_details.dart';
import 'package:AquaFocus/screens/Tasks/task_utils.dart';
import 'package:AquaFocus/services/database_services.dart';
import 'package:AquaFocus/services/task_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListTag extends StatefulWidget {
  ListTag(
      {Key? key,
      required this.showCompleted,
      required this.updateHomeMoney,
      required this.eventList,
      required this.eventTagList,
      required this.getMainPageEvents,
      required this.tags})
      : super(key: key);
  final bool showCompleted;
  final updateHomeMoney;
  final getMainPageEvents;
  List<AppTask> eventTagList;
  List<AppTask> eventList;
  List tags;

  @override
  State<ListTag> createState() => _ListTagState();
}

class _ListTagState extends State<ListTag> {
  int selectedIndex = 0;
  late List<AppTask> selectedEvents;
  bool addTaskMode = true;

  @override
  void initState() {
    super.initState();
    selectedEvents = widget.eventTagList;
  }

  ifEventCompleted(AppTask event, int index, Tags currTag) async {
    if (!event.isCompleted) {
      setState(() {
        selectedEvents[index].isCompleted = !event.isCompleted;
      });
      if (!widget.showCompleted && event.repeat == "never") {
        await Future.delayed(Duration(milliseconds: 400));
        setState(() {
          selectedEvents.remove(selectedEvents[index]);
        });
      }
      await processCompletion(event, widget.updateHomeMoney, context);
      _updateTask(currTag);
      
    }
  }

  _updateTask(Tags currTag) async {
    widget.eventTagList = [];
    widget.eventList = await getEventList(widget.showCompleted);
    for (AppTask event in widget.eventList) {
      if (event.tag != null) {
        widget.eventTagList.add(event);
      }
    }
    widget.getMainPageEvents(); //update Main List Page for delete and add
    selectedEvents = getMatchyEvent(currTag, widget.eventTagList);
    widget.tags = await DatabaseServices().getUserTags();
    widget.tags.insert(0, Tags(title: "All", color: "default"));
    setState(() {});
  }

  _onDelete(AppTask event, Tags currTag) async {
    selectedEvents.remove(event);
    await taskDBS.removeItem(event.id);
    await removeNotification(event);
    _updateTask(currTag);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Task ${event.title} deleted')));
  }

  _getTagColor(Tags tag) {
    for (TagColors tagColor in tagColors) {
      if (tag.color == tagColor.title) {
        return tagColor.color;
      }
    }
  }

  List<AppTask> getMatchyEvent(Tags tag, eventTagList) {
    List<AppTask> matchyEvents = [];
    if (tag.title == 'All') {
      return eventTagList;
    }
    for (AppTask task in eventTagList) {
      if (task.tag == tag.title) {
        matchyEvents.add(task);
      }
    }
    return matchyEvents;
  }

  _buildTags(Tags tag, int index) {
    return Row(
      children: [
        LongPressDraggable(
          data: tag,
          onDragStarted: () {
            setState(() {
              addTaskMode = false;
            });
          },
          onDraggableCanceled: (_, __) {
            setState(() {
              addTaskMode = true;
            });
          },
          onDragEnd: (_) {
            setState(() {
              addTaskMode = true;
            });
          },
          feedback: Card(
            elevation: 0,
            color: Colors.transparent,
            child: ChoiceChip(
              backgroundColor: Colors.white,
              label: Text(
                tag.title,
                style: selectedIndex == index
                    ? TextStyle(color: Colors.white)
                    : TextStyle(color: _getTagColor(tag)),
              ),
              selected: selectedIndex == index,
            ),
          ),
          child: Row(
            children: [
              ChoiceChip(
                backgroundColor: Colors.white,
                selectedColor: _getTagColor(tag),
                label: Text(
                  tag.title,
                  style: selectedIndex == index
                      ? TextStyle(color: Colors.white)
                      : TextStyle(color: _getTagColor(tag)),
                ),
                selected: selectedIndex == index,
                onSelected: (bool selected) {
                  setState(() {
                    selectedIndex = index;
                    selectedEvents = getMatchyEvent(
                        widget.tags[selectedIndex], widget.eventTagList);
                  });
                },
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: SizedBox(
              height: size.height * 0.1,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.tags.length,
                  itemBuilder: (BuildContext context, int index) {
                    Tags tag = widget.tags[index];
                    return _buildTags(tag, index);
                  }),
            )),
        body: Stack(children: [
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
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
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
              child: Scrollbar(
                child: ValueListenableBuilder<List<AppTask>>(
                    valueListenable: ValueNotifier(selectedEvents),
                    builder: (context, value, _) {
                      return selectedEvents.isEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Wrap(
                                  runAlignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.center,
                                  children: const [
                                    Text("No tasks",
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 59, 59, 59),
                                            fontSize: 20)),
                                  ],
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount: value.length,
                              itemBuilder: (BuildContext context, int index) {
                                AppTask event = value[index];
                                return Slidable(
                                  key: Key(event.id),
                                  endActionPane: ActionPane(
                                    motion: const BehindMotion(),
                                    dismissible:
                                        DismissiblePane(onDismissed: () async {
                                      await _onDelete(
                                          event, widget.tags[selectedIndex]);
                                    }),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) async {
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddEventPage(
                                                        task: event,
                                                        selectedDate:
                                                            event.date,
                                                        updateTaskDetails:
                                                            () {},
                                                      )));
                                          _updateTask(widget.tags[0]);
                                        },
                                        backgroundColor: Color(0xFF21B7CA),
                                        foregroundColor: Colors.white,
                                        icon: Icons.edit,
                                        label: 'Edit',
                                      ),
                                      SlidableAction(
                                        onPressed: (context) async {
                                          await _onDelete(event,
                                              widget.tags[selectedIndex]);
                                        },
                                        backgroundColor:
                                            const Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  child: Wrap(
                                    children: [
                                      ListTile(
                                          title: eventVar(event.title, event),
                                          onTap: () async {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TaskDetails(event)));
                                            _updateTask(
                                                widget.tags[selectedIndex]);
                                          },
                                          subtitle: allNTag(event),
                                          leading: IconButton(
                                              icon: complStatusIcon(event),
                                              onPressed: () async {
                                                await ifEventCompleted(
                                                    event,
                                                    index,
                                                    widget.tags[selectedIndex]);
                                              })),
                                      Divider(
                                        color: Colors.white,
                                        indent: 3,
                                      ),
                                    ],
                                  ),
                                );
                              });
                    }),
              ),
            ),
          ),
          Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.05),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: addTaskMode
                    ? FloatingActionButton(
                        child: Icon(Icons.add, color: Colors.white),
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddEventPage(
                                        selectedDate: DateTime.now(),
                                        updateTaskDetails: () {},
                                      )));
                          _updateTask(widget.tags[selectedIndex]);
                        })
                    : DragTarget<Tags>(onAccept: (Tags tag) async {
                        List<AppTask> tagEvents =
                            getMatchyEvent(tag, widget.eventTagList);
                        selectedIndex = 0;
                        await DatabaseServices().removeTag(tag);
                        if (tagEvents.isNotEmpty) {
                          for (AppTask task in tagEvents) {
                            await DatabaseServices().removeTagTask(task);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Tag ${tag.title} has been removed from all the related tasks')));
                        }
                        _updateTask(widget.tags[0]);
                      }, builder: (_, __, ___) {
                        return FloatingActionButton(
                            backgroundColor: Colors.red,
                            child: Icon(Icons.delete, color: Colors.white),
                            onPressed: () {});
                      }),
              ))
        ]));
  }
}
