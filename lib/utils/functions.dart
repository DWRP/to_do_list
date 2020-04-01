import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

Future<File> _getFile() async{
  final directory = await getApplicationDocumentsDirectory();
  return File("${directory.path}/todoData.json");
}

Future<File> saveData(List todoList) async{
  String data = json.encode(todoList);
  final file = await _getFile();
  return file.writeAsString(data);
}

Future<String> loadData() async{
  try{
    final file = await _getFile();
    return file.readAsString();

  }catch(error){
    return null;
  }
}

Map<String, dynamic> addToList(TextEditingController text){
  Map<String, dynamic> newTodo = Map();
  newTodo["title"] = text.text;
  newTodo["conclued"] = false;
  text.text = "";
  return newTodo;
}