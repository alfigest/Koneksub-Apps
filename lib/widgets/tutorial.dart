import 'package:flutter/material.dart';
import 'package:waste_application/theme.dart';

class Tutorial extends StatefulWidget {
  const Tutorial({Key? key}) : super(key: key);

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      height: 110,
      margin: EdgeInsets.only(
        right: defaultMargin,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: priceColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 22),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cara \nMenggunakan \nAplikasi Koneksub',
                  style: button_TextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
