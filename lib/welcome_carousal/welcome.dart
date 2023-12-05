import 'package:finkin_credential/pages/verification_screen/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

const int pageCount = 3;

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _controller = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        currentPage = _controller.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            physics: const PageScrollPhysics(parent: BouncingScrollPhysics()),
            children: [
              const WelcomePageContent(
                text:
                    "Welcome to Finkin Credentials! \n\n We're excited to have you on board. Swipe right to discover the perfect loan solution that suits your needs.",
                image: AssetImage('assets/images/loan2.jpg'),
                backgroundColor: Colors.blueGrey,
                textColor: Colors.white,
                accessibilityLabel: "Welcome to Finkin Credentials!",
              ),
              const WelcomePageContent(
                text:
                    "Begin your financial empowerment journey with our tailored loan options.",
                image: AssetImage('assets/images/loan3.webp'),
                backgroundColor: Colors.blueGrey,
                textColor: Colors.white,
                accessibilityLabel:
                    "Begin your financial empowerment journey with our tailored loan options.",
              ),
              WelcomePageContent(
                text:
                    "Let's make your financial dreams a reality with Finkin Credential!",
                showButton: true,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VerificationScreen()),
                  );
                },
                image: const AssetImage('assets/images/money.jpg'),
                backgroundColor: Colors.blueGrey,
                textColor: Colors.white,
                accessibilityLabel:
                    "Let's make your financial dreams a reality with Finkin Credential!",
              ),
            ],
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: pageCount,
                effect: ExpandingDotsEffect(
                  activeDotColor: Colors.white,
                  dotColor: Colors.white.withOpacity(0.3),
                  dotHeight: 12,
                  dotWidth: 12,
                  spacing: 8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomePageContent extends StatelessWidget {
  final String text;
  final bool showButton;
  final VoidCallback? onPressed;
  final ImageProvider image;
  final Color backgroundColor;
  final Color textColor;
  final String accessibilityLabel;

  const WelcomePageContent({
    Key? key,
    required this.text,
    this.showButton = false,
    this.onPressed,
    required this.image,
    required this.backgroundColor,
    required this.textColor,
    required this.accessibilityLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: accessibilityLabel,
      child: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: image,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (showButton)
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
//agentform