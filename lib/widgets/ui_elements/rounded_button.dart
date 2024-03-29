import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final Icon icon;
  final Function onPressed;

  RoundedButton({
    this.icon,
    @required this.label,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130.0,
      child: this.icon != null
          ? FlatButton.icon(
        color: Colors.greenAccent,
        icon: icon,
        label: Text(label),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        onPressed: onPressed,
      )
          : FlatButton(
        color: Colors.lightBlue,
        child: Text(label),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
