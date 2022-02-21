import 'package:flutter/material.dart';
import 'package:flutter_playout_example/common/utils.dart';

class CircularMaterialButton extends StatelessWidget {
    final Function onPressed;
  final String iconImgPath;
  final Widget iconWidget;
  
  const CircularMaterialButton({Key key, this.onPressed, this.iconImgPath, this.iconWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    double iconBtnContainerHeight = 40;
    double iconBtnContainerWidth = 60;
    Color focusColor = Colors.grey[300];

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: iconBtnContainerWidth,
        height: iconBtnContainerHeight,
        child: MaterialButton(
          focusColor: focusColor,
          color: Theme.of(context).primaryColor,
          shape: CircleBorder(),
          child: 
          Utils.isNullOrEmpty(iconImgPath) ? iconWidget :
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Image.asset(
              iconImgPath,
            ),
          ),
          onPressed: () {
            onPressed();
          },
        ),
      ),
    );
  }

}