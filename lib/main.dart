import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void navigateToHomeScreen(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Home Screen',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: navigateToHomeScreen,
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25)
          ),
          elevation: 11,
          child: Container(
            height: 50,
            width: 180,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(25)
            ),
            child: Center(
              child: Text(
                  'Share Your Meal',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white
                ),
              ),
            ),
          ),
        ),
      )
    );
  }

}


class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
  XFile? imageFile = null;

  bool hasEaten = false;

  void showDialog() {
    setState(() {
      hasEaten = true;
    });
  }

  double petHeight = 120;
  double petWidth = 120;

  @override
  Widget build(BuildContext context) {


    if(hasEaten==true){
      return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Center(
            child:  Text(
              "GOOD JOB",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 50,
                  color: Colors.green
              ),
            ),
          ),
        )
      );
    }else{
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.green,
              radius: 10,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.white,
                icon: Icon(Icons.arrow_back),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              imageFile == null ? "Click Your Meal" : "Will You Eat This?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black
              ),
            ),
            SizedBox(height: 10,),
            FloatingActionButton(
              onPressed: () async{
                if(imageFile == null){
                  _settingModalBottomSheet(context);
                }else{
                  setState(() {
                    petHeight = petHeight+50;
                    petWidth = petWidth+50;
                  });
                  Timer(Duration(seconds: 2), this.showDialog);
                }
              },
              child: imageFile == null ? Icon(Icons.camera_enhance) : Icon(Icons.send),
              backgroundColor: Colors.green,
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(seconds: 1),
              height: petHeight,
              width: petWidth,
              child: Image.asset("images/1.png"),
            ),
            if(imageFile != null)...[
              Center(
                child: CircleAvatar(
                    radius: 120,
                    backgroundImage: FileImage(File(imageFile!.path))
                ),
              )
            ],
            if(imageFile == null)...[
              Center(
                child: CircleAvatar(
                  radius: 120,
                  backgroundColor: Colors.grey,
                ),
              )
            ],
          ],
        )
      );
    }
  }

  //********************** IMAGE PICKER
  Future imageSelector(BuildContext context, String pickerType) async {
    switch (pickerType) {
      case "gallery":
        imageFile = (await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 90))!;
        break;

      case "camera":
        imageFile = (await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 90))!;
        break;
    }
    if (imageFile != null) {
      print("You selected  image : " + imageFile!.path);
      setState(() {
        debugPrint("SELECTED IMAGE PICK   $imageFile");
      });
    } else {
      print("You have not taken image");
    }
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    title: new Text('Gallery'),
                    onTap: () => {
                      imageSelector(context, "gallery"),
                      Navigator.pop(context),
                    }),
                new ListTile(
                  title: new Text('Camera'),
                  onTap: () => {
                    imageSelector(context, "camera"),
                    Navigator.pop(context)
                  },
                ),
              ],
            ),
          );
        });
  }
}
