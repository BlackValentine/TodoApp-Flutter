import 'package:flutter/material.dart';
import 'package:provider_ex/constants/colors.dart';
import 'package:provider_ex/model/todo.dart';
import 'package:provider_ex/widgets/todo_item.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final toDosList = ToDo.toDoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    _foundToDo = toDosList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: const EdgeInsets.only(bottom: 70),
              child: Column(
                children: [
                  searchBox(),
                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(top: 50, bottom: 20),
                            child: const Text('All ToDos',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500))),
                        for (ToDo todo in _foundToDo.reversed)
                          TodoItem(
                            todo: todo,
                            onToDoChanged: _handleToDoChange,
                            onDeleteItem: _handleDeleteItem,
                          ),
                      ],
                    ),
                  )
                ],
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  margin:
                      const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 10.0,
                            spreadRadius: 10.0),
                      ],
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                      controller: _todoController,
                      decoration: const InputDecoration(
                          hintText: "Add a new todo item",
                          border: InputBorder.none)),
                )),
                Container(
                  margin: const EdgeInsets.only(bottom: 20, right: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      _addToDoItem(_todoController.text);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: tdBlue,
                        minimumSize: const Size(60, 60),
                        elevation: 10),
                    child: const Text(
                      "+",
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _handleDeleteItem(String id) {
    setState(() {
      _foundToDo.removeWhere((item) => item.id == id);
    });
  }

  void _addToDoItem(String toDo) {
    setState(() {
      _foundToDo.add(ToDo(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          todoText: toDo));
    });
    debugPrint('add');
    _todoController.clear();
  }

  void _runFilter(String enteredKeyworkd) {
    List<ToDo> results = [];
    if (enteredKeyworkd.isEmpty) {
      results = toDosList;
    } else {
      results = toDosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyworkd.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo = results;
    });
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(
              Icons.search,
              color: tdBlack,
              size: 20,
            ),
            prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(color: tdGrey)),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: tdBGColor,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Icon(Icons.menu, color: tdBlack),
        Container(
          height: 40,
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/images/avatar1.jpg'),
          ),
        )
      ]),
    );
  }
}
