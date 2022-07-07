import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'buy_page.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:expandable_text/expandable_text.dart';
import 'custom_icons_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:numeral/numeral.dart';
import 'package:random_string/random_string.dart';

class HomeContent extends StatefulWidget {
  final String videoUrl;
  final String productUrl;
  final String productName;
  final String productDescription;
  final String currency;
  final num value;
  final num likes;
  final num saves;
  final num shares;

  const HomeContent({
    Key? key,
    required this.videoUrl,
    required this.productUrl,
    required this.productName,
    required this.productDescription,
    required this.currency,
    required this.value,
    required this.likes,
    required this.saves,
    required this.shares,
  }) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late VideoPlayerController _videoController;
  late String key = 'temp';
  bool showPlayIcon = false;

  /// Two local variables are created to store the passed down value.
  /// These variable cannot directly update values in the product data list.
  bool _isLiked = false;
  bool _isSaved = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /// Video player is initialised.
    _videoController = VideoPlayerController.network(widget.videoUrl);
    _videoController.initialize().then((value) {
      _videoController.setLooping(true);
      if (mounted) {
        setState(() {
          key = randomAlphaNumeric(10);
          showPlayIcon = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      onVisibilityChanged: (VisibilityInfo visibilityInfo) {
        if (visibilityInfo.visibleFraction == 1) {
          _videoController.play();
        } else if (visibilityInfo.visibleFraction == 0) {
          _videoController.pause();
          setState(() {
            showPlayIcon = false;
          });
        }
      },
      key: Key(key),
      child: Stack(
        children: [
          /// The video player.
          _videoController.value.isInitialized
              ? videoPlayer()
              : videoLoadingIndicator(),

          /// To improve visibility on case any buttons or text needed to be added on top.
          // topShadowLayer(),

          /// Shadow layer to improve bottom text visibility.
          bottomShadowLayer(),

          ///Play/Pause Icon.
          playIcon(),

          /// Gesture Detector to identify inputs.
          tapDetector(),

          /// The overlay that displays all the product info.
          informationOverlay(),
        ],
      ),
    );
  }

  /// Video Player.
  Widget videoPlayer() {
    return Container(
      color: Colors.black,
      child: VideoPlayer(_videoController),
    );
  }

  /// Loading screen until the video is initialised.
  Widget videoLoadingIndicator() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  /// Top Shadow layer.
  Widget topShadowLayer() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.3),
            Colors.transparent,
          ],
          begin: const Alignment(0, -0.75),
          end: const Alignment(0, 0.1),
        ),
      ),
    );
  }

  /// Bottom Shadow layer.
  Widget bottomShadowLayer() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.3),
            Colors.transparent,
          ],
          end: const Alignment(0, -0.75),
          begin: const Alignment(0, 0.1),
        ),
      ),
    );
  }

  /// Gesture Detector.
  Widget tapDetector() {
    return GestureDetector(
      ///Single tap - Pause/Play Video.
      onTap: () {
        setState(() {
          if (_videoController.value.isPlaying) {
            _videoController.pause();
            showPlayIcon = true;
          } else {
            _videoController.play();
            showPlayIcon = false;
          }
        });
      },

      /// Double tap - Like/Unlike Video.
      onDoubleTap: () {
        if (!_isLiked) {
          setState(() {
            /// Local variable is updated.
            _isLiked = true;

            /// The change is also made in the product data list by directly accessing it.
            // productData[widget.index]['isLiked'] = true;
          });
        }
      },
    );
  }

  /// Information Overlay.
  Widget informationOverlay() {
    return Column(
      children: [
        ///1. Top Bar (ratio : 1) - place holder.
        Expanded(
          flex: 1,
          child: Container(),
        ),

        ///2. Middle Cluster (ratio : 10) - Product name & description Panel, Ratings Tab. (8 : 2)
        Expanded(
          flex: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///2.1 Product name & description Panel (ratio : 8).
                  Expanded(
                    flex: 10,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Product Name.
                          Text(
                            widget.productName,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 5),

                          /// Product Description.
                          ExpandableText(
                            widget.productDescription,
                            animation: true,
                            animationDuration:
                                const Duration(milliseconds: 500),
                            expandText: ' ',
                            expandOnTextTap: true,
                            collapseOnTextTap: true,
                            maxLines: 1,
                            linkColor: Colors.white,
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

                  ///2.2 Ratings Tab (ratio : 2).
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        /// 1. Like button tap area - single tap to like.
                        likeButton(),
                        const SizedBox(height: 2),
                        Center(
                          child: Text(
                            Numeral(widget.likes).format(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        /// 2. Save button tap area - single tap to save.
                        saveButton(),
                        const SizedBox(height: 2),
                        Center(
                          child: Text(
                            Numeral(widget.saves).format(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        /// 3. Implement Share button tap area - single tap to share.
                        shareButton(),
                        const SizedBox(height: 2),
                        Center(
                          child: Text(
                            Numeral(widget.shares).format(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        /// 4. Implement Options button tap area - single tap to open options.
                        optionsButton(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),

        ///3. Bottom Bar (ratio : 1) - Buy button with price.
        Expanded(
          flex: 1,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
            child: ElevatedButton(
              onPressed: () {
                /// Video is paused on button press.
                _videoController.pause();

                /// The web page of the product is pushed.
                Navigator.push(
                  context,
                  SlideLeftRoute(
                    page: BuyPage(
                      productUrl: widget.productUrl,
                      productName: widget.productName,
                    ),
                  ),
                ).then(
                  /// Video is played after the web page is popped.
                  (val) {
                    if (val == false) {
                      _videoController.play();
                    }
                  },
                );
              },

              /// Text content inside button.
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shop Now / ' + widget.currency + widget.value.toString(),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                  ),
                ],
              ),

              /// Styling of button.
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                  Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Like Button.
  Widget likeButton() {
    return GestureDetector(
      onTap: () {
        if (_isLiked) {
          setState(() {
            /// Local variable is updated.
            _isLiked = false;

            /// The change is also made in the product data list by directly accessing it.
            // productData[widget.index]['isLiked'] = false;
          });
        } else {
          setState(() {
            /// Local variable is updated.
            _isLiked = true;

            /// The change is also made in the product data list by directly accessing it.
            // productData[widget.index]['isLiked'] = true;
          });
        }
      },
      child: _isLiked
          ? const Icon(
              Icons.favorite,
              size: 35,
              color: Colors.red,
            )
          : const Icon(
              Icons.favorite_border,
              // Icons.favorite_rounded,
              size: 35,
              color: Colors.white,
              // color: Colors.pink,
            ),
    );
  }

  /// Save Button
  Widget saveButton() {
    return GestureDetector(
      onTap: () {
        if (_isSaved) {
          setState(() {
            /// Local variable is updated.
            _isSaved = false;

            /// The change is also made in the product data list by directly accessing it.
            // productData[widget.index]['isSaved'] = false;
          });
        } else {
          setState(() {
            /// Local variable is updated.
            _isSaved = true;

            /// The change is also made in the product data list by directly accessing it.
            // productData[widget.index]['isSaved'] = true;
          });
        }
      },
      child: _isSaved
          ? const Icon(
              Icons.bookmark,
              size: 35,
              color: Colors.white,
            )
          : const Icon(
              Icons.bookmark_border,
              size: 35,
              color: Colors.white,
            ),
    );
  }

  /// Share Button
  Widget shareButton() {
    return GestureDetector(
      onTap: () {
        /// The Shared change is also made in the product data list by directly accessing it.
        // productData[widget.index]['isShared'] = true;
        Share.share(widget.productUrl);
      },
      child: const Icon(
        CustomIcons.share_hollow,
        size: 30,
        color: Colors.white,
      ),
    );
  }

  /// Options Button
  Widget optionsButton() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.grey[900],
          context: context,
          builder: (context) {
            return Wrap(
              spacing: 10,
              children: [
                ListTile(
                  onTap: () {
                    setState(() {
                      /// The Dislike change is also made in the product data list by directly accessing it.
                      // productData[widget.index]['isDisliked'] = true;
                    });
                    Navigator.of(context).pop(true);
                    showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(
                          const Duration(milliseconds: 600),
                          () {
                            Navigator.of(context).pop(true);
                          },
                        );
                        return AlertDialog(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  color: Colors.black.withOpacity(0.7),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 20),
                                  child: const Text(
                                    "Video Disliked",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  iconColor: Colors.white,
                  textColor: Colors.white,
                  leading: const Icon(Icons.thumb_down_outlined),
                  title: const Text('Dislike'),
                ),
                ListTile(
                  onTap: () {
                    /// The Reported change is also made in the product data list by directly accessing it.
                    // productData[widget.index]['isReported'] = true;
                    Navigator.of(context).pop(true);
                    showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(
                          const Duration(milliseconds: 600),
                          () {
                            Navigator.of(context).pop(true);
                          },
                        );
                        return AlertDialog(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  color: Colors.black.withOpacity(0.7),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 20),
                                  child: const Text(
                                    "Video Reported",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  iconColor: Colors.white,
                  textColor: Colors.white,
                  leading: const Icon(Icons.flag_outlined),
                  title: const Text('Report'),
                ),
              ],
            );
          },
        );
      },
      child: const Icon(
        Icons.more_horiz_rounded,
        size: 35,
        color: Colors.white,
      ),
    );
  }

  /// Play Pause Icon.
  Widget playIcon() {
    return showPlayIcon
        ? Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                color: Colors.black.withOpacity(0.77),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  size: 85,
                  color: Colors.white,
                ),
              ),
            ),
          )
        : Container();
  }
}

/// Page Navigation Animation.
class SlideLeftRoute extends PageRouteBuilder {
  final Widget page;
  SlideLeftRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child),
        );
}
