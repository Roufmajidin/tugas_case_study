import 'package:flutter/material.dart';
import 'package:tugas_case_study/pages/product/adjusment_product.dart';
import 'package:tugas_case_study/pages/product/dashboard.dart';

class NavigationView extends StatefulWidget {
  final int? currentPage;

  const NavigationView({super.key, this.currentPage});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

int currentPageIndex = 0;

class _NavigationViewState extends State<NavigationView> {
  @override
  void initState() {
    super.initState();
    if (widget.currentPage != null) {
      currentPageIndex = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        // ignore: prefer_const_literals_to_create_immutables
        destinations: [
          const NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Home',
              selectedIcon: const Icon(
                Icons.home,
                color: Colors.purple,
              )),
          const NavigationDestination(
              icon: Icon(Icons.book_outlined),
              label: 'Transaction',
              selectedIcon: Icon(
                Icons.book_rounded,
                color: Colors.purple,
              )),
          const NavigationDestination(
              icon: Icon(Icons.book_outlined),
              label: 'Adjusmnent',
              selectedIcon: Icon(
                Icons.book_rounded,
                color: Colors.purple,
              )),
        ],
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
      body: <Widget>[
        const DashboardPage(title: 'Dashboard'),
        const DashboardPage(
          title: 'Dashboard',
        ),
        const AdjusmentView(
          title: 'Adjsument Stock',
        ),
      ][currentPageIndex],
    );
  }
}
