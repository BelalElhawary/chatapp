import 'dart:io';

import 'package:chatapp/common/utils/utils.dart';
import 'package:chatapp/features/auth/controller/auth_controller.dart';
import 'package:chatapp/features/group/screens/create_group_screen.dart';
import 'package:chatapp/features/select_contacts/screens/select_contact_screen.dart';
import 'package:chatapp/features/status/screens/status_contacts_screens.dart';
import 'package:chatapp/screens/confirm_status_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/colors.dart';
import 'package:chatapp/features/chat/widgets/contacts_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../features/call/screens/call_pickup_screen.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabController;
  int index = 0;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        {
          ref.read(authControllerProvider).setUserState(true);
          break;
        }
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        {
          ref.read(authControllerProvider).setUserState(false);
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CallPickupScreen(
      scaffold: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: appBarColor,
            centerTitle: false,
            title: const Row(
              children: [
                ImageIcon(AssetImage('assets/icons/logo.png')),
                SizedBox(
                  width: 15,
                ),
                Text(
                  'KnowMe',
                  style: TextStyle(
                    fontSize: 20,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.grey),
                onPressed: () {},
              ),
              PopupMenuButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('Create Group'),
                    onTap: () {
                      Future(
                        () => Navigator.pushNamed(
                          context,
                          CreateGroupScreen.routeName,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          body: TabBarView(
            controller: tabController,
            children: const [
              ContactsList(),
              StatusContactsScreen(),
              Text('calls')
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (index == 0) {
                Navigator.pushNamed(context, SelectContactsScreen.routeName);
              } else {
                File? file = await pickImageFromGallery(context);
                if (file != null && context.mounted) {
                  Navigator.pushNamed(context, ConfirmStatusScreen.routeName,
                      arguments: file);
                }
              }
            },
            backgroundColor: tabColor,
            child: Icon(
              index == 0 ? Icons.numbers : Icons.add,
              color: Colors.white,
            ),
          ),
          bottomNavigationBar: Container(
            margin: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: senderMessageColor,
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: GNav(
                onTabChange: (index) {
                  setState(() {
                    this.index = index;
                  });
                  tabController.index = index;
                },
                backgroundColor: senderMessageColor,
                color: Colors.white,
                activeColor: const Color.fromRGBO(229, 171, 80, 1),
                gap: 8,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                tabs: const [
                  GButton(
                    icon: Icons.chat,
                    text: 'CHATS',
                  ),
                  GButton(
                    icon: Icons.explore,
                    text: 'STATUS',
                  ),
                  GButton(
                    icon: Icons.call,
                    text: 'CALLS',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
