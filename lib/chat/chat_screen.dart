import 'dart:math';

import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
// import 'package:lottie/lottie.dart';

final pageStorageBucket = PageStorageBucket();

class ChatMessage {
  final String sender;
  final String message;

  ChatMessage({required this.sender, required this.message});
}

class TikTokChat extends StatefulWidget {
  const TikTokChat({super.key});

  @override
  State<TikTokChat> createState() => _TikTokChatState();
}

class _TikTokChatState extends State<TikTokChat> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();
  bool isMessageIconEnabled = false;

  final FocusScopeNode _inputFocusNode = FocusScopeNode();

  bool _showEmoji = false;
  bool _isSomeoneTyping = false;

  final List<ChatMessage> _messages = [
    ChatMessage(sender: 'me', message: 'last message'),
    ChatMessage(sender: 'me', message: 'this is our new account'),
    ChatMessage(sender: 'me', message: 'this is our new account'),
    ChatMessage(sender: 'me', message: 'this is our new account'),
    ChatMessage(sender: 'me', message: 'this is our new account'),
    ChatMessage(sender: 'me', message: 'this is our new account'),
    ChatMessage(sender: 'me', message: 'this is our new account'),
    ChatMessage(sender: 'me', message: 'this is our new account'),
    ChatMessage(sender: 'me', message: 'this is our new account'),
    ChatMessage(sender: 'me', message: 'this is our new account'),
    ChatMessage(sender: 'me', message: 'this is our new account'),
    ChatMessage(sender: 'me', message: 'this is our new account'),
    ChatMessage(sender: 'me', message: 'this is our new account'),
    ChatMessage(sender: 'me', message: 'this is our new account'),
    ChatMessage(sender: 'me', message: 'this is our new account'),
    ChatMessage(sender: 'me', message: 'this is our new account'),
    ChatMessage(sender: 'me', message: 'this is our new account'),
    ChatMessage(sender: 'me', message: 'first message'),
  ];

  @override
  void dispose() {
    _inputFocusNode.dispose();
    super.dispose();
  }

  void _toggleEmojiPicker() {
    setState(() {
      _showEmoji = !_showEmoji;
      if (_showEmoji) {
        _inputFocusNode
            .unfocus(); // Unfocus the input field when showing emoji picker
      }
    });
  }

  void _toggleTyping() {
    setState(() {
      _isSomeoneTyping = !_isSomeoneTyping;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print('emoji $_showEmoji');

    // _messages.sort((a, b) => a.message.compareTo(b.message));
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Expanded(
                child: _messages.isNotEmpty
                    ? ListView.builder(
                        controller: scrollController,
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: _messages.length + 1,
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .01),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          // return MessageCard(message: _messages[index]);

                          if (index == _messages.length) {
                            return const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person),
                            );
                          } else {
                            return MessageCard(
                              isSender: false,
                              haveNip: true,
                              message: _messages[index],
                            );
                          }
                        },
                      )
                    : const Center(
                        child: Text(
                          'Say Hii! 👋',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
              ),
              if (_isSomeoneTyping)
                Align(
                  alignment: Alignment.bottomLeft,
                  child: TypingIndicator(
                    showIndicator: _isSomeoneTyping,
                  ),
                  // child: Container(
                  //   margin: const EdgeInsets.only(
                  //     top: 6,
                  //     bottom: 6,
                  //     left: 15,
                  //     right: 80,
                  //   ),
                  //   child: ClipPath(
                  //     clipper: LowerNipMessageClipper(
                  //       MessageType.receive,
                  //       bubbleRadius: 8,
                  //       sizeOfNip: 4,
                  //       sizeRatio: 12,
                  //     ),
                  //     child: Container(
                  //       padding: const EdgeInsets.only(
                  //         // top: 5,
                  //         // bottom: 5,
                  //         left: 15,
                  //         right: 10,
                  //       ),
                  //       color: Colors.blueGrey,
                  //       child: Lottie.asset(
                  //         'assets/typing2.json',
                  //         height: 40,
                  //         width: 60,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ),

              _chatInput(),
              //show emojis on keyboard emoji button click & vice versa
              if (_showEmoji)
                EmojiPickerOverlay(
                  onClose: _toggleEmojiPicker,
                )
            ],
          ),
        ),
      ),
    );
  }

  // bottom chat field
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * .01,
        horizontal: MediaQuery.of(context).size.width * .025,
      ),
      child: Row(
        children: [
          //input field & buttons
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  // emoji button
                  IconButton(
                    onPressed: _toggleTyping,
                    icon: const Icon(Icons.emoji_emotions,
                        color: Colors.blueAccent),
                  ),

                  Expanded(
                    child: FocusScope(
                      node: _inputFocusNode,
                      child: TextField(
                        // focusNode: _inputFocusNode,
                        controller: messageController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onTap: () {
                          if (_showEmoji) {
                            setState(() => _showEmoji = !_showEmoji);
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: 'Type Somethimg....',
                          hintStyle: TextStyle(color: Colors.blueAccent),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  // photo button
                  // IconButton(
                  //   onPressed: () async {
                  //     final ImagePicker picker = ImagePicker();

                  //     // Pick an image
                  //     final List<XFile> images =
                  //         await picker.pickMultiImage(imageQuality: 70);

                  //     for (var i in images) {
                  //       print('Image Path: ${i.path}');

                  //       setState(() => _isUploading = true);

                  //       await APIs.sendChatImage(widget.user, File(i.path));

                  //       setState(() => _isUploading = false);
                  //     }
                  //   },
                  //   icon: const Icon(Icons.image, color: Colors.blueAccent),
                  // ),

                  // camera button button
                  // IconButton(
                  //   onPressed: () async {
                  //     final ImagePicker picker = ImagePicker();

                  //     // Pick an image
                  //     final XFile? image = await picker.pickImage(
                  //         source: ImageSource.camera, imageQuality: 70);
                  //     if (image != null) {
                  //       print('Image Path: ${image.path}');
                  //       setState(() => _isUploading = true);

                  //       await APIs.sendChatImage(widget.user, File(image.path));

                  //       setState(() => _isUploading = false);
                  //     }
                  //   },
                  //   icon: const Icon(
                  //     Icons.camera_alt_rounded,
                  //     color: Colors.blueAccent,
                  //     size: 26,
                  //   ),
                  // ),

                  //adding some space
                  SizedBox(width: MediaQuery.of(context).size.width * .02),
                ],
              ),
            ),
          ),

          //send message button
          MaterialButton(
            onPressed: () async {
              if (messageController.text.isNotEmpty) {
                {
                  _messages.insert(
                    0,
                    ChatMessage(
                      sender: 'me',
                      message: messageController.text,
                    ),
                  );
                  await Future.delayed(const Duration(milliseconds: 100));
                  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                    // scrollController.animateTo(
                    //   scrollController.position.minScrollExtent,
                    //   duration: const Duration(milliseconds: 300),
                    //   curve: Curves.easeOut,
                    // );
                    scrollController.animateTo(
                      scrollController.position.minScrollExtent - 10,
                      // 0.0,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 100),
                    );
                  });

                  setState(() {});
                }
                messageController.text = '';
              }

              // print('message $_messages');
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }
}

class EmojiPickerOverlay extends StatelessWidget {
  final VoidCallback onClose;

  const EmojiPickerOverlay({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: 270, // Adjust the height as needed
      color: Colors.grey[200],
      child: Column(
        children: [
          const Expanded(
            child: Center(
              child: Text('Emoji Picker'),
            ),
          ),
          ElevatedButton(
            onPressed: onClose,
            child: const Text('Close Emoji Picker'),
          ),
        ],
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  const MessageCard({
    Key? key,
    required this.isSender,
    required this.haveNip,
    required this.message,
  }) : super(key: key);

  final bool isSender;
  final bool haveNip;
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.only(
        top: 6,
        bottom: 6,
        left: isSender
            ? 80
            : haveNip
                ? 10
                : 15,
        right: isSender
            ? haveNip
                ? 10
                : 15
            : 80,
      ),
      child: ClipPath(
        clipper: haveNip
            ? LowerNipMessageClipper(
                isSender ? MessageType.send : MessageType.receive,
                // nipWidth: 8,
                // nipHeight: 10,
                sizeOfNip: 2,
                sizeRatio: 2,
                bubbleRadius: haveNip ? 20 : 0,
              )
            : null,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isSender ? Colors.cyan : Colors.blue,
                borderRadius: haveNip ? null : BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(color: Colors.black38),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: isSender ? 12 : 15,
                    right: isSender ? 15 : 10,
                  ),
                  child: Text(
                    "${message.message}   ",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({
    super.key,
    this.showIndicator = false,
    this.bubbleColor = const Color(0xFF646b7f),
    this.flashingCircleDarkColor = const Color(0xFF333333),
    this.flashingCircleBrightColor = const Color(0xFFaec1dd),
  });

  final bool showIndicator;
  final Color bubbleColor;
  final Color flashingCircleDarkColor;
  final Color flashingCircleBrightColor;

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _appearanceController;

  late Animation<double> _indicatorSpaceAnimation;

  late Animation<double> _smallBubbleAnimation;
  late Animation<double> _mediumBubbleAnimation;
  late Animation<double> _largeBubbleAnimation;

  late AnimationController _repeatingController;
  final List<Interval> _dotIntervals = const [
    Interval(0.25, 0.8),
    Interval(0.35, 0.9),
    Interval(0.45, 1.0),
  ];

  @override
  void initState() {
    super.initState();

    _appearanceController = AnimationController(
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _indicatorSpaceAnimation = CurvedAnimation(
      parent: _appearanceController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      reverseCurve: const Interval(0.0, 1.0, curve: Curves.easeOut),
    ).drive(Tween<double>(
      begin: 0.0,
      end: 60.0,
    ));

    _smallBubbleAnimation = CurvedAnimation(
      parent: _appearanceController,
      curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      reverseCurve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );
    _mediumBubbleAnimation = CurvedAnimation(
      parent: _appearanceController,
      curve: const Interval(0.2, 0.7, curve: Curves.elasticOut),
      reverseCurve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    );
    _largeBubbleAnimation = CurvedAnimation(
      parent: _appearanceController,
      curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      reverseCurve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    _repeatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    if (widget.showIndicator) {
      _showIndicator();
    }
  }

  @override
  void didUpdateWidget(TypingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.showIndicator != oldWidget.showIndicator) {
      if (widget.showIndicator) {
        _showIndicator();
      } else {
        _hideIndicator();
      }
    }
  }

  @override
  void dispose() {
    _appearanceController.dispose();
    _repeatingController.dispose();
    super.dispose();
  }

  void _showIndicator() {
    _appearanceController
      ..duration = const Duration(milliseconds: 750)
      ..forward();
    _repeatingController.repeat();
  }

  void _hideIndicator() {
    _appearanceController
      ..duration = const Duration(milliseconds: 150)
      ..reverse();
    _repeatingController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _indicatorSpaceAnimation,
      builder: (context, child) {
        return SizedBox(
          height: _indicatorSpaceAnimation.value,
          child: child,
        );
      },
      child: Stack(
        children: [
          AnimatedBubble(
            animation: _smallBubbleAnimation,
            left: 8,
            bottom: 8,
            bubble: CircleBubble(
              size: 8,
              bubbleColor: widget.bubbleColor,
            ),
          ),
          AnimatedBubble(
            animation: _mediumBubbleAnimation,
            left: 10,
            bottom: 10,
            bubble: CircleBubble(
              size: 16,
              bubbleColor: widget.bubbleColor,
            ),
          ),
          AnimatedBubble(
            animation: _largeBubbleAnimation,
            left: 12,
            bottom: 12,
            bubble: StatusBubble(
              repeatingController: _repeatingController,
              dotIntervals: _dotIntervals,
              flashingCircleDarkColor: widget.flashingCircleDarkColor,
              flashingCircleBrightColor: widget.flashingCircleBrightColor,
              bubbleColor: widget.bubbleColor,
            ),
          ),
        ],
      ),
    );
  }
}

class CircleBubble extends StatelessWidget {
  const CircleBubble({
    super.key,
    required this.size,
    required this.bubbleColor,
  });

  final double size;
  final Color bubbleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bubbleColor,
      ),
    );
  }
}

class AnimatedBubble extends StatelessWidget {
  const AnimatedBubble({
    super.key,
    required this.animation,
    required this.left,
    required this.bottom,
    required this.bubble,
  });

  final Animation<double> animation;
  final double left;
  final double bottom;
  final Widget bubble;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      bottom: bottom,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.scale(
            scale: animation.value,
            alignment: Alignment.bottomLeft,
            child: child,
          );
        },
        child: bubble,
      ),
    );
  }
}

