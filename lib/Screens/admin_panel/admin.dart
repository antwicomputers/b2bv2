import 'package:b2bmobile/models/business.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Admin Panel"),
      ),
      body: Wrap(
        //  shrinkWrap: true,
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              width: width * 0.4,
              height: height * 0.15,
              child: const Card(
                child: Center(
                    child: Text(
                  "Verification \nRequests",
                  textAlign: TextAlign.center,
                )),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AllBusinesses(),
              ));
            },
            child: Container(
              width: width * 0.4,
              height: height * 0.15,
              child: Card(
                child: Center(
                    child: Text(
                  "All \nBusinesses",
                  textAlign: TextAlign.center,
                )),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              width: width * 0.4,
              height: height * 0.15,
              child: const Card(
                child: Center(
                    child: Text(
                  "Manage Categories",
                  textAlign: TextAlign.center,
                )),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              width: width * 0.4,
              height: height * 0.15,
              child: const Card(
                child: Center(
                    child: Text(
                  "Event Requests",
                  textAlign: TextAlign.center,
                )),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              width: width * 0.4,
              height: height * 0.15,
              child: const Card(
                child: Center(
                    child: Text(
                  "All events",
                  textAlign: TextAlign.center,
                )),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              width: width * 0.4,
              height: height * 0.15,
              child: const Card(
                child: Center(
                    child: Text(
                  "Manage Users",
                  textAlign: TextAlign.center,
                )),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              width: width * 0.4,
              height: height * 0.15,
              child: const Card(
                child: Center(
                    child: Text(
                  "Assign Business Owners",
                  textAlign: TextAlign.center,
                )),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              width: width * 0.4,
              height: height * 0.15,
              child: Card(
                child: Center(
                    child: Text(
                  "All Feedback",
                  textAlign: TextAlign.center,
                )),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              width: width * 0.4,
              height: height * 0.15,
              child: Card(
                child: Center(
                    child: Text(
                  "Send Alert",
                  textAlign: TextAlign.center,
                )),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              width: width * 0.4,
              height: height * 0.15,
              child: Card(
                child: Center(
                    child: Text(
                  "Fix Locations",
                  textAlign: TextAlign.center,
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AllBusinesses extends StatefulWidget {
  @override
  _AllBusinessesState createState() => _AllBusinessesState();
}

class _AllBusinessesState extends State<AllBusinesses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Businesses",
        ),
      ),
    );
  }
}
