import 'package:flutter/material.dart';
import 'home_content.dart';
import 'product_data.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController pgController = PageController();

    return PageView.builder(
      controller: pgController,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return HomeContent(
          index: index,
          videoUrl: productData[index]['videoUrl'],
          productUrl: productData[index]['productUrl'],
          productName: productData[index]['productName'],
          productDescription: productData[index]['productDescription'],
          currency: productData[index]['currency'],
          priceBig: productData[index]['priceBig'],
          priceSmall: productData[index]['priceSmall'],
          shipping: productData[index]['shipping'],
          taxes: productData[index]['taxes'],
          isLiked: productData[index]['isLiked'],
          likes: productData[index]['likes'],
          isSaved: productData[index]['isSaved'],
          saves: productData[index]['saves'],
          shares: productData[index]['shares'],
        );
      },
      itemCount: productData.length,
    );
  }
}
