import 'package:flutter/material.dart';

import '../../styles&text&sizes/colors.dart';
import '../../styles&text&sizes/text_strings.dart';


class TFormDivider extends StatelessWidget {
  const TFormDivider({
    super.key, required this.dividerText,
  });

  final String dividerText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
            child: Divider(
                color: TColors.darkGrey,
                thickness: 0.5,
                indent: 60,
                endIndent: 5)),
        Text(dividerText,
            style: Theme.of(context).textTheme.labelMedium),
        Flexible(
            child: Divider(
                color: TColors.darkGrey,
                thickness: 0.5,
                indent: 5,
                endIndent: 60)),
      ],
    );
  }
}
