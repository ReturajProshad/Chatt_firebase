import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final String id;
  final String email;
  final Timestamp lastSeen;
  final String name;
  final String image;

  Contact({
    required this.email,
    required this.id,
    required this.lastSeen,
    required this.name,
    required this.image,
  });

  factory Contact.fromFirestore(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Contact(
      id: snapshot.id,
      email: data["email"],
      lastSeen: data["lastseen"],
      name: data["name"],
      image: data["image"],
    );
  }
}
