import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isura_system/screens/auth/authentications.dart';
import 'package:isura_system/services/auth.dart';
import 'package:isura_system/widget/theme.dart';
import 'package:unicons/unicons.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final List<Entry> data = <Entry>[
    Entry("test", {'icon': Icons.smartphone, 'page': ''}),
    Entry("Dashboard", {'icon': UniconsLine.home, 'page': 'home'}),
    Entry(
      "Tax Benefits",
      {'icon': UniconsLine.percentage, 'page': 'tax-benefits'},
    ),
    if (Auth.userEmail() == "raj@gmail.com") ...[
      Entry(
        "Services",
        {'icon': UniconsLine.servers, 'page': 'policy-list'},
      ),
    ],
    Entry(
      "Your Policy",
      {'icon': UniconsLine.servers, 'page': 'selected-policy'},
    ),
    Entry(
      "About Us",
      {'icon': UniconsLine.android_alt, 'page': 'about-us'},
    ),
    Entry(
      "Logout",
      {
        'icon': UniconsLine.power,
        'page': 'logout',
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Column(
                children: <Widget>[
                  _buildUserSidebarInfo(context),
                ],
              );
            } else {
              return EntryItem(data[index]);
            }
          },
        ),
      ),
    );
  }

  Widget _buildUserSidebarInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 20),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
        decoration: new BoxDecoration(
          color: Colors.blue,
          borderRadius: new BorderRadius.only(
            bottomRight: const Radius.circular(50.0),
            topRight: const Radius.circular(50.0),
          ),
        ),
        /*User Profile*/
        child: Row(
          children: <Widget>[
            CircleAvatar(
              child: Icon(
                UniconsLine.user,
                size: 30,
                color: app_background,
              ),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      Auth.userEmail() ?? "",
                    ),
                    // SizedBox(height: 8),
                    // Text(
                    //   "9999999999",
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Draw {
  final String title;
  final IconData icon;

  Draw({
    this.title,
    this.icon,
  });
}

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, this.data, [this.children = const <Entry>[]]);

  final String title;
  final Map data;
  final List<Entry> children;
}

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatefulWidget {
  const EntryItem(this.entry);

  final Entry entry;

  @override
  _EntryItemState createState() => _EntryItemState();
}

class _EntryItemState extends State<EntryItem> {
  bool _expanded = false;

  Widget _buildTiles(Entry root, {int depth = 0}) {
    if (root.children.isEmpty) {
      return Padding(
        padding: depth > 0 ? EdgeInsets.only(left: 15.0) : EdgeInsets.all(0),
        child: ListTile(
          leading: Icon(
            root.data['icon'],
            color: Colors.black,
          ),
          onTap: () {
            if (root.title == 'Logout') {
              Auth.logout();
              signOutUser();
              Get.offAllNamed('sign-in');
            } else {
              Get.back();
              setState(() {
                _expanded = false;
              });
              Get.toNamed(root.data['page']);
            }

            if (root.data.containsKey('callback')) {
              root.data['callback']();
            }
          },
          title: text(
            root.title,
            fontSize: textSizeLargeMedium,
            fontFamily: fontMedium,
            textColor: Colors.black,
          ),
        ),
      );
    }

    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: text(
        root.title,
        fontSize: textSizeLargeMedium,
        fontFamily: fontMedium,
        textColor: textColorPrimary,
      ),
      initiallyExpanded: _expanded,
      children: root.children.map((child) {
        return _buildTiles(child, depth: depth + 1);
      }).toList(),
      onExpansionChanged: (expanded) => setState(() => _expanded = expanded),
      trailing: Icon(
        _expanded ? Icons.expand_less : Icons.expand_more,
        color: colorPrimary,
      ),
      leading: Icon(
        root.data['icon'],
        color: colorPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildTiles(widget.entry),
    );
  }
}
