import 'package:flutter/material.dart';
import 'package:flutter_application_3/Screens/second_screen.dart';
import 'package:flutter_application_3/db_helper/db_helper.dart';
import 'package:flutter_application_3/model/student_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? selectedId;
  final nameController = TextEditingController();
  final courseController = TextEditingController();
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQLFLITE App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              'Enter Student Details',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 200.0,
                  child: TextField(
                    decoration: InputDecoration(
                      label: Text('Enter Name :'),
                    ),
                    controller: searchController,
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new Second(
                                name: searchController.text,
                              )),
                    );
                  },
                  child: Text(
                    "Select Data",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Divider(color: Colors.black),
            ),
            TextField(
              decoration: InputDecoration(
                label: Text('Enter Name :'),
              ),
              controller: nameController,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text('Enter Course :'),
              ),
              controller: courseController,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Student Details',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: Expanded(
                child: FutureBuilder<List<Student>>(
                    future: DatabaseHelper.instance.getStudentDetails(),
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
                                      title: Text(
                                          'Student Name : ${student.name}'),
                                      subtitle:
                                          Text('Course : ${student.course}'),
                                      onTap: () {
                                        setState(() {
                                          if (selectedId == null) {
                                            nameController.text = student.name;
                                            courseController.text =
                                                student.course.toString();
                                            selectedId = student.id;
                                          } else {
                                            nameController.text = '';
                                            courseController.text = '';
                                            selectedId = null;
                                          }
                                        });
                                      },
                                      onLongPress: () {
                                        setState(() {
                                          DatabaseHelper.instance
                                              .remove(student.id!);
                                        });
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                    }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          selectedId != null
              ? await DatabaseHelper.instance.update(
                  Student(
                      id: selectedId,
                      name: nameController.text,
                      course: courseController.text),
                )
              : await DatabaseHelper.instance.add(
                  Student(
                      name: nameController.text, course: courseController.text),
                );
          setState(() {
            nameController.clear();
            courseController.clear();
            selectedId = null;
          });
        },
      ),
    );
  }
}
