// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:reorderlist/data/userdata.dart';
import 'package:reorderlist/model/users.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User> users = [];
  @override
  void initState() {
    super.initState();
    users = getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ReOrderAble ListView"),
      ),
      body: ReorderableListView.builder(
          itemCount: users.length,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              final user = users.removeAt(oldIndex);
              final index = newIndex > oldIndex ? newIndex - 1 : newIndex;
              users.insert(index, user);
            });
          },
          itemBuilder: (context, index) {
            final user = users[index];
            return buildUser(index, user);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: shuffleusers,
        child: Icon(Icons.shuffle),
      ),
    );
  }

  Widget buildUser(int index, User user) => ListTile(
        key: ValueKey(user),
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.urlImage),
          radius: 30,
        ),
        title: Text(
          user.name,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  edituser(index);
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {
                  removeuser(index);
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.black,
                ))
          ],
        ),
      );
  void removeuser(int index) {
    setState(() {
      users.removeAt(index);
    });
  }

  void shuffleusers() {
    setState(() {
      users.shuffle();
    });
  }

  void edituser(int index) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          final user = users[index];
          return AlertDialog(
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Update")),
            ],
            content: TextFormField(
              initialValue: user.name,
              onFieldSubmitted: (_) {
                Navigator.of(context).pop();
              },
              onChanged: (name) {
                setState(() {
                  user.name = name;
                });
              },
            ),
          );
        });
  }
}
