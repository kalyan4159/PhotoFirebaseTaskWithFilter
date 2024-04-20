import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_app_firebase/models/photoapp.dart';
import 'package:photo_app_firebase/pages/homepage.dart';
import 'package:photo_app_firebase/services/database_service.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formkey = GlobalKey<FormState>();

   final DatabaseService _databaseServicess=DatabaseService();

  
  TextEditingController nameController = TextEditingController();
  TextEditingController imageURLController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

 
  @override
  Widget build(BuildContext context) {
   
     Color myOrangeColor = Color(0xFFF68F50);
    double textWidthSize = 150;
    double boxWidth=300;

    return  SingleChildScrollView(
           child: Builder(
             builder: (context) {
               return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(color: Colors.grey, width: 2.0),
                      ),
                       title: Center(
               
                        child: Text('Add Photo',style: TextStyle( fontSize: 18,fontWeight: FontWeight.w900, ),),
                     
                       ),
                       content:  Form(
                        child: SizedBox(
                           width: boxWidth,
                           child: Column(
                            children: [
                             
                             
                              Padding(
                                padding: const EdgeInsets.only(top:8.0),
                                child: Row(
                                  children: [
                                    SizedBox(width: textWidthSize, child: const Text('Photographer\'s Name',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),)),
                                    Expanded(
                                      child: TextFormField(
                                controller: nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Something';
                                  } else if (RegExp(r'[0-9]').hasMatch(value)) {
                                    return 'Numbers are not allowed';
                                  }
                                  return null;
                                },
                                 decoration:  InputDecoration(
                                 
                                  contentPadding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
                                  hintText: 'Enter text',
                                  hintStyle: TextStyle(color:  Colors.grey.withOpacity(0.5)),
                                  enabledBorder: OutlineInputBorder(
                                     borderSide:  BorderSide(color: Colors.grey.withOpacity(0.5),),
                                  ),
                                  isDense: true,
                                ),
                                minLines: 1,
                                maxLines: 1,
                                                        ),
                                    )
                                
                                  ],
                                ),
                              ),
               
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                                    children: [
                                                      SizedBox(width: textWidthSize, child: const Text('Image URL',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),)),
                                                      Expanded(
                                                        child: TextFormField(
                                controller: imageURLController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Something';
                                  }
                                  return null;
                                },
                                 decoration:  InputDecoration(
                                 
                                  contentPadding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
                                  hintText: 'Enter text',
                                  hintStyle: TextStyle(color:  Colors.grey.withOpacity(0.5)),
                                  enabledBorder: OutlineInputBorder(
                                     borderSide:  BorderSide(color: Colors.grey.withOpacity(0.5),),
                                  ),
                                  isDense: true,
                                ),
                                minLines: 1,
                                maxLines: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                              ),
               
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  bottom: 20,
                                ),
                                child: Row(
                                                    children: [
                                                      SizedBox(width: textWidthSize, child: Text('Description',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),)),
                                                      Expanded(
                                                        child: TextFormField(
                                controller: descriptionController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Something';
                                  }
                                  return null;
                                },
                                decoration:  InputDecoration(
                                 
                                  contentPadding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
                                  hintText: 'Enter text',
                                  hintStyle: TextStyle(color:  Colors.grey.withOpacity(0.5)),
                                  enabledBorder: OutlineInputBorder(
                                     borderSide:  BorderSide(color: Colors.grey.withOpacity(0.5),),
                                  ),
                                  isDense: true,
                                ),
                                minLines: 1,
                                maxLines: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                              ),
               
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    MaterialButton(
                                      onPressed: () {
                              Navigator.of(context).pop();
                            },
                          
                            color: Color(0xffff6d00),
                            padding: EdgeInsets.only(left:40,right:40,top:14,bottom:14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              
                            ),
                            child: Text(
                              'CANCEL',
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),
                            ),
                                    
                                     ),
                                    const SizedBox(width: 8.0),
                                    MaterialButton(onPressed: (){
                                      
                                         String photographerName = nameController.text;
                                  String imageURL = imageURLController.text;
                                  String description = descriptionController.text;
               
                                  PhotoApp photoOne=PhotoApp(photographerName: photographerName, photoURL: imageURL, description: description, createdTime: Timestamp.now(), isLiked: false);
                                  _databaseServicess.addPhotos(photoOne);
                                   Navigator.of(context).pop();
                                   nameController.clear();
                                   imageURLController.clear();
                                   descriptionController.clear();
               
                                       
                                    },
                                    color: Color(0xffff6d00),
                            padding: EdgeInsets.only(left:50,right: 50,top:14,bottom:14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                              child: Text('Add',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
               
                            
                                                           ),
                                ],
                              ),
                               
                            ],
                            
                           ),
               
                        ),
                       
                       ),
               
               
               );
             }
           ),
       

    );
  }
}