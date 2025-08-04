import 'package:Plumbingbazzar/Helper/Session.dart';
import 'package:Plumbingbazzar/Helper/String.dart';
import 'package:Plumbingbazzar/Screen/Login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../Helper/Color.dart';
import 'Dashboard.dart';
import 'SendOtp.dart';

class SignInUpAcc extends StatefulWidget {
  @override
  _SignInUpAccState createState() => new _SignInUpAccState();
}

class _SignInUpAccState extends State<SignInUpAcc> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    super.initState();
    setPrefrenceBool(ISFIRSTTIME, true);
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    //   statusBarIconBrightness: Brightness.light,
    // ));
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarBrightness: Brightness.dark,
    //   ),
    // );
  }

  _subLogo() {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 20.0),
      child: Image.asset(
        'assets/images/titleicon.png',
      fit: BoxFit.contain,
      width: 80,height: 80,
        // scale: 3,
      ),
    );
  }

  // welcomeEshopTxt() {
  //   return Padding(
  //     padding: EdgeInsetsDirectional.only(top: 30.0),
  //     child: new Text(
  //       getTranslated(context, 'WELCOME_ESHOP')!,
  //       style: Theme.of(context).textTheme.subtitle1!.copyWith(
  //           color: Theme.of(context).colorScheme.fontColor,
  //           fontWeight: FontWeight.bold),
  //     ),
  //   );
  // }
  Widget welcomeEshopTxt() {
    return Image.asset(
    'assets/images/Introscreen.png',
      height: 380,
      width: 380,
      fit: BoxFit.contain,
    );
  }


  // eCommerceforBusinessTxt() {
  //   return Padding(
  //     padding: EdgeInsetsDirectional.only(
  //       top: 5.0,
  //     ),
  //     child: new Text(
  //       getTranslated(context, 'ECOMMERCE_APP_FOR_ALL_BUSINESS')!,
  //       style: Theme.of(context).textTheme.subtitle2!.copyWith(
  //           color: Theme.of(context).colorScheme.fontColor,
  //           fontWeight: FontWeight.normal),
  //     ),
  //   );
  // }

  signInyourAccTxt() {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 1.0, bottom: 10),
      child: Column(
        children: [
          new Text("From Leaks to Fixes",
            // getTranslated(context, 'SIGNIN_ACC_LBL')!,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
               fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10,),
          new Text("The Best in Plumbing Equipment!",
            // getTranslated(context, 'SIGNIN_ACC_LBL')!,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
               fontSize: 15,
              fontWeight: FontWeight.w400
                ),
          ),
        ],
      ),
    );
  }

  signInBtn() {
    return CupertinoButton(
      child: Container(
          width: deviceWidth! * 0.9,
          height: 50,
          alignment: FractionalOffset.center,
          decoration: new BoxDecoration(
            color: ColorResources.buttonColor,
            // gradient: LinearGradient(
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //     colors: [colors.grad1Color, colors.grad2Color],
            //     stops: [0, 1]),
            borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
          ),
          child: Text(getTranslated(context, 'SIGNIN_LBL')!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: colors.whiteTemp, fontWeight: FontWeight.normal))),
      onPressed: () {
        print("ddfdffdfdffddfdfdfffffddddddddddddddddd");
        print("SIGNIN_LBL");
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => Login(title: "SIGNIN_LBL")));
      },
    );
  }
ContinueASGuest(){
    return GestureDetector(
        onTap: (){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 18.0),
          child: Center(
            child: Text(
              "Continue as a guest",
              style: TextStyle(
                color: ColorResources.buttonColor,
                fontSize: 16,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );

}
  createAccBtn() {
    return CupertinoButton(
      child: Container(
          width: deviceWidth! * 0.9,
          height: 50,
          alignment: FractionalOffset.center,
          decoration: new BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1.0, color:Colors.grey),
            // gradient: LinearGradient(
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //     colors: [colors.grad1Color, colors.grad2Color],
            //     stops: [0, 1]),
            borderRadius: new BorderRadius.all(const Radius.circular(30.0)  ,),

          ),
          child: Text(getTranslated(context, 'CREATE_ACC_LBL')!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: colors.grey, fontWeight: FontWeight.w500 , fontFamily: "opensans"))),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => SendOtp(
            checkForgot: "false",
            title: getTranslated(context, 'SEND_OTP_TITLE'),
          ),
        ));
      },
    );
  }

  // skipSignInBtn() {
  //   return CupertinoButton(
  //     child: Container(
  //         width: deviceWidth! * 0.8,
  //         height: 45,
  //         alignment: FractionalOffset.center,
  //         decoration: new BoxDecoration(
  //           color: colors.primary,
  //           // gradient: LinearGradient(
  //           //     begin: Alignment.topLeft,
  //           //     end: Alignment.bottomRight,
  //           //     colors: [colors.grad1Color, colors.grad2Color],
  //           //     stops: [0, 1]),
  //           borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
  //         ),
  //         child: Text(getTranslated(context, 'SKIP_SIGNIN_LBL')!,
  //             textAlign: TextAlign.center,
  //             style: Theme.of(context).textTheme.subtitle1!.copyWith(
  //                 color: colors.whiteTemp, fontWeight: FontWeight.normal))),
  //     onPressed: () {
  //       Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
  //     },
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
                top: 0,left: 0,right: 0,
                child: _subLogo()),
            // Background image
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: welcomeEshopTxt(),
            ),
        

            Positioned(
              top: deviceHeight * 0.52, // Overlap position
              left: 0,
              right: 0,
              child: Container(
                height: deviceHeight * 0.40,
                width: deviceWidth,
                decoration: BoxDecoration(
                  color: ColorResources.secondary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
             /*     boxShadow: [
                    BoxShadow(
                      color: Colors.black26, // darker shadow for depth
                      offset: Offset(0, 8),
                      blurRadius: 25,
                      spreadRadius: 2,
                    ),
                  ],*/
                ),
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    signInyourAccTxt(),
                    signInBtn(),
                    createAccBtn(),
                    ContinueASGuest()

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   deviceHeight = MediaQuery.of(context).size.height;
  //   deviceWidth = MediaQuery.of(context).size.width;
  //   return Container(
  //       color: Theme.of(context).colorScheme.white,
  //       child: Center(
  //           child: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: <Widget>[
  //                       _subLogo(),
  //
  //                       welcomeEshopTxt(),
  //                       //  eCommerceforBusinessTxt(),
  //                       Container(
  //                         height: MediaQuery.of(context).size.height*30/100,
  //                         width: deviceWidth,
  //                         decoration: BoxDecoration(
  //           color:ColorResources.secondary,
  //           borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(30),
  //             topRight: Radius.circular(30),
  //           ),
  //                         ),
  //                         padding: EdgeInsets.symmetric(vertical: 30),
  //                         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             signInyourAccTxt(),
  //             signInBtn(),
  //             SizedBox(height: 10),
  //             createAccBtn(),
  //           ],
  //                         ),
  //                       ),
  //                       // signInyourAccTxt(),
  //                       // signInBtn(),
  //                       // createAccBtn(),
  //                       // skipSignInBtn(),
  //                     ],
  //                   )));
  // }
}
