import 'package:cloud_firestore/cloud_firestore.dart';
import 'questions.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> postComment(String qid, String text, String name) async {
    try {
      if(text.isNotEmpty)
        {
          String commentID = const Uuid().v1();
          /*await _firestore.collection('questions').doc(questionID).collection('comments').doc(commentID).set(
            {

              'name': name,
              'commentID': commentID,
              'questionID': qid,

            }
            else { print(''); }
          );*/
        }
    } catch(e) {
      print(e.toString(),
      );
    }
  }
}