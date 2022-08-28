import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/models/todo.dart';
import 'firebase_options.dart';

final todosCollection = FirebaseFirestore.instance
    .collection('todos')
    .withConverter<Todo>(
        fromFirestore: (snapshot, options) => Todo.fromMap(snapshot.data()!),
        toFirestore: (todo, options) => todo.toMap());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todo-List")),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            todosCollection.add(
              Todo(
                name: "Todo ${Random().nextInt(1000)}",
                desc: "Desc ${Random().nextInt(1000)}",
                done: Random().nextBool(),
              ),
            );
          },
          child: Icon(Icons.add)),
      body: StreamBuilder<QuerySnapshot<Todo>>(
        stream: todosCollection
            // .where('done', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );

          if (snapshot.hasError)
            return Center(
              child: Text(snapshot.error.toString()),
            );

          List<QueryDocumentSnapshot<Todo>> todosSnap = snapshot.data!.docs;
          return ListView.builder(
            itemCount: todosSnap.length,
            itemBuilder: (_, i) {
              QueryDocumentSnapshot<Todo> todoSnap = todosSnap[i];
              Todo todo = todoSnap.data();
              return ListTile(
                onTap: (() => todosCollection
                    .doc(todoSnap.id)
                    .update(todo.copyWith(done: !todo.done).toMap())),
                title: Text(
                  todo.name,
                  style: TextStyle(
                      decoration:
                          todo.done ? TextDecoration.lineThrough : null),
                ),
                subtitle: Text(todo.desc),
                leading: CircleAvatar(
                  child: Icon(todo.done ? Icons.check : Icons.close),
                ),
                trailing: IconButton(
                  onPressed: () {
                    todosCollection.doc(todoSnap.id).delete();
                  },
                  icon: Icon(Icons.delete_forever),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   List todos = List.generate(10, ((index) => "To Do : $index"));
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         drawer: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Drawer(
//             elevation: 8,
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 const DrawerHeader(
//                   child: Text(
//                     "LineUps",
//                     style: TextStyle(color: Colors.white, fontSize: 28),
//                   ),
//                   decoration: BoxDecoration(color: Colors.blue),
//                 ),
//                 Card(
//                   child: ListTile(
//                     title: const Text('My Account'),
//                     leading: Icon(
//                       Icons.person,
//                       color: Colors.black,
//                     ),
//                     trailing: Icon(Icons.arrow_forward),
//                     onTap: () {
//                       // Update the state of the app.
//                       // ...
//                     },
//                   ),
//                 ),
//                 Card(
//                   child: ListTile(
//                     title: const Text('Create Task'),
//                     leading: Icon(
//                       Icons.add,
//                       color: Colors.black,
//                     ),
//                     trailing: Icon(Icons.arrow_forward),
//                     onTap: () {
//                       // Update the state of the app.
//                       // ...
//                     },
//                   ),
//                 ),
//                 Card(
//                   child: ListTile(
//                     title: const Text('Done List'),
//                     leading: Icon(
//                       Icons.check_circle,
//                       color: Colors.black,
//                     ),
//                     trailing: Icon(Icons.arrow_forward),
//                     onTap: () {
//                       // Update the state of the app.
//                       // ...
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         appBar: AppBar(title: Text("To Do List ")),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ListView.builder(
//             itemCount: todos.length,
//             itemBuilder: (context, index) {
//               return Card(
//                 elevation: 8,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 shadowColor: Colors.black38,
//                 child: ListTile(
//                   title: Text("${todos[index]}"),
//                   trailing: Icon(
//                     Icons.delete,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
