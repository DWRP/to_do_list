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

  Map<String, dynamic> _lastRemoved;
  
  int _lastRemovedPos;

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

  Future<Null> _refresh() async{
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _toDoList.sort((index,next){
        if (index["conclued"] && !next["conclued"]) return 1;
        else if (!index["conclued"] && next["conclued"]) return -1;
        else return 0;
      });
      saveData(_toDoList);
    });

    return null;
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
            child: RefreshIndicator(
              child: ListView.builder(
                padding: EdgeInsets.only(top:10),
                itemCount: _toDoList.length,
                itemBuilder: buildItem
              ), 
              onRefresh: _refresh)
          )
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context,int index){
    return Dismissible(
        background: Container(
          color: Colors.red,
          child: Align(
            alignment: Alignment(-0.9, 0),
            child: Icon(Icons.delete,color:Colors.white),
          ),
        ),
        direction: DismissDirection.startToEnd,
        key: Key(DateTime.now().millisecondsSinceEpoch.toString()), 
        child: CheckboxListTile(
          title: Text(_toDoList[index]["title"]),
          value: _toDoList[index]["conclued"],
          secondary: CircleAvatar(
            child: Icon(_toDoList[index]["conclued"]?Icons.done:Icons.error,color: Colors.purple,),
          ),
          onChanged:(cheched){
            setState(() {
              _toDoList[index]["conclued"] = cheched;
              saveData(_toDoList);
            });
          },
        ),
        onDismissed: (direction){
          setState(() {
            _lastRemoved = Map.from(_toDoList[index]);
            _lastRemovedPos = index;
            _toDoList.removeAt(index);
            saveData(_toDoList);

            final snack = SnackBar(
              content: Text('Task \"${_lastRemoved["title"]}\" removed!'),
              action: SnackBarAction(
                label: "Dimiss",
                onPressed: (){
                  setState(() {
                    _toDoList.insert(_lastRemovedPos, _lastRemoved);
                  });
                },
                ),
                duration: Duration(seconds:3),
            );
            
            Scaffold.of(context).removeCurrentSnackBar();
            Scaffold.of(context).showSnackBar(snack);
          });

        },
      );
  }
}

