import 'dart:io';
import 'package:blog_app/services/crud.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';


class CreateBLog extends StatefulWidget {
  @override
  _CreateBLogState createState() => _CreateBLogState();
}

class _CreateBLogState extends State<CreateBLog> {

  String authorName,title,desc;

  CrudMethods crudMethods = new CrudMethods();
  StorageReference firebaseStorageRef = FirebaseStorage.instance.ref();


    File selectedImage;
    bool isLoading = false;
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery,);

      setState(() {
        selectedImage = image;
      });
    }

    uploadBlog() async{
      if(selectedImage != null)
        {
          setState(() {
            isLoading = true;
          });
          StorageReference firebaseStorageRef = FirebaseStorage.instance.ref()
              .child("blogImages").child("${randomAlphaNumeric(9)}.jpg");

          final StorageUploadTask task = firebaseStorageRef.putFile(selectedImage);

          var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
          print("this is url $downloadUrl");

          Map<String,String> blogMap = {
            "imageUrl" : downloadUrl,
            "authorName" : authorName,
            "title" : title,
            "desc" : desc
          };

          crudMethods.addData(blogMap).then((result){
            Navigator.pop(context);
          });

        }
      else{

      }
    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Flutter",
              style: TextStyle(
                  fontSize: 22
              ),),
            Text("BLog",
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.blue
              ) ,)
          ],
        ),
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              uploadBlog();
            },
            child: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.bottomRight,
              child: Icon(Icons.upload_file),
            ),
          )
        ],
      ),
      body: isLoading ? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ) : Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                getImage();
              },
              child:  selectedImage !=null ?
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 170,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.file(selectedImage,
                    fit: BoxFit.cover,),
                ),
              ):
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 170,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                ),
                child: Icon(
                  Icons.add_a_photo,
                  color: Colors.black,),
              ),
            ),
            SizedBox(height: 8,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  TextField(
                    onChanged: (val){
                      authorName = val;
                      },
                    decoration: InputDecoration(
                      hintText: "Author Name",
                    ),
                  ),
                  TextField(
                    onChanged: (val){
                      title = val;
                    },
                    decoration: InputDecoration(
                      hintText: "Title",
                    ),
                  ),
                  TextField(
                    onChanged: (val){
                      desc = val;
                    },
                    decoration: InputDecoration(
                      hintText: "Description",
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
