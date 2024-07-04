import 'package:flutter/material.dart';

void main() => runApp(TodoList());

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<String> _todoList = [];
  final TextEditingController _textFieldController = TextEditingController();

  void _addTodoItem(String task) {
    setState(() {
      _todoList.add(task);
    });
    _textFieldController.clear();
  }

  void _editTodoItem(int index, String newTask) {
    setState(() {
      _todoList[index] = newTask;
    });
  }

  void _deleteTodoItem(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Are you sure?",
            style: TextStyle(
                fontFamily: 'Lightitalic', fontWeight: FontWeight.w700),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _todoList.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Add Task',
            style: TextStyle(
                fontFamily: 'Lightitalic', fontWeight: FontWeight.w700),
          ),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: 'Enter task here'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                _addTodoItem(_textFieldController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditTodoDialog(int index) {
    _textFieldController.text = _todoList[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Edit Task',
            style: TextStyle(
                fontFamily: 'Lightitalic', fontWeight: FontWeight.w700),
          ),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: 'Enter new task here'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                _editTodoItem(index, _textFieldController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTodoItem(String task, int index) {
    return ListTile(
      title: Text(
        task,
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
            ),
            onPressed: () => _showEditTodoDialog(index),
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
            ),
            onPressed: () => _deleteTodoItem(index),
          ),
        ],
      ),
    );
  }

  Widget _buildTodoList() {
    return ListView.builder(
      itemCount: _todoList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: Expanded(
            child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      spreadRadius: 1,
                      color: Color.fromARGB(255, 81, 137, 165),
                    )
                  ],
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 105, 177, 213),
                ),
                child: _buildTodoItem(_todoList[index], index)),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 228, 253),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: ClipPath(
          clipBehavior: Clip.hardEdge,
          clipper: CustomAppBarClipper(),
          child: AppBar(
            backgroundColor: Color.fromARGB(255, 255, 204, 0),
            centerTitle: true,
            title: Text(
              'To-Do List',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 40,
                fontFamily: 'Blackitalic',
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          _buildTodoList(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: AnimatedBall(),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'ghalibthassan@gmail.com',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'Forte',
                    foreground: Paint()
                      ..strokeWidth = 1
                      ..style = PaintingStyle.stroke
                      ..color = Colors.amber),
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }
}

class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(0, size.height, 20, size.height);
    path.lineTo(size.width - 20, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class AnimatedBall extends StatefulWidget {
  @override
  _AnimatedBallState createState() => _AnimatedBallState();
}

class _AnimatedBallState extends State<AnimatedBall>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    _animation = Tween<Offset>(
      begin: Offset(-1.0, 0),
      end: Offset(1.0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutSine,
      ),
    );

    _controller
      ..addListener(() {
        setState(() {});
      })
      ..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
