import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const RippleSuccess());
  }
}

bool start = false;
bool second = false;
bool _showMessage = false;

class RippleSuccess extends StatefulWidget {
  const RippleSuccess({super.key});

  @override
  State<RippleSuccess> createState() => _RippleSuccessState();
}

class _RippleSuccessState extends State<RippleSuccess>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Color green = const Color(0xff049B53);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _showMessage = true;
          });
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: green,
      body: Stack(
        children: [
          Positioned.fill(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              curve: Easing.legacy,
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                return CustomPaint(
                  painter: RipplePainter(
                      progress: value, color: Colors.white, first: true),
                );
              },
            ),
          ),
          if (start == true)
            Positioned.fill(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                curve: Easing.legacy,
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return CustomPaint(
                    painter: RipplePainter(
                        progress: value, color: green, first: false),
                  );
                },
              ),
            ),
          if (_showMessage)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (second == true)
                    AnimationLimiter(
                      child: Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 400),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            curve: Curves.decelerate,
                            verticalOffset: 10,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: [
                            RichText(
                              text: const TextSpan(
                                text: 'Wallet Tx ID ',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff094428)),
                                children: [
                                  TextSpan(
                                    text: '16633',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  second == false ? lottie() : const SizedBox(),
                  if (second == true)
                    AnimationLimiter(
                      child: Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 500),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            verticalOffset: 100.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: [
                            Lottie.asset(
                              'assets/success static (1).json',
                              width: 182,
                              height: 182,
                            ),
                            const Text(
                              'Payment Successfull',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                  color: Colors.white),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 25),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                      const Color(0xffFDCC56).withOpacity(.3)),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.timer_outlined),
                                  Text(
                                    "Money will be added in wallet within 30 mins",
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xffFFCA4A)),
                                  )
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 200),
                              child: OrderPageContactUs(),
                            )
                          ],
                        ),
                      ),
                    )
                ],
              ),
            )
        ],
      ),
      bottomNavigationBar: _showMessage && second
          ? Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  "Done",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          : const SizedBox(),
    );
  }

  Widget lottie() {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      setState(() {
        second = true;
        start = true;
      });
    });
    return Lottie.asset(
      'assets/success (1).json',
      width: 182,
      height: 182,
      repeat: false,
    );
  }
}

class RipplePainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool? first;

  RipplePainter({required this.progress, required this.color, this.first});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width, size.height);
    final radius = size.longestSide * progress + 100;

    canvas.drawCircle(center, radius, paint);
    start = first ?? false;
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class OrderPageContactUs extends StatelessWidget {
  const OrderPageContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Contact us',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.white),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              contactUsContainer('assets/mail.svg'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: contactUsContainer('assets/phone-outline.svg'),
              ),
              contactUsContainer('assets/whatsapp.svg')
            ],
          )
        ],
      ),
    );
  }

  Widget contactUsContainer(String svg) {
    return Container(
      height: 34,
      width: 34,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xff323639))),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: SvgPicture.asset(svg),
      ),
    );
  }
}
