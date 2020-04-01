import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_list/utils/functions.dart';


void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  )
);


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  TextEditingController textControl = TextEditingController(); 
  
  List _toDoList = [];

  @override
  void initState(){
    super.initState();
    loadData().then((data){
      print(data);
      setState(() {
        _toDoList = json.decode(data);
      });
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do List"),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17, 1, 7, 1),
            child: Row(
              children: <Widget>[
                  Expanded(
                    child:TextField(
                      controller: textControl,
                      decoration: InputDecoration(
                        labelText: "New Todo",
                        labelStyle: TextStyle(
                          color: Colors.purple
                        )
                      ),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.purple,
                    child: Text("Add"),
                    textColor: Colors.white,
                    onPressed: (){
                        setState(() {
                          Map<String,dynamic>data = addToList(textControl);
                          _toDoList.add(data);
                          saveData(_toDoList);
                        });
                      }
                    )
                ],
              ),
          ),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top:10),
              itemCount: _toDoList.length,
              itemBuilder: (contex,index){
                return CheckboxListTile(
                  title: Text(_toDoList[index]["title"]),
                  value: _toDoList[index]["conclued"],
                  secondary: CircleAvatar(
                    child: Icon(_toDoList[index]["conclued"]?Icons.cached:Icons.error,color: Colors.purple,),
                  ),
                  onChanged:(cheched){
                    setState(() {
                      _toDoList[index]["conclued"] = cheched;
                      saveData(_toDoList);
                    });
                  },
                );
              }
              )
          )
        ],
        ),
    );
  }
}

