import 'package:flutter/material.dart';
import 'package:todo_list_sqflite/database/database_helper.dart';
import 'package:todo_list_sqflite/model/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color mainColor = const Color(0xFFFFFFFF);
  Color secColor = const Color(0xFF74959A);
  Color btnColor = const Color(0xFF98B4AA);
  Color editorColor = const Color(0xFFF1E0AC);

  TextEditingController inputController = TextEditingController();
  String newModelTxt = "";

  getModel() async {
    final model = await DatabaseProvider.databaseProvider.getModel();
    print(model);
    return model;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
        centerTitle: true,
        backgroundColor: secColor,
      ),
      backgroundColor: mainColor,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<dynamic>(
              future: getModel(),
              builder: (_, modelData) {
                switch (modelData.connectionState) {
                  case ConnectionState.waiting:
                    {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  case ConnectionState.done:
                    {
                      if (modelData.data != null) {
                        return Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                            itemCount: modelData.data.length,
                            itemBuilder: (context, index) {
                              String model =
                                  modelData.data[index]['model'].toString();
                              String day = DateTime.parse(
                                      modelData.data[index]['creationDate'])
                                  .day
                                  .toString();
                              return Card(
                                color: secColor,
                                child: InkWell(
                                  child: IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 12),
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: btnColor,
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              day,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              model,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text("No Data"),
                        );
                      }
                    }
                  default:
                }
                return Container();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: editorColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 5,
                      child: TextField(
                        controller: inputController,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'What needs to be done?',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    Flexible(
                        child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            newModelTxt = inputController.text;
                            inputController.clear();
                          });
                          Model newTask = Model(
                              model: newModelTxt, dateTime: DateTime.now());
                          DatabaseProvider.databaseProvider.addNewTodo(newTask);
                        },
                        child: const Icon(
                          Icons.add,
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
