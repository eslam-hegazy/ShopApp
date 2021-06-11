import 'package:flutter/material.dart';
import 'package:shopappwithapi/models/boarding_model.dart';
import 'package:shopappwithapi/network/local/cache_helper.dart';
import 'package:shopappwithapi/screens/login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var pageController = PageController();
  bool isLast = false;

  List<OnBoardingModel> list = [
    OnBoardingModel(
        image: 'assets/s.jpg',
        title: 'OnBoard title 1',
        body: 'OnBoard body 1'),
    OnBoardingModel(
        image: 'assets/s.jpg',
        title: 'OnBoard title 2',
        body: 'OnBoard body 2'),
    OnBoardingModel(
        image: 'assets/s.jpg',
        title: 'OnBoard title 3',
        body: 'OnBoard body 3'),
  ];
  void submit() {
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if (value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('OnBoarding'),
          actions: [
            TextButton(
                onPressed: () {
                  submit();
                },
                child: Text(
                  'Skip',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemBuilder: (context, index) => onboardingItem(list[index]),
                  itemCount: list.length,
                  onPageChanged: (int n) {
                    if (n == list.length - 1) {
                      setState(() {
                        isLast = true;
                      });
                    } else {
                      setState(() {
                        isLast = false;
                      });
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(children: [
                SmoothPageIndicator(
                    controller: pageController,
                    count: list.length,
                    effect: ExpandingDotsEffect(
                      dotWidth: 10,
                      dotHeight: 10,
                      expansionFactor: 4,
                      spacing: 5,
                    )),
                Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast == true) {
                      submit();
                    } else {
                      pageController.nextPage(
                          duration: Duration(milliseconds: 750),
                          curve: Curves.fastLinearToSlowEaseIn);
                    }
                  },
                  child: Icon(Icons.arrow_forward_ios),
                ),
              ]),
            ],
          ),
        ));
  }
}

Widget onboardingItem(OnBoardingModel onBoardingModel) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Image(
            image: AssetImage(onBoardingModel.image),
          ),
        ),
        Text(
          onBoardingModel.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          onBoardingModel.body,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
