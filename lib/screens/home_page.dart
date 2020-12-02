import 'package:flutter/material.dart';
import 'package:marca_horario/screens/login.dart';
import 'package:marca_horario/screens/signup.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PageController _pageController = PageController();
  List<Widget> _screen = [SignupScreen(),LoginScreen(),];

  int _selectedIndex = 1;
  void _onPageChanged(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex){
    print(selectedIndex);
    _pageController.jumpToPage(selectedIndex);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screen,
        onPageChanged: _onPageChanged,
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget bottomNavigationBar(){
    return BottomNavigationBar(
      onTap: _onItemTapped,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.person_add, color: _selectedIndex == 0 ? Colors.blue : Colors.grey,),
            label: "Cadastro"
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.person, color: _selectedIndex == 1 ? Colors.blue : Colors.grey,),
            label: "Login"
        ),
      ],
    );
  }
}
