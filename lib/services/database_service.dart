import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photo_app_firebase/models/photoapp.dart';

const String PHOTO_APP_REF ='photoAppFire';

class DatabaseService{
  final _firestore =FirebaseFirestore.instance;

  late final CollectionReference _photoRef;

  DatabaseService() {
    _photoRef =_firestore.collection(PHOTO_APP_REF).withConverter<PhotoApp>(
      fromFirestore: ((snapshots, _) => PhotoApp.fromJson(snapshots.data()!) ), 
      toFirestore:  (photos,_)=> photos.toJson() );
  }
  Stream<QuerySnapshot> getPhotos() {
        return _photoRef.snapshots();
      }
      
      Stream<QuerySnapshot> getPhotosByPhotographer() {
  return _photoRef.orderBy('photographerName',descending: false).snapshots();
}

 Stream<QuerySnapshot> getPhotosByLikes(){ 
  return _photoRef.where('isLiked', isEqualTo: true)
                  .snapshots();
}
Stream<QuerySnapshot> getPhotosByUnLiked( ){
  return _photoRef.where('isLiked', isEqualTo: false)
                  .snapshots();
}

Stream<QuerySnapshot> getPhotosByDateLatest( ){
  return _photoRef.orderBy('createdTime', descending: false)
                  .snapshots();
}




      void addPhotos(PhotoApp photos) async {
        _photoRef.add(photos);
      }

      void updatePhoto (String photoId,PhotoApp photo) {
        _photoRef.doc(photoId).update(photo.toJson());
      }

      void deletePhoto(String photoId) {
        _photoRef.doc(photoId).delete();
      }
}