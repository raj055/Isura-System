import 'package:flutter/material.dart';
import 'package:isura_system/widget/theme.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        logo,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "It's been a long journey dedicated towards the well being of our customers. Times change & with changing times we too have come online to serve you better. We provide services in the insurance & financial arena but what we are actually known for are the close bonds that we form with our customers, or rather our family members as we like to refer to them.",
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
