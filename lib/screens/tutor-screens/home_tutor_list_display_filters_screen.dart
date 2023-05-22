// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously, unnecessary_cast

import 'package:dropdown_search/dropdown_search.dart';
import "package:flutter/material.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:group_radio_button/group_radio_button.dart';

import '../../../../utilities/addresses.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  final storage = const FlutterSecureStorage();

  String? dropdownValue;
  bool isRadioOnline = false;
  String? radioOnline = 'Online';
  bool isRadioOffline = false;
  String? radioOffline = 'Offline';
  bool isRadioBoth = false;
  String? radioBoth = 'Both';

  bool isQualificationSelected = false;
  bool tutoringModeChanged = false;
  String _groupValue = "Online";
  final _status = ["Online", "Offline (Physical)", "Both"];

  bool verified = false;
  final addressController = TextEditingController();
  final genderController = TextEditingController();
  final List<String> addresses = karachiAreas;

  Map<String, dynamic> filters = {
    'verified': null,
    'gender': null,
    'address': null,
    'qualification': null,
    'mode': null,
    'isFilter': false,
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: const Color(0xFF4ECDE6),
        elevation: 0,
        title: const Text(
          'Filters',
          style: TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            SwitchListTile(
              activeColor: const Color(0xFF4ECDE6),
              title: const Text(
                "Verified",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 19,
                  fontFamily: 'OpenSans',
                ),
              ),
              value: verified,
              subtitle: const Text(
                " * Display only verified tutor",
                style: TextStyle(
                  color: Color.fromARGB(255, 23, 161, 188),
                  fontSize: 14,
                  fontFamily: 'OpenSans',
                ),
              ),
              onChanged: (newValue) {
                setState(() {
                  verified = newValue;
                  filters['verified'] = newValue;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            const Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Text(
                  'Select preferred gender ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.92,
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color.fromARGB(122, 0, 0, 0),
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownSearch<String>(
                dropdownButtonProps: const DropdownButtonProps(
                    color: Colors.grey, icon: Icon(Icons.expand_more)),
                popupProps: PopupProps.menu(
                  constraints: const BoxConstraints(
                    maxHeight: 170,
                  ),
                  showSelectedItems: true,
                  menuProps: MenuProps(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                items: const ['Male', 'Female', 'Rather not specify'],
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  baseStyle: TextStyle(color: Colors.black),
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Gender",
                    icon: Icon(
                      Icons.person_outline_rounded,
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
                onChanged: ((value) {
                  genderController.text = value as String;
                  filters['gender'] = value as String;
                }),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Text(
                  'Select preferred address ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.92,
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color.fromARGB(122, 0, 0, 0),
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownSearch<String>(
                dropdownButtonProps: const DropdownButtonProps(
                    color: Colors.grey, icon: Icon(Icons.expand_more)),
                popupProps: PopupProps.dialog(
                  showSelectedItems: true,
                  showSearchBox: true,
                  dialogProps: DialogProps(
                    backgroundColor:  const Color.fromARGB(255, 255, 255, 255),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  searchFieldProps: const TextFieldProps(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: Colors.grey),
                      hintText: 'Search for areas',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'OpenSans',
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                items: addresses,
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  baseStyle: TextStyle(color: Color(0xFF112F35)),
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Address",
                    icon: Icon(
                      Icons.home_outlined,
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
                onChanged: ((value) {
                  addressController.text = value as String;
                  filters['address'] = value as String;
                }),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Text(
                  'Select preferred qualification ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 20),
              width: MediaQuery.of(context).size.width * 0.92,
              height: MediaQuery.of(context).size.height * 0.06,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color.fromARGB(122, 0, 0, 0),
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: isQualificationSelected ? dropdownValue : null,
                  hint: const Text(
                    'Select Qualification',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'OpenSans',
                  ),
                  dropdownColor: Colors.white,
                  icon: const Icon(Icons.expand_more, color: Colors.grey),
                  items: <String>[
                    'Matric',
                    'Intermediate',
                    'Bachelors',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 15),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      isQualificationSelected = true;
                      dropdownValue = newValue!;
                      filters['qualification'] = newValue as String;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Text(
                  'Select preferred tutoring mode ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.87,
              height: MediaQuery.of(context).size.height * 0.06,
              child: RadioGroup<String>.builder(
                direction: Axis.horizontal,
                groupValue: _groupValue,
                horizontalAlignment: MainAxisAlignment.spaceEvenly,
                onChanged: (value) => setState(() {
                  tutoringModeChanged = true;
                  _groupValue = value ?? '';
                  filters['mode'] = value as String;
                }),
                items: _status,
                textStyle: const TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                ),
                fillColor: const Color(0xFF4ECDE6),
                itemBuilder: (item) => RadioButtonBuilder(
                  item,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF60D2E9),
                minimumSize: Size(
                  MediaQuery.of(context).size.width * 0.5,
                  50,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(color: Color(0xFF60D2E9)),
                ),
              ),
              onPressed: () async {
                if (filters['verified'] == null &&
                    filters['gender'] == null &&
                    filters['address'] == null &&
                    filters['qualification'] == null &&
                    filters['mode'] == null) {
                  filters['isFilter'] = false;
                } else {
                  filters['isFilter'] = true;
                }
                Navigator.pop(context, filters);
              },
              child: const Text(
                "Apply Filters",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Righteous',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
