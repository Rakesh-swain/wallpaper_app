import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'full_screen_image.dart';

class WallScreen extends StatefulWidget {
  @override
  State<WallScreen> createState() => _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {
  StreamSubscription<QuerySnapshot>? subscription;
  List<DocumentSnapshot>? wallpapersList;
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("wallpapers");

  @override
  void initState() {
    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        wallpapersList = datasnapshot.docs;
      });
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Wallpaper"),
        ),
        body: wallpapersList != null
            ? SingleChildScrollView(
                child: StaggeredGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    children: List.generate(wallpapersList!.length, (i) {
                      String imgPath = wallpapersList![i]['url'];
                      return Material(
                        elevation: 8.0,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FullScreenImagePage(imgPath)));
                          },
                          child: Hero(
                            tag: imgPath,
                            child: FadeInImage(
                              image: NetworkImage(imgPath),
                              fit: BoxFit.cover,
                              placeholder: const AssetImage("assets/wall.jpg"),
                            ),
                          ),
                        ),
                      );
                    })),
              )
            // MasonryGridView.count(
            //     mainAxisSpacing: 6,
            //     crossAxisSpacing: 6,
            //     crossAxisCount: 2,
            //     itemCount: wallpapersList!.length,
            //     itemBuilder: (context, i) {
            //       String imgPath = wallpapersList![i]['url'];
            //       return Material(
            //         elevation: 8.0,
            //         borderRadius: const BorderRadius.all(Radius.circular(8)),
            //         child: InkWell(
            //           child: Hero(
            //             tag: imgPath,
            //             child: FadeInImage(
            //               image: NetworkImage(imgPath),
            //               fit: BoxFit.cover,
            //               placeholder: const AssetImage("assets/wall.jpg"),
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}
