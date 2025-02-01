
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/onbording_content.dart';
import 'login_screen.dart';


class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<OnBoardingContent> contents = [
      OnBoardingContent(
          title: 'Make nice mail with us',//AppLocalizations.of(context)!.board1_title,
          special: 'nanden',
          image: 'assets/boarding1.svg',
          description:
          '',//AppLocalizations.of(context)!.board1_body
      ),
      OnBoardingContent(
          title: 'share your idae with cocking',//AppLocalizations.of(context)!.board2_title,
          special: ' with other',
          image: 'assets/boarding2.svg',
          description:
          '',//AppLocalizations.of(context)!.board2_body
      ),
      OnBoardingContent(
          title: 'let\'s bring you start',//AppLocalizations.of(context)!.board3_title,
          special: 'as possible',
          image: 'assets/boarding3.svg',
          description:
          '',//AppLocalizations.of(context)!.board3_body
      ),
    ];
    return Scaffold(
      backgroundColor:const Color(0XFFDCC1FF),
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6.0, 60.0, 6.0, 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Expanded(flex: 11,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: contents.length,
                  onPageChanged: (int index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Align(alignment:Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text( contents[index].title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,fontSize: 26,
                                          color: Colors.black
                                      ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                      contents[index].description,
                                      textWidthBasis: TextWidthBasis.parent,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: SvgPicture.asset(
                              contents[index].image,
                              fit:BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 50,),
              Expanded(flex: 2,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        contents.length,
                            (index) => buildDot(index, context),
                      ),
                    ),
                    const SizedBox(height: 12.0,),
                    if(currentIndex == 2)
                    ElevatedButton(onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context)=> const LoginPage()
                        ),
                      );
                    }, child:Text(
                      'sssiiiiuuuuuu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ))//AppLocalizations.of(context)!.board3_btn))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin:const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentIndex == index ?Colors.black:Colors.white,
      ),
    );
  }
}
