


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
  late Stream<QuerySnapshot>ss;
  bool _sortOneDefault = true;
  bool _sortByTimeLatest = false;
  bool _sortByPhotographer = false;
  bool _sortByFavorites = false;
  
   
  
  bool sortByLiked = false;
  bool sortByUnliked = false;   
   bool isChecked=false;
  
  List<String> photographerNames = [];
  List<String> selectedPhotographers = [];
  
  @override
  void initState() {
    super.initState();
    _updateSorting(); 
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: Column(
        children: [ 
          Expanded(child: selectedPhotographers.isEmpty
          ? _messagesListView()
          : _filterView(),
    ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        showDialog(context: context, builder: (context) {
            return Center(child: FormPage());
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
                    value: _sortOneDefault,
                    onChanged: (bool? value) {
                      setState(() {
                        _sortOneDefault = value!;
                        _sortByPhotographer = false;
                        _sortByFavorites = false;
                        
                        _sortByTimeLatest=false;
                      
                      _updateSorting();
                                               
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Time - Latest Last'),
                    value: _sortByTimeLatest,
                    onChanged: (bool? value) {
                      setState(() {
                          _sortByTimeLatest=value!;
                        _sortOneDefault = false;
                        _sortByPhotographer = false;
                        _sortByFavorites=false;
                       _updateSorting();
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
                        _sortOneDefault = false;
                        _sortByTimeLatest=false;
                        _sortByFavorites=false;
                          _updateSorting();
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Favourites'),
                    value: _sortByFavorites,
                    onChanged: (bool? value) {
                      setState(() {
                        _sortByFavorites = value!;
                      _sortOneDefault=false;
                        _sortByTimeLatest=false;
                        _sortByPhotographer=false;
                       
                        _updateSorting();
                        
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
);},),

IconButton(
  icon: const Icon(Icons.sort_rounded, color: Colors.white70),
  onPressed: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [Positioned(
            top: 50,
            right: 5,
            child: AlertDialog(
                content: StatefulBuilder(
                  builder: (BuildContext context,StateSetter setState) {
                      List<CheckboxListTile> checkboxes = [ 
                      CheckboxListTile(
                      title: const Text('Default'),
                      value: _sortOneDefault,
                      onChanged: (bool? value) {
                      setState(() {
                      _sortOneDefault = value!;
                      if (value) {
                      sortByLiked = false;
                      sortByUnliked = false;
                      selectedPhotographers.clear();
                      }
                   _updateSorting();
    });
  },
),
              CheckboxListTile(
                title: const Text('Liked'),
                value: sortByLiked,
                onChanged: (bool? value) {
                  setState(() {
                    sortByLiked = value!;
                    if (value) {
                      _sortOneDefault = false;
                      _sortByPhotographer=false;
                      _sortByFavorites=false;
                      sortByUnliked = false;
                      selectedPhotographers.clear();
                        
                    }
                    _updateSorting();
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Unliked'),
                value: sortByUnliked,
                onChanged: (bool? value) {
                  setState(() {
                    sortByUnliked = value!;
                    if (value) {
                      _sortOneDefault = false;
                      _sortByPhotographer=false;
                      _sortByFavorites=false;
                      sortByLiked = false;
                      selectedPhotographers.clear();
                       
                    }
                     _updateSorting();
                  });
                },
              ),
            ];
             checkboxes.addAll(photographerNames.map((name) {
                      return CheckboxListTile(
                        title: Text(name),
                        value: selectedPhotographers.contains(name),
                        onChanged: (bool? value) {
                            setState(() {
                    if (value != null && value) {
                       selectedPhotographers.add(name);
                       sortByLiked=false;
                       sortByUnliked=false;
                     _sortOneDefault = false;
                      } 
                      else {
                             selectedPhotographers.remove(name);
                          } 
                          });
                       print(selectedPhotographers.isEmpty);
                         _updateSorting();
                          },
                      );
                    }).toList());

            return Stack(
             children: [
                Column(
                      mainAxisSize: MainAxisSize.min,
                      children: checkboxes,
                    ),] ,
                );
               }),
                ),
          ),
          ] ,
        );
      },
    );
  },
),
],
  backgroundColor: const Color(0xFF4A4C50),
  );
}


void _updateSorting() {
 if (_sortOneDefault) {
    ss = _databaseService.getPhotos();
  
  } else if (_sortByTimeLatest) {
    ss = _databaseService.getPhotosByDateLatest();
  } else if (_sortByPhotographer) {
    ss = _databaseService.getPhotosByPhotographer();
  } else if(_sortByFavorites) {
    ss=_databaseService.favouritesOrder();
  }else if (sortByLiked) {
    print("liked value $sortByLiked");
    ss = _databaseService.getPhotosByLikes();
  } else if (sortByUnliked) {
     print("liked value $sortByUnliked");
    ss = _databaseService.getPhotosByUnLiked();
  } 
  
print(selectedPhotographers);
  setState(() {});
}


 Widget _messagesListView() {
      return Padding(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        child: SizedBox(
        child: StreamBuilder(
         stream: ss,
         builder: (context, snapshot) {
          List photos = snapshot.data?.docs ?? [];
        if (photos.isEmpty) {
        return const Center(
          child: Text('Add a Details'),
          );
            }
         photographerNames = photos.map((photo) => photo['photographerName'] as String).toList(); 
            return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
           crossAxisCount: MediaQuery.of(context).size.width > 1000
                      ? 5
                      : MediaQuery.of(context).size.width > 800
                          ? 3
                          : MediaQuery.of(context).size.width > 500
                              ? 2
                              : 1,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 5.0,  
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          PhotoApp photoss = photos[index].data();
          String photoId = photos[index].id;
        return  ClipRRect(
       borderRadius: BorderRadius.circular(10),
       child: Container(
       decoration: BoxDecoration(
       image: DecorationImage(
        image: NetworkImage(photoss.photoURL),
        fit: BoxFit.cover,
      ),
    ),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               IconButton(onPressed: () { _databaseService.deletePhoto(photoId); },icon: Icon(Icons.delete),),
              IconButton(onPressed: () {
                  setState(() {PhotoApp updatePhotoApp = photoss.copyWith(isLiked: !photoss.isLiked,);
                               _databaseService.updatePhoto(photoId, updatePhotoApp,);
                                });
                              },
                              icon: Icon(Icons.favorite),color: photoss.isLiked ? Colors.red : Colors.orange,
                            ),
              ],
            ),
          ],
        ),
        Align(
          
          alignment: Alignment.bottomLeft,
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(photoss.description,style: TextStyle(color: Colors.white),),
              ),
               Padding(
                 padding: const EdgeInsets.all(6.0),
                 child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text( DateFormat("dd MMM, yyyy").format(photoss.createdTime.toDate()), style: TextStyle(color: Colors.white), ),
                    Text(photoss.photographerName,style: TextStyle(color: Colors.white),),
                  ],
                 ),
               ),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
);
},
 );
},
),
 ),
);
}
Widget _filterView() {
  if(selectedPhotographers.isNotEmpty) {
    return Expanded(
      child: SizedBox(
        child: StreamBuilder(
          stream: _databaseService.getPhotosByNameList(selectedPhotographers),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            List photos = snapshot.data?.docs ?? [];
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                PhotoApp photo = photos[index].data();
                String photoId=photos[index].id;
                String pids = photos[index].id;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        photo.photoURL,
                        fit: BoxFit.cover,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(

                          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               IconButton(onPressed: () { _databaseService.deletePhoto(photoId); },icon: Icon(Icons.delete),),
              IconButton(onPressed: () {
                  setState(() {PhotoApp updatePhotoApp = photo.copyWith(isLiked: !photo.isLiked,);
                               _databaseService.updatePhoto(photoId, updatePhotoApp,);
                                });
                              },
                              icon: Icon(Icons.favorite),color: photo.isLiked ? Colors.red : Colors.orange,
                            ),
              ],
            ),
          ],
        ),
        Align(
          
          alignment: Alignment.bottomLeft,
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(photo.description,style: TextStyle(color: Colors.white),),
              ),
               Padding(
                 padding: const EdgeInsets.all(6.0),
                 child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text( DateFormat("dd MMM, yyyy").format(photo.createdTime.toDate()), style: TextStyle(color: Colors.white), ),
                    Text(photo.photographerName,style: TextStyle(color: Colors.white),),
                  ],
                 ),
               ),
              ],
            ),
          ),
        ),
      ],
    ),
                        ),
                      ),
                     
        
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
  else {
    return Text("No details");
  }
  }

 }
