import 'package:b2bmobile/utils/app_constants.dart';
import 'package:flutter/material.dart';

import 'package:b2bmobile/models/business.dart';

class BusinessDetailScreen extends StatelessWidget {
  const BusinessDetailScreen({
    Key? key,
    required this.business,
  }) : super(key: key);
  final Business business;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(business.businessName),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  height: size.height * 0.2,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  business.businessUrl,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ListTile(
                  leading: const Icon(Icons.business),
                  title: Text(
                    business.businessName,
                    style: AppConstants.titleStyle,
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.category,
                        size: 15,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(business.businessCategory),
                    ],
                  ),
                  dense: true,
                  subtitle: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 15,
                      ),
                      Text('Address: ${business.businessAddress}'),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  business.businessDescription,
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Wrap(
                  children: [
                    business.facebook[business.facebook.length - 1] == '/'
                        ? Container()
                        : IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.facebook,
                              size: 40,
                            ),
                          ),
                    business.email.isEmpty
                        ? Container()
                        : IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.mail,
                              size: 40,
                            ),
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
