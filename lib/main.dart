import 'package:flutter/material.dart';
import 'package:flutter_projects/secondaryPages/add_consultation.dart';
import 'package:flutter_projects/secondaryPages/consultation_list.dart';
import 'package:flutter_projects/secondaryPages/hospitals_list.dart';
import 'package:flutter_projects/utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomePageWidget(),
    );
  }
}

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with SingleTickerProviderStateMixin, RouteAware {
  int _selectedIndex = 0;
  bool _isFabVisible = false;

  late final AnimationController _controller = AnimationController(
    duration:
        const Duration(milliseconds: Constants.standardAnimationDuration + 100),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, -1.2),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  ));

  static const List<Widget> _widgetOptions = <Widget>[
    HospitalsListWidget(),
    ConsultationListWidget()
  ];

  void _onBottomNavItemTapped(int index) {
    setState(() {
      bool canToggle = false;
      if (_selectedIndex != index) {
        canToggle = true;
      }
      _selectedIndex = index;
      if (canToggle) {
        toggleFabVisibility();
      }
    });
  }

  void toggleFabVisibility() {
    if (_isFabVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFabVisible = !_isFabVisible;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: _buildFAB(context),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onBottomNavItemTapped,
      ),
    );
  }

  Widget _buildFAB(context, {key}) => SlideTransition(
        position: _offsetAnimation,
        child: AnimatedOpacity(
          key: key,
          duration: const Duration(
              milliseconds: Constants.standardAnimationDuration - 100),
          opacity: _isFabVisible ? 1.0 : 0.0,
          child: Padding(
            padding: Constants.fabPadding,
            child: SizedBox(
              width: Constants.fabButtonSize,
              height: Constants.fabButtonSize,
              child: FloatingActionButton(
                  backgroundColor: const Color(0xff0055FF),
                  onPressed: () {
                    _onFabTap(context);
                  },
                  child: const Icon(Icons.add)),
            ),
          ),
        ),
      );

  _onFabTap(BuildContext context) {
    setState(() {
      toggleFabVisibility();
    });

    _awaitReturnFromConsultationScreen(context);
  }

  void _awaitReturnFromConsultationScreen(BuildContext context) async {
    const fabSize = Size(Constants.fabButtonSize, Constants.fabButtonSize);
    const fabOffset = Offset.zero;

    final result = await Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration:
            const Duration(milliseconds: Constants.standardAnimationDuration),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddConsultationPageWidget(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            _buildTransition(child, animation, fabSize, fabOffset),
      ),
    );

    setState(() {
      if (result == true) {
        toggleFabVisibility();
      }
    });
  }

  Widget _buildTransition(
    Widget page,
    Animation<double> animation,
    Size fabSize,
    Offset fabOffset,
  ) {
    if (animation.value == 1) return page;

    final borderTween = BorderRadiusTween(
      begin: BorderRadius.circular(fabSize.width / 2),
      end: BorderRadius.circular(0.0),
    );
    final sizeTween = SizeTween(
      begin: fabSize,
      end: MediaQuery.of(context).size,
    );
    final offsetTween = Tween<Offset>(
      begin: fabOffset,
      end: Offset.zero,
    );

    final easeInAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeIn,
    );
    final easeAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    );

    final radius = borderTween.evaluate(easeInAnimation);
    final offset = offsetTween.evaluate(animation);
    final size = sizeTween.evaluate(easeInAnimation);

    final transitionFab = Opacity(
      opacity: 1 - easeAnimation.value,
      child: _buildFAB(context),
    );

    Widget positionedClippedChild(Widget child) => Positioned(
        width: size?.width,
        height: size?.height,
        left: offset.dx,
        top: offset.dy,
        child: ClipRRect(
          borderRadius: radius,
          child: child,
        ));

    return Stack(
      children: [
        positionedClippedChild(page),
        positionedClippedChild(transitionFab),
      ],
    );
  }
}
