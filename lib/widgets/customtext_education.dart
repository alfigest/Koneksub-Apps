import 'package:flutter/material.dart';
import 'package:waste_application/theme.dart';

class Customtext_education extends StatelessWidget {
  final String? iconPath;
  final String? iconText;
  final String subtitle;
  final String caption;
  final Widget? prefWidget;

  const Customtext_education(
      {Key? key,
      this.iconPath,
      this.iconText,
      required this.subtitle,
      required this.caption,
      this.prefWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // if (iconPath != null)
                    Row(
                      children: [
                        Image.asset(
                          iconPath!,
                          height: 25,
                          width: 25,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            iconText!,
                            style: text_barStyle,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      subtitle,
                      style: TextStyle(
                          color: text_bar,
                          fontSize: MyFontSize.large3,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              if (prefWidget != null) prefWidget!,
            ],
          ),
          SizedBox(height: 10),
          Text(caption, style: text_barStyle),
        ],
      ),
    );
  }
}
