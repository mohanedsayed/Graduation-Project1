import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info/package_info.dart';

class AuthHelper {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static signInWithEmail({String email, String password}) async {
    final res = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    final User user = res.user;
    return user;
  }

  static signUpWithEmail({String email, String password}) async {
    final res = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final User user = res.user;
    return user;
  }

  static signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    final acc = await googleSignIn.signIn();
    final auth = await acc.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    final res = await _auth.signInWithCredential(credential);
    return res.user;
  }

  static logOut() {
    GoogleSignIn().signOut();
    return _auth.signOut();
  }
}

class UserHelper {
  static FirebaseFirestore _db = FirebaseFirestore.instance;

  static saveUser(User user) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);
    Map<String, dynamic> userData = {
      "name": user.displayName,
      "email": user.email,
      "role": "",
      "last_login": user.metadata.lastSignInTime.millisecondsSinceEpoch,
      "created_at": user.metadata.creationTime.millisecondsSinceEpoch,
      "build_number": buildNumber,
    };

    final userRef = _db.collection('users').doc(user.uid);
    if ((await userRef.get()).exists) {
      await userRef.update({
        'last_login': user.metadata.lastSignInTime.millisecondsSinceEpoch,
        'build_number': buildNumber,
      });
    } else {
      await userRef.set(userData);
    }
    await _saveDevice(user);
  }

  static UpdateUserRole(User user, String role) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);
    Map<String, dynamic> userData = {
      "name": user.displayName,
      "email": user.email,
      "role": role,
      "last_login": user.metadata.lastSignInTime.millisecondsSinceEpoch,
      "created_at": user.metadata.creationTime.millisecondsSinceEpoch,
      "build_number": buildNumber,
    };

    final userRef = _db.collection('users').doc(user.uid);
    if ((await userRef.get()).exists) {
      await userRef.update({
        'role': role,
        'last_login': user.metadata.lastSignInTime.millisecondsSinceEpoch,
        'build_number': buildNumber,
      });
    } else {
      await userRef.set(userData);
    }
    await _saveDevice(user);
  }

  static _saveDevice(User user) async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String deviceId;
    Map<String, dynamic> deviceData;
    if (Platform.isAndroid) {
      final deviceInfo = await deviceInfoPlugin.androidInfo;
      deviceId = deviceInfo.androidId;
      deviceData = {
        "os_version": deviceInfo.version.sdkInt.toString(),
        "platform": "android",
        "model": deviceInfo.model,
        "device": deviceInfo.device,
      };
    }
    if (Platform.isIOS) {
      final deviceInfo = await deviceInfoPlugin.iosInfo;
      deviceId = deviceInfo.identifierForVendor;
      deviceData = {
        "os_version": deviceInfo.systemVersion,
        "platform": "ios",
        "model": deviceInfo.model,
        "device": deviceInfo.name,
      };
    }
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final deviceRef = _db
        .collection("users")
        .doc(user.uid)
        .collection("devices")
        .doc(deviceId);
    if ((await deviceRef.get()).exists) {
      await deviceRef.update({
        "updated_at": nowMs,
        "uninstalled": false,
      });
    } else {
      await deviceRef.set({
        "updated_at": nowMs,
        "uninstalled": false,
        "id": deviceId,
        "created_at": nowMs,
        "device_info": deviceData,
      });
    }
  }
}
