
// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutor_me/models/user_chat_model.dart';

class FirebaseHelper {

  static Future<UserModel?> getUserData(String ID) async {
    UserModel? userModel;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('tutors').doc(ID).get();
    if(documentSnapshot.data()!=null){
      userModel = UserModel.fromJson(documentSnapshot.data() as Map<String,dynamic>);
    } 
    return userModel;
  }

  static Future<UserModel?> getTutorData(String ID) async {
    UserModel? userModel;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('tutors').doc(ID).get();
    if(documentSnapshot.data()!=null){
      userModel = UserModel.fromJson(documentSnapshot.data() as Map<String,dynamic>);
    } 
    return userModel;
  }

  static Future<UserModel?> getAnyData(String ID) async {
    UserModel? userModel;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(ID).get();
    if(documentSnapshot.data()!=null){
      userModel = UserModel.fromJson(documentSnapshot.data() as Map<String,dynamic>);
    } else if (documentSnapshot.data()==null) {
      documentSnapshot = await FirebaseFirestore.instance.collection('tutors').doc(ID).get();
      userModel = UserModel.fromJson(documentSnapshot.data() as Map<String,dynamic>);
      return userModel;
    }
    return userModel;
  }
}