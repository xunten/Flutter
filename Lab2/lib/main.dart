import 'package:flutter/material.dart';

void main() {
  runApp(myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.teal,
        body: SafeArea(
          child: Column(
            // verticalDirection: VerticalDirection.up,
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Container(
              //   height: 100.0,
              //   width: 100.0,
              //   // margin: const EdgeInsets.only(
              //   //     left: 20.0), //thiet lap khoang cach xung quanh 1 widget
              //   // padding: const EdgeInsets.all(20.0),
              //   color: Colors.white,
              //   child: const Text('Container1'),
              // ),
              // SizedBox(
              //   height: 20.0,
              // ),
              // Container(
              //   width: 100.0,
              //   height: 100.0,
              //   color: Color.fromARGB(255, 114, 187, 46),
              //   child: const Text('Container2'),
              // ),
              // Container(
              //   width: 100.0,
              //   height: 100.0,
              //   color: const Color.fromARGB(255, 176, 106, 106),
              //   child: const Text('Container2'),
              // ),

              const CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('images/11.jpg'),
              ),
              const Text(
                'Angela Yu',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Pacifico'),
              ),
              const Text(
                'Developer Flutter',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.0,
                    wordSpacing: 10.0,
                    color: Color.fromARGB(255, 228, 228, 221),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Time New Roman'),
              ),
              SizedBox(
                height: 20.0,
                width: 1000.0,
                child: Divider(
                  color: Colors.teal.shade100,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(3.0),
                color: Colors.white,
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 25.0),
                child: const Row(
                  children: <Widget>[
                    Icon(
                      Icons.phone,
                      size: 50.0,
                      color: Color.fromARGB(255, 77, 207, 172),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text('+44 123 4567 8901'),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(3.0),
                color: Colors.white,
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 25.0),
                child: const Row(
                  children: <Widget>[
                    Icon(
                      Icons.email,
                      size: 50.0,
                      color: Color.fromARGB(255, 61, 196, 187),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text('angela@email.com'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
    ;
  }
}