class StatusBubble extends StatelessWidget {
  const StatusBubble({
    super.key,
    required this.repeatingController,
    required this.dotIntervals,
    required this.flashingCircleBrightColor,
    required this.flashingCircleDarkColor,
    required this.bubbleColor,
  });

  final AnimationController repeatingController;
  final List<Interval> dotIntervals;
  final Color flashingCircleDarkColor;
  final Color flashingCircleBrightColor;
  final Color bubbleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85,
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        color: bubbleColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FlashingCircle(
            index: 0,
            repeatingController: repeatingController,
            dotIntervals: dotIntervals,
            flashingCircleDarkColor: flashingCircleDarkColor,
            flashingCircleBrightColor: flashingCircleBrightColor,
          ),
          FlashingCircle(
            index: 1,
            repeatingController: repeatingController,
            dotIntervals: dotIntervals,
            flashingCircleDarkColor: flashingCircleDarkColor,
            flashingCircleBrightColor: flashingCircleBrightColor,
          ),
          FlashingCircle(
            index: 2,
            repeatingController: repeatingController,
            dotIntervals: dotIntervals,
            flashingCircleDarkColor: flashingCircleDarkColor,
            flashingCircleBrightColor: flashingCircleBrightColor,
          ),
        ],
      ),
    );
  }
}

class FlashingCircle extends StatelessWidget {
  const FlashingCircle({
    super.key,
    required this.index,
    required this.repeatingController,
    required this.dotIntervals,
    required this.flashingCircleBrightColor,
    required this.flashingCircleDarkColor,
  });

  final int index;
  final AnimationController repeatingController;
  final List<Interval> dotIntervals;
  final Color flashingCircleDarkColor;
  final Color flashingCircleBrightColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: repeatingController,
      builder: (context, child) {
        final circleFlashPercent = dotIntervals[index].transform(
          repeatingController.value,
        );
        final circleColorPercent = sin(pi * circleFlashPercent);

        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.lerp(
              flashingCircleDarkColor,
              flashingCircleBrightColor,
              circleColorPercent,
            ),
          ),
        );
      },
    );
  }
}
