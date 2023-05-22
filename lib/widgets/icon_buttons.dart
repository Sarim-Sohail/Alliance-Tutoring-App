import 'package:flutter/material.dart';

class IconDropback extends StatelessWidget {
  const IconDropback({
    Key? key,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      borderRadius: BorderRadius.circular(6.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        splashColor: Colors.orange,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            icon,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class IconOutline extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const IconOutline({
    Key? key,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      splashColor: Colors.orange,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            width: 2,
            color: Colors.black,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            size: 24,
          ),
        ),
      ),
    );
  }
}
