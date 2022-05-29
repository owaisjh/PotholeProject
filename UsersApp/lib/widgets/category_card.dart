import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:final_year/constants.dart';

class CategoryCard extends StatefulWidget {
  final String svgSrc;
  final String title;
  final VoidCallback press;
  final String imagePath;
  CategoryCard({
    required this.svgSrc,
    required this.title,
    required this.press,
    required this.imagePath,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        // padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 17),
              blurRadius: 17,
              spreadRadius: -23,
              color: kShadowColor,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.press,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Spacer(),
                  // SvgPicture.asset(
                  //   widget.svgSrc,
                  //   height: 50,
                  //   width: 50,
                  // ),
                  Image.asset(widget.imagePath),
                  Spacer(),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    // style: Theme.of(context)
                    //     .textTheme
                    //     .title
                    //     .copyWith(fontSize: 15),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
