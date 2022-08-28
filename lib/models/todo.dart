// To parse this JSON data, do
//
//     final todo = todoFromMap(jsonString);

import 'dart:convert';

class Todo {
  Todo({
    required this.name,
    required this.desc,
    required this.done,
  });

  final String name;
  final String desc;
  final bool done;

  Todo copyWith({
    String? name,
    String? desc,
    bool? done,
  }) =>
      Todo(
        name: name ?? this.name,
        desc: desc ?? this.desc,
        done: done ?? this.done,
      );

  factory Todo.fromJson(String str) => Todo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Todo.fromMap(Map<String, dynamic> json) => Todo(
        name: json["name"],
        desc: json["desc"],
        done: json["done"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "desc": desc,
        "done": done,
      };
}
