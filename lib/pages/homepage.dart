


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:photo_app_firebase/models/photoapp.dart';
import 'package:photo_app_firebase/pages/formpage.dart';
import 'package:photo_app_firebase/services/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final DatabaseService _databaseService=DatabaseService();

  
 void dd() {
  
 }
 bool _sortByTime = true;
 bool _sortByTimeLatest = false;
  bool _sortByPhotographer = false;
  bool _sortByFavorites = false;
   bool _sortByFavoritesUnLike = false;
  

  
  

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _buildUi(),
      floatingActionButton: FloatingActionButton(onPressed: (){
        showDialog(context: context, builder: (context) {
            return FormPage();
        });
        },
        backgroundColor: Colors.deepOrange,
        child: Icon(Icons.add,color: Colors.white,),shape: CircleBorder(),),
    
    );
  }

    PreferredSizeWidget _appBar() {
       return AppBar(
           title: const  Text('Photo Gallery',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.white70),),
           actions: [
          IconButton( icon: const Icon(Icons.filter_list,color: Colors.white70,),onPressed: (){
             showDialog(
  context: context,
  builder: (BuildContext context) {
    return Stack(
      children: <Widget>[
       Positioned(
         top: 50,
                      right: 10,
        child: AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CheckboxListTile(
                    title: Text('Default'),
                    value: _sortByTime,
                    onChanged: (bool? value) {
                      setState(() {
                        _sortByTime = value!;
                        _sortByPhotographer = false;
                        _sortByFavorites = false;
                        _sortByFavoritesUnLike=false;
                        _sortByTimeLatest=false;
                     
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Time - Latest Last'),
                    value: _sortByTimeLatest,
                    onChanged: (bool? value) {
                      setState(() {
                          _sortByTimeLatest=value!;
                        _sortByFavorites = false;
                        _sortByTime = false;
                        _sortByPhotographer = false;
                        _sortByFavoritesUnLike=false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('photographer name'),
                    value: _sortByPhotographer,
                    onChanged: (bool? value) {
                      setState(() {
                        _sortByPhotographer = value!;
                         print('Sort by photographer: $_sortByPhotographer');
                        _sortByTime = false;
                        _sortByFavorites = false;
                         _sortByFavoritesUnLike=false;
                        _sortByTimeLatest=false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Liked'),
                    value: _sortByFavorites,
                    onChanged: (bool? value) {
                      setState(() {
                        _sortByFavorites = value!;
                        _sortByTime = false;
                        _sortByPhotographer = false;
                         _sortByFavoritesUnLike=false;
                        _sortByTimeLatest=false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('UnLiked'),
                    value: _sortByFavoritesUnLike,
                    onChanged: (bool? value) {
                      setState(() {
                          _sortByFavoritesUnLike=value!;
                        _sortByFavorites = false;
                        _sortByTime = false;
                        _sortByPhotographer = false;
                        _sortByTimeLatest=false;
                      });
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
      ],
    );
  },
);

          },),


          IconButton(icon: const Icon(Icons.sort_rounded,color: Colors.white70,),onPressed: () {
            showDialog(context: context, builder: (BuildContext context){
                  return  Stack(
                    children: <Widget>[
                    Positioned(
                      top: 50,
                      right: 10,
                      child: AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                          
                            children: [
                              Text('hello')
                            ],
                          ),
                        ),
                    ),
                    ],
                  );
                  
            }
            
            );
          },),
           ],
           backgroundColor: const Color(0xFF4A4C50),
       );
    }

   Widget  _buildUi() {
    return  SafeArea(
      child:  Column(
       children: [
       _messagesListView()
       ],

      )
      );
   }

    Widget _messagesListView() {
    
      Stream<QuerySnapshot> stream = _databaseService.getPhotos();

      

  return SizedBox(
    height: MediaQuery.sizeOf(context).height * 0.80,
    width: MediaQuery.sizeOf(context).width,
    child: StreamBuilder(
      
  stream: stream,
  

  builder: (context, snapshot) {
    List photos = snapshot.data?.docs ?? [];

    if (photos.isEmpty) {
      return const Center(
        child: Text('Add a Details'),
      );
    }

    




    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        PhotoApp photoss = photos[index].data();
        String photoId = photos[index].id;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(photoss.photoURL),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              _databaseService.deletePhoto(photoId);
                            },
                            icon: Icon(Icons.delete),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                PhotoApp updatePhotoApp = photoss.copyWith(
                                  isLiked: !photoss.isLiked,
                                );
                                _databaseService.updatePhoto(
                                  photoId,
                                  updatePhotoApp,
                                );
                              });
                            },
                            icon: Icon(Icons.favorite),
                            color: photoss.isLiked ? Colors.red : Colors.orange,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            photoss.description,
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            DateFormat("dd MMM, yyyy")
                                .format(photoss.createdTime.toDate()),
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            photoss.photographerName,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  },
),

  );
}

                  
                 
  
  }
