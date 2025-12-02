import 'package:flutter/material.dart';

class CommoditiesGrid extends StatelessWidget {
  final List<Map<String, String>> commodities = [
    {'name': 'Rice', 'icon': '🌾'},
    {'name': 'Corn', 'icon': '🌽'},
    {'name': 'Grapes', 'icon': '🍇'},
    {'name': 'Potato', 'icon': '🥔'},
    {'name': 'Olive', 'icon': '🫒'},
  ];

  CommoditiesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
      ),
      itemCount: commodities.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              height: h * 0.06,
              width: w * 0.15,
              decoration: BoxDecoration(
                color: Color(0xff01342C),
                borderRadius:
                    index.isEven
                        ? BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )
                        : BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
              ),
              child: Center(
                child: Text(
                  commodities[index]['icon']!,
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            Text(
              commodities[index]['name']!,
              style: TextStyle(fontSize: 15, color: Color(0xff01342C)),
            ),
          ],
        );
      },
    );
  }
}
