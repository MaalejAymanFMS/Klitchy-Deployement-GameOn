import 'package:flutter/material.dart';
import 'package:klitchyapp/utils/size_utils.dart';

class WaiterTag extends StatelessWidget {
  final Color backgroundColor;
  final String image;
  final String name;
  const WaiterTag(this.backgroundColor, this.image,this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 175.h,
      height: 48.v,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(39),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 10.h,),
          Container(
            width: 35.h,
            height: 35.v,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(
                Radius.circular(35),
              ),
            ),
            child: Image.asset("assets/images/$image"),
          ),
          SizedBox(width: 30.h,),
          Text(name, style: TextStyle(fontSize: 15.fSize),),
        ],
      ),
    );
  }
}
