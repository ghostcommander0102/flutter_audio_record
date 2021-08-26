import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:path_provider/path_provider.dart';
import 'list.dart';
import 'view.dart';
import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';

class HomePage extends StatefulWidget {
  final String _appTitle;


  const HomePage({Key? key, required String title})
      : assert(title != null),
        _appTitle = title,
        super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // recognizing google speech service
  bool recognizing = false;
  bool recognizeFinished = false;
  String text = '';

  late Directory? appDir;
  late List<String>? records;
  static late List<String>? globalrecords;
  String searchval = '';

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    records = [];
    getExternalStorageDirectory().then((value) {
      appDir = value!;
      Directory appDirec = Directory("${appDir!.path}/Audiorecords/");
      print(Directory('path'));
      appDir = appDirec;

      appDir!.list().listen((onData) {
        records!.add(onData.path);
      }).onDone(() {
        records = records!.reversed.toList();
        setState(() {
          this.records = records;
          globalrecords = records;
        });
      });
    });
  }

  void search(String category, String searchStr) {
    if (category == 'All') {
      category = '';
    }
    print(category);
    print(searchStr);
    records = globalrecords;
    for(int i = 0; i < globalrecords!.length; i++ ) {
      print('searchStr');
      print(globalrecords!.elementAt(i).indexOf(searchStr));
      print(globalrecords!.elementAt(i).indexOf(category));
      if (globalrecords!.elementAt(i).indexOf(searchStr) == -1 || globalrecords!.elementAt(i).indexOf(category) == -1){
        records!.remove(globalrecords!.elementAt(i));
      }
    }
  }

  // @override
  // void dispose() {
  //   appDir = null;
  //   records = null;
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child:  InkWell(child: Icon(Icons.mic),onTap: (){

          show(context);},),
      ),
      appBar: AppBar(
          actions: <Widget>[
            // IconButton(
            //   onPressed: (){
            //     _searchPressed();
            //     // showSearch(context: context, delegate: Search());
            //   },
            //   icon: Icon(Icons.search),
            // )
          ],
          centerTitle: true,
          backgroundColor: Colors.lightBlue,
          title: Text('Recording sound'),
          // widget._appTitle,
          // style: TextStyle(color: Colors.white),
      ),
      body:
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(0),
                  child:SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    child:TextField(
                      decoration: InputDecoration(
                      labelText: 'search',
                        focusColor: Colors.lightBlue,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.lightBlue),
                          borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.lightBlue),
                        borderRadius: BorderRadius.circular(10),
                      )),
                      onChanged: (value){
                        initRecords(value.toString());
                        setState((){
                          searchval = value.toString();
                        });
                      },
                      // onEditingComplete: () {
                      //   print('ddd');
                      // },
                    ),
                  )
                ),
              ]
            ),
            Expanded(
              flex: 2,
              child: Records(
                records: records!,
              ),
            ),

          ],
        ),
    );
  }

  void _getNames() async {

    setState(() {

    });
  }

  void _searchPressed() {

  }

  _onFinish() {
    records!.clear();
    print(records!.length.toString());
    appDir!.list().listen((onData) {
      records!.add(onData.path);
    }).onDone(() {
      records!.sort();
      records = records!.reversed.toList();
      setState(() {});
    });
  }

  void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white70,
          child: Recorder(
            save: _onFinish,
          ),
        );
      },
    );
  }

  void initRecords(String searchStr) {
    records!.clear();
    // print(records!.length.toString());
    appDir!.list().listen((onData) {
      if(onData.path.substring(onData.path.lastIndexOf('/')+1, onData.path.lastIndexOf('#')).indexOf(searchStr) != -1) {
        records!.add(onData.path);
      }
    }).onDone(() {
      records!.sort();
      records = records!.reversed.toList();
      setState(() {});
    });
  }


  @override
  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Popup example'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Hello"),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }
}