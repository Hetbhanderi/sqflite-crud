import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflitedbpractic/Data/local/db_helpar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Sqlite Demo'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Note : Notes Database Instance
DatabaseHelper Db = DatabaseHelper.getinstanec();

//Form Variables
//FormKey
final Formkey = GlobalKey<FormState>();
String Title = "";
String Description = "";

TextEditingController TitleController = TextEditingController();
TextEditingController DescriptionController = TextEditingController();

List<Map<String, dynamic>> Fetch_all_notes = [];

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    fetchnotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Fetch_all_notes.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text("${index + 1}"),
                  title: Text("${Fetch_all_notes[index]['title']}"),
                  subtitle: Text("${Fetch_all_notes[index]['detail']}"),
                  trailing: Container(
                    child: SizedBox(
                      width: 80,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: 0,
                          children: [
                            IconButton(
                              onPressed: () async {
                                TitleController.text =
                                    Fetch_all_notes[index]['title'];
                                DescriptionController.text =
                                    Fetch_all_notes[index]['detail'];
                                await showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Note_Form(
                                      updateNote: true,
                                      utitle: Fetch_all_notes[index]['title'],
                                      udesc: Fetch_all_notes[index]['detail'],
                                      updateid: Fetch_all_notes[index]['id'],
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () async {
                                bool delete_row = await Db.DeleteData(
                                  delete_id: Fetch_all_notes[index]['id'],
                                );
                                if (delete_row) {
                                  print("Data Deleted");
                                  fetchnotes();
                                } else {
                                  print(
                                    "Something Went Wrong Data Not Deleted",
                                  );
                                }
                              },
                              icon: Icon(Icons.delete_forever),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: Fetch_all_notes.length,
            )
          : Center(child: Text("No data Here")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Note_Form();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget Note_Form({
    bool updateNote = false,
    String? utitle,
    String? udesc,
    int? updateid,
  }) {
    // if (updateNote) {
    //   TitleController.text = utitle ?? "";
    //   DescriptionController.text = udesc ?? "";
    // }
    return Form(
      key: Formkey,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          spacing: 25,
          children: [
            Center(
              child: updateNote != true
                  ? Text(
                      "Save Note",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text(
                      "Update Note",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            TextFormField(
              controller: TitleController,
              decoration: InputDecoration(
                label: Text("Title"),
                suffixIcon: Icon(Icons.title_rounded),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(
                    color: Colors.deepPurpleAccent,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(
                    color: Colors.deepPurpleAccent,
                    width: 2,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(
                    color: Colors.deepPurpleAccent,
                    width: 1.5,
                  ),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty || value == "") {
                  return "Title Field Is Required";
                } else {
                  Title = TitleController.text.toString();
                  print("Title : ${Title}");
                  return null;
                }
              },
            ),
            TextFormField(
              controller: DescriptionController,
              decoration: InputDecoration(
                label: Text("Description"),
                suffixIcon: Icon(Icons.description_outlined),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(
                    color: Colors.deepPurpleAccent,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(
                    color: Colors.deepPurpleAccent,
                    width: 2,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(
                    color: Colors.deepPurpleAccent,
                    width: 1.5,
                  ),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty || value == "") {
                  return "Description Field is Required";
                } else {
                  Description = DescriptionController.text.toString();
                  print("Description : ${Description}");
                  return null;
                }
              },
            ),
            Row(
              spacing: 20,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      if (Formkey.currentState!.validate()) {
                        // print(Formkey.currentState);
                        if (updateNote != true) {
                          Db.insertdata(title: Title, detail: Description);
                          Db.SelectData();
                          TitleController.clear();
                          DescriptionController.clear();
                          Navigator.pop(context);
                        } else {
                          // Int? Update_id = updateid;
                          int Update_id = updateid as int;
                          bool update_check = await Db.UpdateData(
                            title: TitleController.text.toString(),
                            description: DescriptionController.text.toString(),
                            update_id: Update_id,
                          );
                          if (update_check) {
                            print("Values Updated");
                          } else {
                            print("Something Went Wrong Values Not Updated");
                          }

                          TitleController.clear();
                          DescriptionController.clear();

                          fetchnotes();

                          Navigator.pop(context);
                        }
                      }
                      fetchnotes();
                    },
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(15),
                        ),
                      ),
                    ),
                    child: updateNote != true
                        ? Text("Save Data")
                        : Text("Update Data"),
                  ),
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(15),
                        ),
                      ),
                    ),
                    child: Text("Cancel"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void fetchnotes() async {
    Fetch_all_notes = await Db.SelectData();
    setState(() {
      print("Fetch Set State Called");
      if (Fetch_all_notes.isNotEmpty) {
        print("Data fetched successfully");
        print(
          "Data : ----------------------------------------------------------- ${Fetch_all_notes[0]['title']}",
        );
      } else {
        print("No data found");
      }
    });
  }
}
