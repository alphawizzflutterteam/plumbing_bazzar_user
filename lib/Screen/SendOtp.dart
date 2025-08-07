import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:Plumbingbazzar/Helper/String.dart';
import 'package:Plumbingbazzar/Helper/cropped_container.dart';
import 'package:Plumbingbazzar/Provider/SettingProvider.dart';
import 'package:Plumbingbazzar/Screen/Privacy_Policy.dart';
import 'package:Plumbingbazzar/Screen/Verify_Otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../Helper/AppBtn.dart';
import '../Helper/Color.dart';
import '../Helper/Constant.dart';
import '../Helper/Session.dart';
import '../Provider/UserProvider.dart';
import 'Login.dart';

class SendOtp extends StatefulWidget {
  String? title;
  final checkForgot;

  SendOtp({Key? key, this.title, this.checkForgot}) : super(key: key);

  @override
  _SendOtpState createState() => _SendOtpState();
}

class _SendOtpState extends State<SendOtp> with TickerProviderStateMixin {
  bool visible = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final mobileController = TextEditingController();
  final ccodeController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? mobile, id, countrycode, countryName, mobileno;
  bool _isNetworkAvail = true;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  String? password,
      username,
      email,
      city,
      area,
      pincode,
      address,
      latitude,
      longitude,
      image;

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _playAnimation();
      checkNetwork();
    }
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  Future<void> checkNetwork() async {
    bool avail = await isNetworkAvailable();
    if (avail) {
      getVerifyUser();
    } else {
      Future.delayed(Duration(seconds: 2)).then((_) async {
        if (mounted)
          setState(() {
            _isNetworkAvail = false;
          });
        await buttonController!.reverse();
      });
    }
  }

  bool validateAndSave() {
    final form = _formkey.currentState!;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    buttonController!.dispose();
    super.dispose();
  }

  void setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 4.0,
        backgroundColor: ColorResources.secondary, // Your custom background
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), // 🎯 Rounded corners
          side: BorderSide(
            color: ColorResources.buttonColor, // ✅ Border color
            width: 1.5,          // ✅ Border thickness
          ),
        ),
        content: Text(
          msg,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[800], // Text color
            fontSize: 16,
          ),
        ),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      ),
    );
  }

  Future<void> getLoginUser() async {
    // print("this is fcm Token $fcmToken");
    var data = {MOBILE: mobile, PASSWORD: "12345678"};
    print("Anjali login________${data}");
    Response response =
        await post(getUserLoginApi, body: data, headers: headers)
            .timeout(Duration(seconds: timeOut));
    print(getUserLoginApi);
    print("fffffffffffffffgdfgdgdgdffffffff${response.body}");
    print(response.statusCode);
    var getdata = json.decode(response.body);
    bool error = getdata["error"];
    String? msg = getdata["message"];
    dynamic? otp = getdata["otp"];
    await buttonController!.reverse();
    if (!error) {
      setSnackbar(msg!);
      var i = getdata["data"][0];
      id = i[ID];
      username = i[USERNAME];
      email = i[EMAIL];
      mobile = i[MOBILE];
      city = i[CITY];
      area = i[AREA];
      address = i[ADDRESS];
      pincode = i[PINCODE];
      latitude = i[LATITUDE];
      longitude = i[LONGITUDE];
      image = i[IMAGE];
      CUR_USERID = id;
      // CUR_USERNAME = username;
      UserProvider userProvider =
          Provider.of<UserProvider>(this.context, listen: false);
      userProvider.setName(username ?? "");
      userProvider.setEmail(email ?? "");
      userProvider.setProfilePic(image ?? "");
      SettingProvider settingProvider =
          Provider.of<SettingProvider>(context, listen: false);
      settingProvider.saveUserDetail(id!, username, email, mobile, city, area,
          address, pincode, latitude, longitude, image, context);
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => VerifyOtp1(otp: otp,mobilenum: mobile
      //
      //       ),
      //     ));
    /*  Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(),
          ));*/
      // Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
    } else {
      setSnackbar(msg!);
    }
  }

  Widget noInternet(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: kToolbarHeight),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          noIntImage(),
          noIntText(context),
          noIntDec(context),
          AppBtn(
            title: getTranslated(context, 'TRY_AGAIN_INT_LBL'),
            btnAnim: buttonSqueezeanimation,
            btnCntrl: buttonController,
            onBtnSelected: () async {
              _playAnimation();
              Future.delayed(Duration(seconds: 2)).then((_) async {
                _isNetworkAvail = await isNetworkAvailable();
                if (_isNetworkAvail) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => super.widget));
                } else {
                  await buttonController!.reverse();
                  if (mounted) setState(() {});
                }
              });
            },
          )
        ]),
      ),
    );
  }

  Future<void> getVerifyUser() async {
    print("U Are Registering  calling  your Api");
    // try {
      var data = {MOBILE: mobile, "forgot_otp": "false"};
      print("Anjali Verify data___sfgdfg_${data}");
      Response response =
          await post(getVerifyUserApi, body: data, )
              .timeout(Duration(seconds: timeOut));

      print(getVerifyUserApi);
      print("User Apiiiiiiiiiiiiiiiiiiiiiii $getVerifyUserApi");
print("nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn${response.body}");
print("sdfsfsfsdffdsffffffffffffffffff${response.statusCode}");
      print("vvvvvvvvvvvvvvvvvvvvvvvvvvvv");
      var getdata = json.decode(response.body);
      bool? error = getdata["error"];
      String? msg = getdata["message"];
      await buttonController!.reverse();
      getLoginUser();
      SettingProvider settingsProvider =
          Provider.of<SettingProvider>(context, listen: false);

      print(widget.title);
      if (widget.checkForgot == "false") {

        if (widget.title == getTranslated(context, 'SEND_OTP_TITLE')) {
          if (!error!) {
            int otp = getdata["data"]["otp"];
            // setSnackbar(otp.toString());
            // Fluttertoast.showToast(msg: otp.toString(),
            //   backgroundColor: colors.primary
            // );
            setSnackbar(msg!);
            settingsProvider.setPrefrence(MOBILE, mobile!);
            // settingsProvider.setPrefrence(COUNTRY_CODE, countrycode);

            Future.delayed(Duration(seconds: 1)).then((_) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VerifyOtp(
                            otp: otp,
                            mobileNumber: mobile!,
                            countryCode: countrycode,
                            title: getTranslated(context, 'SEND_OTP_TITLE'),
                          )));
            });
          } else {
            setSnackbar(msg!);
          }
        }
      }

      else if (widget.title == "SIGNIN_LBL") {

          if (!error!) {
            int otp = getdata["data"]["otp"];
            // setSnackbar(otp.toString());
            // Fluttertoast.showToast(msg: otp.toString(),
            //   backgroundColor: colors.primary
            // );
            setSnackbar(msg!);
            settingsProvider.setPrefrence(MOBILE, mobile!);
            // settingsProvider.setPrefrence(COUNTRY_CODE, countrycode);

            Future.delayed(Duration(seconds: 1)).then((_) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VerifyOtp(
                            otp: otp,
                            mobileNumber: mobile!,
                            countryCode: countrycode,
                            title: "SIGNIN_LBL",
                          )));
            });
          } else {
            setSnackbar(msg!);
          }
        }
       else {
        if (widget.title == getTranslated(context, 'FORGOT_PASS_TITLE')) {
          if (!error!) {
            int otp = getdata["data"]["otp"];
            // Fluttertoast.showToast(msg: otp.toString(),
            //     backgroundColor: colors.primary
            // );
            // setSnackbar(otp.toString());
            settingsProvider.setPrefrence(MOBILE, mobile!);
            settingsProvider.setPrefrence(COUNTRY_CODE, countrycode!);
            Future.delayed(Duration(seconds: 1)).then((_) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VerifyOtp(
                            otp: otp,
                            mobileNumber: mobile!,
                            countryCode: countrycode,
                            title: getTranslated(context, 'FORGOT_PASS_TITLE'),
                          )));
            });
          } else {
            setSnackbar(getTranslated(context, 'FIRSTSIGNUP_MSG')!);
          }
        }
      }
    // } on TimeoutException catch (_) {
    //   setSnackbar(getTranslated(context, 'somethingMSg')!);
    //   await buttonController!.reverse();
    // }
  }

  createAccTxt() {
    return Padding(
        padding: EdgeInsets.only(
          top: 30.0,
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            widget.title == getTranslated(context, 'SEND_OTP_TITLE')
                ? getTranslated(context, 'CREATE_ACC_LBL')!
                : getTranslated(context, 'FORGOT_PASSWORDTITILE')!,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: Theme.of(context).colorScheme.fontColor,
                fontWeight: FontWeight.bold),
          ),
        ));
  }

  Widget verifyCodeTxt() {
    return Padding(
        padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            getTranslated(context, 'SEND_VERIFY_CODE_LBL')!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                color: Theme.of(context).colorScheme.fontColor,
                fontWeight: FontWeight.normal),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: 1,
          ),
        ));
  }

  Widget setCodeWithMono() {
    return Container(
        width: deviceWidth! * 0.9,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Expanded(
            //   flex: 2,
            //   child: setCountryCode(),
            // ),
            Expanded(
              flex: 4,
              child: setMono(),
            )
          ],
        ));
  }

  Widget setCountryCode() {
    double width = deviceWidth!;
    double height = deviceHeight! * 0.9;
    return CountryCodePicker(
        showCountryOnly: false,
        searchStyle: TextStyle(
          color: Theme.of(context).colorScheme.fontColor,
        ),
        flagWidth: 20,
        boxDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.lightWhite,
        ),
        searchDecoration: InputDecoration(
          hintText: getTranslated(context, 'COUNTRY_CODE_LBL'),
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.fontColor),
          fillColor: Theme.of(context).colorScheme.fontColor,
        ),
        showOnlyCountryWhenClosed: false,
        initialSelection: 'IN',
        dialogSize: Size(width, height),
        alignLeft: true,
        textStyle: TextStyle(
            color: Theme.of(context).colorScheme.fontColor,
            fontWeight: FontWeight.bold),
        onChanged: (CountryCode countryCode) {
          countrycode = countryCode.toString().replaceFirst("+", "");
          countryName = countryCode.name;
        },
        onInit: (code) {
          countrycode = code.toString().replaceFirst("+", "");
        });
  }

  Widget setMono() {
    return TextFormField(
      maxLength: 10,
      keyboardType: TextInputType.number,
      controller: mobileController,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: TextStyle(
        color: Colors.grey[800], // grey text
        fontWeight: FontWeight.normal,
      ),
      validator: (val) => validateMob(
        val!,
        getTranslated(context, 'MOB_REQUIRED'),
        getTranslated(context, 'VALID_MOB'),
      ),
      onSaved: (String? value) {
        mobile = value;
      },
      decoration: InputDecoration(
        counterText: '',
        hintText: getTranslated(context, 'MOBILEHINT_LBL'),
        hintStyle: TextStyle(
          color: Colors.grey, // grey hint text
          fontWeight: FontWeight.normal,
        ),
        filled: true,
        fillColor: Colors.white, // white background
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade600, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red.shade300),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }


  Widget verifyBtn() {
    return AppBtn(
      title: "Get OTP",
        // title: widget.title == getTranslated(context, 'SEND_OTP_TITLE')
        //     ? getTranslated(context, 'SEND_OTP')
        //     : getTranslated(context, 'GET_PASSWORD'),
        btnAnim: buttonSqueezeanimation,
        btnCntrl: buttonController,
        onBtnSelected: () async {
          validateAndSubmit();
        });
  }
  termAndPolicyTxt() {
    return Padding(
      padding:
      const EdgeInsetsDirectional.only(bottom: 20.0, end: 25.0, top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Already have an account ? ",
              style: Theme.of(context).textTheme.caption!.copyWith(
                  color: Theme.of(context).colorScheme.fontColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 16)),
          InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Login(
                    // checkForgot: "false",
                    title: "Login",
                  ),
                ));
              },
              child: Text(
                // getTranslated(context, 'SIGN_UP_LBL')!,
                "Login ",style: TextStyle(color:ColorResources.buttonColor, fontWeight: FontWeight.w500 ,fontFamily: "opensans"),
               /* style: Theme.of(context).textTheme.caption!.copyWith(
                  color: Theme.of(context).colorScheme.fontColor,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),*/
              ))
        ],
      ),
    );
  }

  backBtn() {
    return Platform.isIOS
        ? Container(
            padding: EdgeInsets.only(top: 20.0, left: 10.0),
            alignment: Alignment.topLeft,
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: InkWell(
                  child: Icon(Icons.keyboard_arrow_left, color: colors.primary),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
            ))
        : Container();
  }
  double? deviceWidth;
  @override
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    buttonController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Only initialize once
    if (deviceWidth == null) {
      deviceWidth = MediaQuery.of(context).size.width;

      buttonSqueezeanimation = Tween(
        begin: deviceWidth! * 0.7,
        end: 50.0,
      ).animate(CurvedAnimation(
        parent: buttonController!,
        curve: Interval(0.0, 0.150),
      ));
    }
  }
