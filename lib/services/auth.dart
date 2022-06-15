/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:sabbar1/models/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  MyUser? _userFromFirebaseUser(User? user)
  {
    return user != null ? MyUser(uid:user.uid):null;

  }

  //change user stream
   Stream<MyUser?> get user {
     return _auth.authStateChanges().map((User? user) => _userFromFirebaseUser(user));
   }

  //anon sign in
  MyUser? _userfromFirebase(User user) {

    return user != null ? MyUser(uid: user.uid) : null;

  }
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();

      User? user = result.user;

      return _userfromFirebase(user!);

    } catch (e){
      print(e.toString());
      return null;

    }
  }
  //email sign in
  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userfromFirebase(user!);
    } catch(e){
      print(e.toString());
      return null;
    }
  }
  //email register
  Future registerWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userfromFirebase(user!);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
        print(e.toString());
        return null;
    }
  }

}
*/