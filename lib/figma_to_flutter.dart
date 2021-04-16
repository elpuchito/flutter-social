import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 375,
          height: 812,
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 375,
                height: 812,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: 375,
                          height: 44,
                          padding: const EdgeInsets.only(
                            left: 21,
                            right: 14,
                            top: 8,
                            bottom: 13,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 56,
                                height: 23,
                                padding: const EdgeInsets.only(
                                  right: 2,
                                  top: 6,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 54,
                                      child: Text(
                                        "9:27",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontFamily: "SF Pro Text",
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 216),
                              Container(
                                width: 68,
                                height: 16,
                                padding: const EdgeInsets.only(
                                  top: 1,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 18,
                                      height: 12,
                                      child: Stack(
                                        children: [],
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Container(
                                      width: 21,
                                      height: 15,
                                      child: Stack(
                                        children: [],
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Container(
                                      width: 25,
                                      height: 12,
                                      padding: const EdgeInsets.only(
                                        right: 1,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 22,
                                            height: 11.33,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2.67),
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 1,
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(2),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 18,
                                                  height: 7.33,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1.33),
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 1),
                                          Opacity(
                                            opacity: 0.40,
                                            child: Container(
                                              width: 1.33,
                                              height: 4,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 243,
                      top: 729,
                      child: Text(
                        "REGISTER",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontFamily: "SF Pro Text",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      top: 727,
                      child: Container(
                        width: 167,
                        height: 52,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 167,
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                color: Colors.white,
                              ),
                              padding: const EdgeInsets.only(
                                left: 61,
                                right: 62,
                                top: 19,
                                bottom: 18,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "LOG IN",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.52,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 192,
                      top: 727,
                      child: Container(
                        width: 167,
                        height: 52,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 167,
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.black,
                              ),
                              padding: const EdgeInsets.only(
                                top: 19,
                                bottom: 18,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "REGISTER",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.52,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: 375,
                          height: 707,
                          child: FlutterLogo(size: 375),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 120,
                      top: 799,
                      child: Container(
                        width: 135,
                        height: 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 84,
                      top: 307,
                      child: Container(
                        width: 206,
                        height: 54,
                        child: Stack(
                          children: [
                            Text(
                              "photo",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 48,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      top: 659,
                      child: Container(
                        width: 139,
                        height: 28,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  "Pawel Czerwinski",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 36,
                              top: 15,
                              child: Text(
                                "@pawel_czerwinski",
                                style: TextStyle(
                                  color: Color(0xcc000000),
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: FlutterLogo(size: 28),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
