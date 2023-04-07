import 'package:b2bmobile/Screens/admin_panel/all_feedback.dart';
import 'package:b2bmobile/Screens/admin_panel/event%20request%20/event_request_screen.dart';
import 'package:b2bmobile/Screens/admin_panel/manage_users.dart';
import 'package:b2bmobile/Screens/verification%20request/verification_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:b2bmobile/Screens/admin_panel/all_businesses.dart';
import 'package:get/get.dart';

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
        title: const Text("Admin Panel"),
      ),
      body: Wrap(
        //  shrinkWrap: true,
        children: [
          InkWell(
            onTap: () {
              Get.to(() => const VerificationScreen());
            },
            child: SizedBox(
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
                builder: (context) => const BusinessAll(),
              ));
            },
            child: SizedBox(
              width: width * 0.4,
              height: height * 0.15,
              child: const Card(
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
            child: SizedBox(
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
            onTap: () {
              Get.to(() => const EventRequestScreen());
            },
            child: SizedBox(
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
            child: SizedBox(
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
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ManageUsers(),
              ),
            ),
            child: SizedBox(
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
            child: SizedBox(
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
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AllFeedback(),
              ),
            ),
            child: SizedBox(
              width: width * 0.4,
              height: height * 0.15,
              child: const Card(
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
            child: SizedBox(
              width: width * 0.4,
              height: height * 0.15,
              child: const Card(
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
            child: SizedBox(
              width: width * 0.4,
              height: height * 0.15,
              child: const Card(
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
  const AllBusinesses({super.key});

  @override
  _AllBusinessesState createState() => _AllBusinessesState();
}

class _AllBusinessesState extends State<AllBusinesses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Businesses",
        ),
      ),
    );
  }
}
