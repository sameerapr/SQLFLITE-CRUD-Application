import 'package:flutter/material.dart';
import 'package:flutter_application_3/db_helper/db_helper.dart';
import 'package:flutter_application_3/model/student_model.dart';

class Second extends StatefulWidget {
  final String name;
  const Second({super.key, required this.name});

  @override
  State<Second> createState() => _SecondState();
}

class _SecondState extends State<Second> {
  int? selectedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder<List<Student>>(
                  future: DatabaseHelper.instance
                      .getStudentDetailsById(widget.name),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Student>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: Text('Loading...'));
                    }
                    return snapshot.data!.isEmpty
                        ? Center(child: Text('No Student Details in List.'))
                        : ListView(
                            children: snapshot.data!.map((student) {
                              return Center(
                                child: Card(
                                  color: selectedId == student.id
                                      ? Colors.white70
                                      : Colors.white,
                                  child: ListTile(
                                    title:
                                        Text('Student Name : ${student.name}'),
                                    subtitle:
                                        Text('Course : ${student.course}'),
                                    onTap: () {
                                      setState(() {});
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
