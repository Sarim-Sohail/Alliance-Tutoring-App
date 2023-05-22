// ignore_for_file: unnecessary_new, prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, unnecessary_this

import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool? value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 65,
        backgroundColor: Colors.white,
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Lato',
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recieve Push Notifications',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Lato',
                    fontSize: 17,
                  ),
                ),
                Checkbox(
                  fillColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.white;
                    }
                    return Colors.black;
                  }),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  value: this.value,
                  onChanged: (bool? value) {
                    setState(() {
                      this.value = value;
                    });
                  },
                ),
              ],
            ),
          ),
          if (value == true)
            (Divider(
              color: Colors.grey,
            )),
          if (value == true)
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Set notification ringtone',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Lato',
                          fontSize: 17,
                        ),
                      ),
                      const Text(
                        'Arrow',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Lato',
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * 1,
                      MediaQuery.of(context).size.height * 0.05,
                    ),
                    elevation: 0,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ],
            ),
          if (value == true)
            Divider(
              color: Colors.grey,
            ),
          if (value == true)
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Set call tone',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Lato',
                          fontSize: 17,
                        ),
                      ),
                      const Text(
                        'Classic bell',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Lato',
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * 1,
                      MediaQuery.of(context).size.height * 0.05,
                    ),
                    elevation: 0,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ],
            ),
          if (value == true)
            Divider(
              color: Colors.grey,
            ),
        ],
      ),
    );
  }
}
