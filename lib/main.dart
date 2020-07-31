import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'OnBoarding/data.dart';
import 'OnBoarding/page_indicator.dart';
import 'package:gradient_text/gradient_text.dart';
import 'Login/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'HomePages/mainHome.dart';
import 'package:splashscreen/splashscreen.dart';

void main() => runApp(MaterialApp(
      home: AfterSplash(),
      debugShowCheckedModeBanner: false,
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  PageController _controller;
  int currentPage = 0;
  bool lastPage = false;
  AnimationController animationController;
  Animation<double> _scaleAnimation;
  bool showProgress = true;
  Future<bool> getUser() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    //  _firebaseAuth.signOut();

    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();

    getUser().then((value) {
      if (value) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => new HomeNavigation()));
      } else {
        setState(() {
          showProgress = false;
        });
      }
    });
    _controller = PageController(
      initialPage: currentPage,
    );
    animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _scaleAnimation = Tween(begin: 0.6, end: 1.0).animate(animationController);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: showProgress
            ? Center(
                child: CircularProgressIndicator(),
              )
            : new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  PageView.builder(
                    itemCount: pageList.length,
                    controller: _controller,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                        if (currentPage == pageList.length - 1) {
                          lastPage = true;
                          animationController.forward();
                        } else {
                          lastPage = false;
                          animationController.reset();
                        }
                        print(lastPage);
                      });
                    },
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          var page = pageList[index];
                          var delta;
                          var y = 1.0;

                          if (_controller.position.haveDimensions) {
                            delta = _controller.page - index;
                            y = 1 - delta.abs().clamp(0.0, 1.0);
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                height: 400,
                                child: Image.asset(
                                  page.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 12.0),
                                height: 100.0,
                                child: Stack(
                                  children: <Widget>[
                                    Opacity(
                                      opacity: .10,
                                      child: GradientText(
                                        page.title,
                                        gradient: LinearGradient(
                                            colors:
                                                pageList[index].titleGradient),
                                        style: TextStyle(
                                            fontSize: 70.0,
                                            fontFamily: "Montserrat-Black",
                                            letterSpacing: 1.0),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 30.0, left: 22.0),
                                      child: GradientText(
                                        page.title,
                                        gradient: LinearGradient(
                                            colors:
                                                pageList[index].titleGradient),
                                        style: TextStyle(
                                          fontSize: 30.0,
                                          fontFamily: "Montserrat-Black",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 34.0, top: 12.0),
                                child: Transform(
                                  transform: Matrix4.translationValues(
                                      0, 50.0 * (1 - y), 0),
                                  child: Text(
                                    page.body,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: "Montserrat-Medium",
                                        color: Color(0xFF9B9B9B)),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      );
                    },
                  ),
                  Positioned(
                    left: 30.0,
                    bottom: 55.0,
                    child: Container(
                        width: 160.0,
                        child: PageIndicator(currentPage, pageList.length)),
                  ),
                  Positioned(
                    right: 30.0,
                    bottom: 30.0,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: lastPage
                          ? FloatingActionButton(
                              backgroundColor: Colors.lightBlue,
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new LoginScreen()));
                              },
                            )
                          : Container(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 3,
        navigateAfterSeconds: new MyApp(),
        image: new Image.asset("assets/repair-it.png"),
        backgroundColor: Colors.white,
        photoSize: 100.0,
        loaderColor: Colors.red);
  }
}
