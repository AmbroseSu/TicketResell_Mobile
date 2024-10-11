import 'package:flutter/material.dart';

import '../styles&text&sizes/colors.dart';
import 'curved_edges_widget.dart';
import 'login_signup/circular_container.dart';


class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return
      TCurvedEdgeWidget(
      child: Container(
        // color: Color(0xFF55B97D),
        color: TColors.primary,
        child: Stack(
          children: [
            Positioned(top: -150, right: -250,
                child: TCircularContainer(backgroundColor: TColors.textWhite.withOpacity(0.2))
            ),
            Positioned(top: 100, right: 300,
                child: TCircularContainer(backgroundColor: TColors.textWhite.withOpacity(0.2))
            ),
            child,
          ],
        ),
      ),
    );
  }
}