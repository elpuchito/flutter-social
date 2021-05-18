import 'package:flutter/material.dart';

const TextStyle kHeading = TextStyle(
  fontSize: 50,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const TextStyle kBodyText = TextStyle(
  fontSize: 22,
  color: Colors.white,
);

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Container(
                      height: 150,
                      child: Center(
                        child: Text(
                          'Urban Photographers',
                          style: kHeading,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 300,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 100,
                              ),
                              RoundedButtonNoFill(
                                text: 'Continue with Google',
                                onPressed: () {
                                  print('hello');
                                },
                              ),
                              SizedBox(
                                height: 80,
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [Colors.black, Colors.black12],
        begin: Alignment.bottomCenter,
        end: Alignment.center,
      ).createShader(bounds),
      blendMode: BlendMode.darken,
      child: Container(
        child: Image.asset('assets/image1.png'),
      ),
    );
  }
}

class RoundedButtonNoFill extends StatelessWidget {
  const RoundedButtonNoFill({this.onPressed, this.text});

  final String text;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: kTransparentBtonDecoration,
        child: MaterialButton(
          enableFeedback: true,
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

final kTransparentBtonDecoration = BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(40.0)),
  border: Border.all(color: Colors.white, width: 2),
);