/*
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    super.initState();
    buttonController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    if (deviceWidth == null) {
      deviceWidth = MediaQuery.of(context).size.width;

      buttonSqueezeanimation = Tween(
        begin: deviceWidth! * 0.7,
        end: 50.0,
      ).animate(CurvedAnimation(
        parent: buttonController!,
        curve: Interval(0.0, 0.150),
      ));
    }
  */
/*  buttonSqueezeanimation = Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(CurvedAnimation(
      parent: buttonController!,
      curve: Interval(
        0.0,
        0.150,
      ),
    ));*//*

  }
*/

  _subLogo() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 30 / 100,
        height: MediaQuery.of(context).size.height * 10 / 100,
        child: Center(
          child: Image.asset(
            'assets/images/titleicon.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget welcomeEshopTxt() {
    return Image.asset(
      'assets/images/login_top_image.png',
      height: 380,
      width: 380,
      fit: BoxFit.contain,
    );
  }
/*
  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        body: _isNetworkAvail
            ? SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 95 / 100,
                  ),
                  child: IntrinsicHeight(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 30,
                          left: 0,
                          right: 0,
                          child: _subLogo(),
                        ),
                        Positioned(
                          top: 90,
                          left: 0,
                          right: 0,
                          child: welcomeEshopTxt(),
                        ),

                        getLoginContainer(),
                        // getLogo(),
                      ],
                    ),
                  ),
                ),
              )

            : noInternet(context));
  }*/
  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      body: _isNetworkAvail
          ? SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // SizedBox(height: 30),
              _subLogo(),
              // SizedBox(height: 20),
              welcomeEshopTxt(),
              // SizedBox(height: 20),
              getLoginContainer(),
              // SizedBox(height: 20),
            ],
          ),
        ),
      )
          : noInternet(context),
    );
  }
  signInTxt() {
    return Padding(
        padding: EdgeInsetsDirectional.only(
          top: 30.0,
        ),
        child: Align(
          alignment: Alignment.center,
          child: new Text(
            getTranslated(context, 'SIGNIN_LBL')!,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: Theme.of(context).colorScheme.fontColor,
                fontWeight: FontWeight.bold),
          ),
        ));
  }

  // Widget getLoginContainer() {
  //   return Container(
  //     alignment: Alignment.center,
  //     // margin: EdgeInsets.symmetric(horizontal: 20),
  //     padding: EdgeInsets.only(top: 10),
  //     decoration: BoxDecoration(
  //       color: ColorResources.secondary,
  //       borderRadius: BorderRadius.circular(30),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black12,
  //           offset: Offset(0, 4),
  //           blurRadius: 15,
  //           spreadRadius: 1,
  //         ),
  //       ],
  //     ),
  //     child: Form(
  //       key: _formkey,
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Text(
  //             "Hello! Register to get",
  //             style: Theme.of(context).textTheme.subtitle1!.copyWith(
  //               fontSize: 20,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           Text(
  //             "Standard",
  //             style: Theme.of(context).textTheme.subtitle1!.copyWith(
  //               fontSize: 18,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           SizedBox(height: 30),
  //           setCodeWithMono(),
  //           SizedBox(height: 20),
  //           verifyBtn(),
  //           SizedBox(height: 20),
  //           termAndPolicyTxt(),
  //         ],
  //       ),
  //     ),
  //   );
  // }
/*  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      body: _isNetworkAvail
          ? SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              _subLogo(),
              SizedBox(height: 20),
              welcomeEshopTxt(),
              SizedBox(height: 20),
              getLoginContainer(),
              SizedBox(height: 20),
            ],
          ),
        ),
      )
          : noInternet(context),
    );
  }*/

// Fixed _subLogo method - REMOVED Expanded
/*  Widget _subLogo() {
    return Container(
      height: 80, // Fixed height instead of Expanded
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 30 / 100,
          height: MediaQuery.of(context).size.height * 10 / 100,
          child: Center(
            child: Image.asset(
              'assets/images/titleicon.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }*/

// Fixed welcomeEshopTxt method
/*  Widget welcomeEshopTxt() {
    return Container(
      height: 300, // Fixed height
      child: Image.asset(
        'assets/images/login_top_image.png',
        height: 380,
        width: 380,
        fit: BoxFit.contain,
      ),
    );
  }*/

  Widget getLoginContainer() {
    return Container(
      alignment: Alignment.center,
      // margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.only(top: 20, bottom: 20),
      decoration: BoxDecoration(
        color: ColorResources.secondary,
        borderRadius: BorderRadius.circular(30),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black12,
        //     offset: Offset(0, 4),
        //     blurRadius: 15,
        //     spreadRadius: 1,
        //   ),
        // ],
      ),
      child: Form(
        key: _formkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Hello! Register to get",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Standard",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            setCodeWithMono(),
            SizedBox(height: 10),
            verifyBtn(),
            // SizedBox(height: 10),
            termAndPolicyTxt(),
          ],
        ),
      ),
    );
  }
 /* Widget getLoginContainer() {
    // final mediaQuery = MediaQuery.of(context);

    return Positioned.directional(
      top: 450,
      // start: mediaQuery.size.width * 0.5,
      textDirection: Directionality.of(context),
      // top: mediaQuery.size.height * 0.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(
              // bottom: mediaQuery.viewInsets.bottom * 0.8,
              // left: 16,
              // right: 16,
              // top: 24,
            ),
            height: MediaQuery.of(context).size.height*40/100,
            // width: mediaQuery.size.width,
            decoration: BoxDecoration(
              color: ColorResources.secondary, // 🔵 Blue background
              borderRadius: BorderRadius.circular(30), // 🎯 Rounded corners
            *//*  boxShadow: [
                BoxShadow(
                  color: Colors.black26, // darker shadow for depth
                  offset: Offset(0, 8),
                  blurRadius: 25,
                  spreadRadius: 2,
                ),
              ],*//*
            ),
            child: Form(
              key: _formkey,
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    // maxHeight: mediaQuery.size.height * 2,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        child: Text(
                          "Hello! Register to get",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        child: Text(
                          "Standard",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 20,),
                      // SizedBox(height: mediaQuery.size.height * 0.03),
                      // setSignInLabel(),
                      setCodeWithMono(),
                      verifyBtn(),
                      termAndPolicyTxt()

                      // loginBtn(),

                      // SizedBox(height: 16),

                      // termAndPolicyTxt(),
                      // SizedBox(height: mediaQuery.size.height * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }*/

  Widget getLogo() {
    return Positioned(
      // textDirection: Directionality.of(context),
      left: (MediaQuery.of(context).size.width / 2) - 50,
      // right: ((MediaQuery.of(context).size.width /2)-55),

      top: (MediaQuery.of(context).size.height * 0.2) - 50,
      //  bottom: height * 0.1,
      child: SizedBox(
        width: 100,
        height: 100,
        child: Image.asset(
          'assets/images/loginlogo.png',
        ),
      ),
    );
  }
}
