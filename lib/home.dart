import 'package:blog_app/create_blog.dart';
import 'package:blog_app/services/crud.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  // ignore: non_constant_identifier_names
  Widget BlogList(){
    return Container(
      child:  blogsStream != null ?Column(
        children: <Widget>[
          StreamBuilder(
            stream: blogsStream,
              builder: (context , snapshot ){
              return ListView.builder(
                itemCount: snapshot.data.documents.length ,
                shrinkWrap: true,
                itemBuilder: (context , index){
                  return BlogsTile(
                      imgUrl: snapshot.data.documents[index].data['imageUrl'],
                      title: snapshot.data.documents[index].data['title'],
                      description: snapshot.data.documents[index].data['desc'],
                      authorName: snapshot.data.documents[index].data['authorName']);
                  },
               );
              })
        ],
      ):Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    )
    );
  }


  CrudMethods crudMethods = new CrudMethods();
  Stream blogsStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    crudMethods.getData().then((result){

      setState(() {
        blogsStream = result;
      });

    });

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
      ),
      body: BlogList(),
      floatingActionButton: Container(
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              onPressed: (){
                Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context)=> CreateBLog())
                );
              },
              child: Icon(Icons.add) ,
            ),
          ],
        ),
      )

    );
  }
}



class BlogsTile extends StatelessWidget {

  String imgUrl, title , authorName , description;

  BlogsTile({
    @required this.imgUrl,
    @required this.title,
    @required this.description,
    @required this.authorName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 150,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(
              imageUrl: imgUrl,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,),
          ),
          Container(
            height: 170,
            decoration: BoxDecoration(
              color: Colors.black54.withOpacity(0.3),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  fontSize: 22,fontWeight: FontWeight.w500
                ),),
                SizedBox(height: 4,),
                Text(description,
                  style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w400
                  ),),
                SizedBox(height: 4,),
                Text(authorName),
              ],
            ),
          )
        ],
      ),
    );
  }
}

