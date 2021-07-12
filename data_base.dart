import 'package:cloud_firestore/cloud_firestore.dart';

class DataBase {
  static addJob(String name, int age, List<String> skills, String date,
      String location) async {
    CollectionReference jobs = FirebaseFirestore.instance.collection('jobs');
    Map<String, dynamic> jobData = {
      'name': name,
      'age': age,
      'skills': skills,
      'date': date,
      'location': location
    };

    await jobs.add(jobData);
  }
}
