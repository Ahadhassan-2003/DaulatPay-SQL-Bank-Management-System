import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:daulatpay/Screens/MoreFeatures.dart';
import 'package:daulatpay/Screens/Profile.dart';
import 'package:daulatpay/Screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class Navigation extends StatefulWidget {
  Navigation({
    Key? key,
    required this.AccountNo,
    required this.name,
    required this.cash,
    required this.transactions,
  });

  var AccountNo;
  var cash;
  var name;
  List? transactions;

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  late List<Widget> screens;

  int _currentindex = 0;

  @override
  void initState() {
    super.initState();

    // Initialize the screens list in the constructor body
    screens = [
      CallDashboard(),
      MoreFeatures(),
      Profile(name:widget.name,AccountNo: widget.AccountNo,),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(
        onTap: (value) {
          setState(() {
            _currentindex = value;
          });
        },
        currentIndex: _currentindex,
        items: [
          CustomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            title: Text(
              'Dashboard',
              style: GoogleFonts.openSans(),
            ),
          ),
          CustomNavigationBarItem(
            icon: Icon(Icons.menu_outlined),
            title: Text(
              'More',
              style: GoogleFonts.openSans(),
            ),
          ),
          CustomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            title: Text(
              'Profile',
              style: GoogleFonts.openSans(),
            ),
          ),
        ],
        selectedColor: Colors.blue, // Color when selected
        strokeColor: Colors.blue, // Color of the bar
        unSelectedColor: Colors.grey, // Color when not selected
        iconSize: 30.0, // Size of the icon
        borderRadius: Radius.circular(10.0), // Border radius of the bar/ Width of the icon container
      ),
      body: screens[_currentindex],
    );
  }

  Widget CallDashboard() {
    return Dashboard(
      AccountNo: widget.AccountNo,
      name: widget.name,
      cash: widget.cash,
      transactions: widget.transactions,
    );
  }
}
