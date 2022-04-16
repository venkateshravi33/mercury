import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'product_data.dart';
import 'buy_page.dart';

class HomeContent extends StatefulWidget {
  final int index;
  final String videoUrl;
  final String productUrl;
  final String productName;
  final String productDescription;
  final String currency;
  final String priceBig;
  final String priceSmall;
  final String shipping;
  final String taxes;
  final bool isLiked;
  final String likes;
  final bool isSaved;
  final String saves;
  final String shares;

  const HomeContent({
    Key? key,
    required this.index,
    required this.videoUrl,
    required this.productUrl,
    required this.productName,
    required this.productDescription,
    required this.currency,
    required this.priceBig,
    required this.priceSmall,
    required this.shipping,
    required this.taxes,
    required this.isLiked,
    required this.likes,
    required this.isSaved,
    required this.saves,
    required this.shares,
  }) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late VideoPlayerController _videoController;
  bool isShowPlaying = false;
  bool showPlayPauseIcon = false;

  /// Two local variables are created to store the passed down value.
  /// These variable cannot directly update values in the product data list.
  late bool _isLiked;
  late bool _isSaved;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /// Local instance of like & save are initialised.
    _isLiked = widget.isLiked;
    _isSaved = widget.isSaved;
    _videoController = VideoPlayerController.asset(widget.videoUrl);
    _videoController.initialize().then((value) {
      _videoController.play();
      _videoController.setLooping(true);
      setState(() {
        isShowPlaying = false;
        showPlayPauseIcon = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// The video player.
        videoPlayer(),

        /// Shadow layer to improve bottom text visibility.
        shadowLayer(),

        /// The overlay that displays all the product info.
        informationOverlay(),

        playPauseIcon(),
      ],
    );
  }

  /// Video Player.
  Widget videoPlayer() {
    return VideoPlayer(_videoController);
  }

  /// Shadow layer.
  Widget shadowLayer() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(),
        ),
        Expanded(
          flex: 8,
          child: Container(),
        ),
        Expanded(
          flex: 9,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0),
                  Colors.black.withOpacity(0.35)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Information Overlay.
  Widget informationOverlay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ///1. Top Bar (ratio : 1).
        Expanded(
          flex: 1,
          child: Container(
              // color: Colors.pink,
              ),
        ),

        ///2. Middle Cluster (ratio : 10) - Main Panel, Ratings Tab. (10 : 2)
        Expanded(
          flex: 10,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ///2.1 Main Panel (ratio : 10) - Tap Area, Info Panel (10 : 2).
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ///2.1.1 Tap Area (ratio : 10).
                    Expanded(
                      flex: 10,
                      child: Container(
                        // color: Colors.red,
                        child: GestureDetector(
                          ///Single tap - Pause/Play Video.
                          onTap: () {
                            setState(() {
                              _videoController.value.isPlaying
                                  ? _videoController.pause()
                                  : _videoController.play();
                              showPlayPauseIcon
                                  ? showPlayPauseIcon = false
                                  : showPlayPauseIcon = true;
                            });
                            Future.delayed(
                              const Duration(milliseconds: 1000),
                              () {
                                setState(
                                  () {
                                    showPlayPauseIcon = false;
                                  },
                                );
                              },
                            );
                          },

                          /// Double tap - Like/Unlike Video.
                          onDoubleTap: () {
                            if (_isLiked) {
                              setState(() {
                                /// Local variable is updated.
                                _isLiked = false;

                                /// The change is also made in the product data list by directly accessing it.
                                productData[widget.index]['isLiked'] = false;
                              });
                            } else {
                              setState(() {
                                /// Local variable is updated.
                                _isLiked = true;

                                /// The change is also made in the product data list by directly accessing it.
                                productData[widget.index]['isLiked'] = true;
                              });
                            }
                          },
                        ),
                      ),
                    ),

                    ///2.1.2 Info Panel (ratio : 2).
                    Expanded(
                      flex: 2,
                      child: Container(
                        // color: Colors.orange,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                widget.productName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                widget.productDescription,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              ///2.2 Ratings Tab (ratio : 2).
              Expanded(
                flex: 2,
                child: Container(
                  // color: Colors.blue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /// Like button tap area - single tap to like.
                      GestureDetector(
                        onTap: () {
                          if (_isLiked) {
                            setState(() {
                              /// Local variable is updated.
                              _isLiked = false;

                              /// The change is also made in the product data list by directly accessing it.
                              productData[widget.index]['isLiked'] = false;
                            });
                          } else {
                            setState(() {
                              /// Local variable is updated.
                              _isLiked = true;

                              /// The change is also made in the product data list by directly accessing it.
                              productData[widget.index]['isLiked'] = true;
                            });
                          }
                        },
                        child: _isLiked
                            ? const Icon(
                                Icons.favorite_rounded,
                                size: 35,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border_rounded,
                                // Icons.favorite_rounded,
                                size: 35,
                                color: Colors.white,
                                // color: Colors.pink,
                              ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.likes,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// Save button tap area - single tap to save.
                      GestureDetector(
                        onTap: () {
                          if (_isSaved) {
                            setState(() {
                              /// Local variable is updated.
                              _isSaved = false;

                              /// The change is also made in the product data list by directly accessing it.
                              productData[widget.index]['isSaved'] = false;
                            });
                          } else {
                            setState(() {
                              /// Local variable is updated.
                              _isSaved = true;

                              /// The change is also made in the product data list by directly accessing it.
                              productData[widget.index]['isSaved'] = true;
                            });
                          }
                        },
                        child: _isSaved
                            ? const Icon(
                                Icons.bookmark_rounded,
                                size: 35,
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.bookmark_border_rounded,
                                size: 35,
                                color: Colors.white,
                              ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.saves,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Icon(
                        Icons.share_rounded,
                        size: 35,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.shares,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Icon(
                        Icons.more_horiz_rounded,
                        size: 35,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        ///3. Bottom Bar (ratio : 1) - Price Info, Buy Button. (4 : 2)
        Expanded(
          flex: 1,
          child: Container(
            // color: Colors.purple,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ///3.1 Price Info (ratio : 4).
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.currency,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              widget.priceBig,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              widget.priceSmall,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.shipping,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.taxes,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                ///3.2 Buy Button (ratio : 2).
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 8, bottom: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        _videoController.pause();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BuyPage(
                              productUrl: widget.productUrl,
                              productName: widget.productName,
                            ),
                          ),
                        ).then(
                          (val) {
                            if (val == false) {
                              _videoController.play();
                            }
                          },
                        );
                      },
                      child: const Text(
                        'Buy',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          Colors.blue,
                          // Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Play Pause Icon.
  Widget playPauseIcon() {
    return showPlayPauseIcon
        ? Center(
            child: _videoController.value.isPlaying && !isShowPlaying
                ? Icon(
                    Icons.play_arrow_rounded,
                    size: 100,
                    color: Colors.white.withOpacity(0.75),
                  )
                : Icon(
                    Icons.pause_rounded,
                    size: 100,
                    color: Colors.white.withOpacity(0.75),
                  ),
          )
        : Container();
  }
}
