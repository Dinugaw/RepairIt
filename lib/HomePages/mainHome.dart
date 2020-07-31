import 'package:flutter/material.dart';

class HomeNavigation extends StatefulWidget {
  @override
  _HomeNavigationState createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  List<String> items = new List<String>();
  TextEditingController controller = new TextEditingController();
  String filter;
  String type = "Type";

  @override
  initState() {
    items.clear();
    items.add("Carpenter");
    items.add("Construction Worker");
    items.add("Electrician");
    items.add("Painter");
    items.add("Gardener");
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
    @override
    void dispose() {
      controller.dispose();
      super.dispose();
    }
  }

  Widget workerCard(int index) {
    return new Card(
        child: Row(
      children: <Widget>[
        Container(
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: new Image.asset('assets/0.jpeg')),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Text(items[index],
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: "Poppins-Medium",
                  fontSize: 20,
                )),
            // new Text(items[index],
            //     style: TextStyle(
            //       color: Colors.grey,
            //       fontFamily: "Poppins-Medium",
            //       fontSize: 20,
            //     )),
          ],
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.orange,
            centerTitle: true,
            title: Text("Repair It",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Poppins-Medium",
                    fontSize: 25))),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.orange[50],
          currentIndex: 0, // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.home,
                color: Colors.orange,
              ),
              title: new Text("Home",
                  style: TextStyle(
                      color: Colors.grey,
                      fontFamily: "Poppins-Medium",
                      fontSize: 15)),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.mail, color: Colors.orange),
              title: Text("Messages",
                  style: TextStyle(
                      color: Colors.grey,
                      fontFamily: "Poppins-Medium",
                      fontSize: 15)),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person, color: Colors.orange),
                title: new Text("Profile",
                    style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "Poppins-Medium",
                        fontSize: 15)))
          ],
        ),
        body: (new Container(
          padding: const EdgeInsets.all(10),
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.only(top: 20.0),
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 340,
                    child: new TextField(
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontFamily: "Poppins-Medium",
                          fontSize: 18),
                      decoration: new InputDecoration(
                          labelText: "Search for repairmen"),
                      controller: controller,
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.deepOrange[50],
                    onTap: () {},
                    child: Container(
                        height: 50, width: 50, child: Icon(Icons.filter_list)),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
              ),
              Expanded(
                child: new ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return filter == null || filter == ""
                        ? Container(height: 140, child: workerCard(index))
                        : items[index]
                                .toLowerCase()
                                .contains(filter.toLowerCase())
                            ? Container(
                                height: 140,
                                child: workerCard(index),
                              )
                            : new Container();
                  },
                ),
              ),
            ],
          ),
        )));
  }
}
