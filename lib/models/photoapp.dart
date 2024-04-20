import 'package:cloud_firestore/cloud_firestore.dart';

class PhotoApp {
  String photographerName;
  String photoURL;
  String description;
  Timestamp  createdTime;
  bool isLiked;

  PhotoApp({
    required this.photographerName,
    required this.photoURL,
    required this.description,
    required this.createdTime,
    required this.isLiked
  });

  PhotoApp.fromJson(Map<String,Object?>json)
  : this(
    photographerName:json['photographerName'] as String,
    photoURL:json['photoURL'] as String,
    description:json['description'] as String,
    createdTime:json['createdTime'] as Timestamp,
    isLiked:json['isLiked'] as bool,
  );

  PhotoApp copyWith({
    String ? photographerName,
    String ? photoURL,
    String ? description,
    Timestamp ? createdTime,
    bool ? isLiked
  }) {
    return PhotoApp(
      photographerName: photographerName ?? this.photographerName, 
      photoURL: photoURL ?? this.photoURL,
      description: description ?? this.description, 
      createdTime: createdTime ?? this.createdTime, 
      isLiked: isLiked ?? this.isLiked);
  }

  Map<String,Object>toJson(){
    return{

      'photographerName':photographerName,
      'photoURL':photoURL,
      'description':description,
      'createdTime':createdTime,
       'isLiked' :isLiked,
    };
  }
}