import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:flutter/material.dart';
import 'home_content.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  // // TODO: Implement Pagination.
  final Stream<QuerySnapshot> products =
      FirebaseFirestore.instance.collection('products').snapshots();

  @override
  Widget build(BuildContext context) {
    final PreloadPageController pgController = PreloadPageController();

    return StreamBuilder<QuerySnapshot>(
      stream: products,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong.'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        }
        final data = snapshot.requireData;

        // TODO: Implement video pre-loading.
        return PreloadPageView.builder(
          preloadPagesCount: 3,
          controller: pgController,
          scrollDirection: Axis.vertical,
          itemCount: data.size,
          itemBuilder: (context, index) {
            return HomeContent(
              videoUrl: data.docs[index]['videoUrl'],
              productUrl: data.docs[index]['productUrl'],
              productName: data.docs[index]['productName'],
              productDescription: data.docs[index]['productDescription'],
              currency: data.docs[index]['price']['currency'],
              value: data.docs[index]['price']['value'],
              likes: data.docs[index]['likes'],
              saves: data.docs[index]['saves'],
              shares: data.docs[index]['shares'],
            );
          },
        );
      },
    );
  }
}
