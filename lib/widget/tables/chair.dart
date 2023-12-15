import 'package:flutter/material.dart';
import 'package:klitchyapp/utils/size_utils.dart';

class Chair extends StatelessWidget {
  double rotation;

  Chair(this.rotation, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 17.5.h,
        height: 18.v,
        child: Stack(children: <Widget>[
          Positioned(
              top: 0,
              left: 0,
              child: RotationTransition(
                turns: AlwaysStoppedAnimation(rotation / 360),
                child: Container(
                    width: 17.5.h,
                    height: 18.v,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(20),
                      ),
                      color: Color.fromRGBO(39, 45, 75, 1),
                    )),
              )),
          Positioned(
            top: 2.5.v,
            left: 2.h,
            child: Container(
              width: 13.5.h,
              height: 13.5.v,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(81, 87, 118, 1),
                border: Border.all(
                  color: const Color.fromRGBO(124, 133, 175, 1),
                  width: 0.5.h,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(27),
                ),
              ),
            ),
          ),
          Positioned(
            top: 6.v,
            left: 5.5.h,
            child: Text(
              'P1',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: 'SF Pro Display',
                  fontSize: 6.fSize,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                  height: 0.5.v),
            ),
          ),
        ]));
  }
}
