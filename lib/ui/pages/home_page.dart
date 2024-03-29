import 'package:chatt/firebaseFunction/activeStatusSender.dart';
import 'package:chatt/ui/pages/profile_page.dart';
import 'package:chatt/ui/pages/recent_conversation.dart.dart';
import 'package:chatt/ui/pages/search_page.dart';
import 'package:flutter/material.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late double _height;
  late double _width;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    IamActive.instance.startSendingData();
    super.initState();
  }

  void dispose() {
    IamActive.instance.stopSendingData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        titleTextStyle: TextStyle(fontSize: 16),
        automaticallyImplyLeading: false,
        title: Center(child: Text("Chatify")),
        bottom: TabBar(
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(
              icon: Icon(
                Icons.people_outline,
                size: 25,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.chat_bubble_outline,
                size: 25,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.person_2_outlined,
                size: 25,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: _tabPages(),
    );
  }

  Widget _tabPages() {
    return TabBarView(controller: _tabController, children: [
      searchPage(_height, _width),
      recentConversation(_height, _width),
      profilePage(_height, _width),
    ]);
  }
}
