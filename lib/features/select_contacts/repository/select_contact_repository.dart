import 'package:chatapp/common/utils/utils.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/features/chat/screens/mobile_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectContactsRepositoryProvider = Provider(
  (ref) => SelectContactRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;

      for (var documnet in userCollection.docs) {
        var userData = UserModel.fromMap(documnet.data());

        String selectedPhoneNumber =
            selectedContact.phones[0].number.replaceAll(' ', '');

        if (selectedPhoneNumber == userData.phoneNumber) {
          isFound = true;
          if (context.mounted) {
            Navigator.pushNamed(
              context,
              MobileChatScreen.routeName,
              arguments: {
                'name': userData.name,
                'uid': userData.uid,
              },
            );
          }
        } else {}
      }

      if (!isFound && context.mounted) {
        showSnackBar(
            context: context,
            content: 'This number is not registered on this app.');
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
