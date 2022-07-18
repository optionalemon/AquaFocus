import 'package:AquaFocus/model/tag_colors.dart';
import 'package:AquaFocus/model/tags.dart';
import 'package:AquaFocus/screens/Tasks/add_task.dart';
import 'package:AquaFocus/services/database_services.dart';
import 'package:AquaFocus/widgets/loading.dart';
import 'package:flutter/material.dart';

class ListTag extends StatefulWidget {
  const ListTag({Key? key}) : super(key: key);

  @override
  State<ListTag> createState() => _ListTagState();
}

class _ListTagState extends State<ListTag> {
  List tags = [];
  int selectedIndex = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _getTags();
  }

  _getTags() async {
    tags = await DatabaseServices().getUserTags();
    tags.insert(0, Tags(title: "All", color: "indigo"));
    setState(() {
      loading = false;
    });
  }

  _getTagColor(Tags tag) {
    for (TagColors tagColor in tagColors) {
      if (tag.color == tagColor.title) {
        return tagColor.color;
      }
    }
  }

  _buildTags(Tags tag, int index) {
    return Row(
      children: [
        ChoiceChip(
          backgroundColor: Colors.white,
          selectedColor: _getTagColor(tag),
          label: Text(
            tag.title,
            style: selectedIndex == index ? TextStyle(color: Colors.black) : TextStyle(color: _getTagColor(tag)),
          ),
          selected: selectedIndex == index,
          onSelected: (bool selected) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.02,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading? const Loading() : Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: SizedBox(
              height: size.height * 0.1,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tags.length,
                  itemBuilder: (BuildContext context, int index) {
                    Tags tag = tags[index];
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
                                      updateTaskDetails: () {
                                        //TODO
                                      },
                                    )));
                      })))
        ]));
  }
}
