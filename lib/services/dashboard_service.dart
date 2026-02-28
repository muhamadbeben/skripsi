import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class DashboardService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> fetchUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(user.uid).get();

        if (!doc.exists) {
          final queryByEmail = await _firestore
              .collection('users')
              .where('email', isEqualTo: user.email)
              .limit(1)
              .get();

          if (queryByEmail.docs.isNotEmpty) {
            doc = queryByEmail.docs.first;
          }
        }

        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'role': data['role'] ?? 'santri',
            'nama': data['nama'] ?? 'User',
            'uid': user.uid,
          };
        } else {
          debugPrint("Data user tidak ditemukan.");
          return null;
        }
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      throw e;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint("Error signing out: $e");
      rethrow;
    }
  }
}
