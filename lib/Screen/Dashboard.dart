import 'dart:async';
import 'dart:convert';
import 'package:Plumbingbazzar/Screen/pop_up_controller.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import 'package:Plumbingbazzar/Helper/Color.dart';
import 'package:Plumbingbazzar/Helper/Constant.dart';
import 'package:Plumbingbazzar/Helper/PushNotificationService.dart';
import 'package:Plumbingbazzar/Helper/Session.dart';
import 'package:Plumbingbazzar/Helper/String.dart';
import 'package:Plumbingbazzar/Model/Section_Model.dart';
import 'package:Plumbingbazzar/Provider/UserProvider.dart';
import 'package:Plumbingbazzar/Screen/Login.dart';
import 'package:Plumbingbazzar/Screen/MyProfile.dart';
import 'package:Plumbingbazzar/Screen/Product_Detail.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:http/http.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/UserDetails.dart';
import 'All_Category.dart';
import 'Cart.dart';
import 'Favorite.dart';
import 'HomePage.dart';
import 'NotificationLIst.dart';
import 'Sale.dart';
import 'Search.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Dashboard> with TickerProviderStateMixin {
  int _selBottom = 0;
  late TabController _tabController;
  bool _isNetworkAvail = true;

  @override
  void initState() {
    super.initState();

    final popupController = Get.put(PopupController());

    _tabController = TabController(length: 5, vsync: this);

    // Show popup on Home tab after UI build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      popupController.setContext(context);
      if (_tabController.index == 0) {
        popupController.fetchAndStartPopup();
      }
    });

    _tabController.addListener(() async {
      if (!_tabController.indexIsChanging) {
        final index = _tabController.index;

        // 👇 Show popup only on Home tab
        if (index == 0) {
          popupController.setContext(context);
          popupController.fetchAndStartPopup();
        } else {
          popupController.stopPopup();
        }

        // 👇 Check login on tab 3
        if (index == 3) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? curUserId = prefs.getString('CUR_USERID');
          if (curUserId == null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
            _tabController.animateTo(0);
          }
        }

        setState(() {
          _selBottom = index;
        });
      }
    });

    userDetails();
    initDynamicLinks();
  }


  void initDynamicLinks() async {
    /* FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;

      if (deepLink != null) {
        if (deepLink.queryParameters.length > 0) {
          int index = int.parse(deepLink.queryParameters['index']!);

          int secPos = int.parse(deepLink.queryParameters['secPos']!);

          String? id = deepLink.queryParameters['id'];

          String? list = deepLink.queryParameters['list'];

          getProduct(id!, index, secPos, list == "true" ? true : false);
        }
      }
    }, onError: (OnLinkErrorException e) async {
      print(e.message);
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      if (deepLink.queryParameters.length > 0) {
        int index = int.parse(deepLink.queryParameters['index']!);

        int secPos = int.parse(deepLink.queryParameters['secPos']!);

        String? id = deepLink.queryParameters['id'];

        // String list = deepLink.queryParameters['list'];

        getProduct(id!, index, secPos, true);
      }
    }*/
  }

  Future<UserDetails?> userDetails() async {
    print("dfgdfgdgfdgdgdgassssssssssssssssssssssssssssdfgdgd");
    var header = headers;
    var request = http.MultipartRequest('POST', getUserDetailsApi);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? curUserId = prefs.getString('CUR_USERID');
    request.fields.addAll({'user_id': '$curUserId'});
    print('PriougouigoguiintData____${curUserId}_____');
    request.headers.addAll(header);
    print(request);
    print(request.fields);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      print(str);
      return UserDetails.fromJson(json.decode(str));
    } else {
      return null;
    }
  }
  Future<void> getProduct(String id, int index, int secPos, bool list) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        var parameter = {
          ID: id,
        };

        // if (CUR_USERID != null) parameter[USER_ID] = CUR_USERID;
        Response response =
            await post(getProductApi, headers: headers, body: parameter)
                .timeout(Duration(seconds: timeOut));

        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String msg = getdata["message"];
        if (!error) {
          var data = getdata["data"];

          List<Product> items = [];

          items =
              (data as List).map((data) => new Product.fromJson(data)).toList();

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductDetail1(
                    index: list ? int.parse(id) : index,
                    model: list
                        ? items[0]
                        : sectionList[secPos].productList![index],
                    secPos: secPos,
                    list: list,
                  )));
        } else {
          if (msg != "Products Not Found !") setSnackbar(msg, context);
        }
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!, context);
      }
    } else {
      {
        if (mounted)
          setState(() {
            _isNetworkAvail = false;
          });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('PrintDaaaaaaaaaaaaata____${CUR_USERID}_____');
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Exit"),
                content: Text("Are you sure you want to exit?"),
                actions: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary),
                    child: Text("YES"),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary),
                    child: Text("NO"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
        // if (_tabController.index != 0) {
        //   _tabController.animateTo(0);
        //   return false;
        // }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.lightWhite,
          // appBar: _selBottom == 3 ?
          // _getAppBar1()    : _getAppBar(),
          appBar: _selBottom == 1
              ? _getAppBarF()
              : _selBottom == 2
                  ? _getAppBar2()
                  : _selBottom == 3
                      ? _getAppBar1()
                      : _getAppBar(),

          body: TabBarView(
            controller: _tabController,
            children: [
              HomePage(),
              // AllCategory(),
              Favorite(),
              // Sale(),
              Cart(
                fromBottom: true,
              ),
              MyProfile(),
            ],
          ),
          //fragments[_selBottom],
          bottomNavigationBar: _getBottomBar(),
        ),
      ),
    );
  }

  AppBar _getAppBar1() {
    String? title;

    if (_selBottom == 1)
      title = "Favorite";
    else if (_selBottom == 2)
      title = "My Cart";
    // title = getTranslated(context, 'OFFER');
    else
      title = "";

    return AppBar(
      toolbarHeight: 80,

      centerTitle: true,
      title: Text(
        "Profile",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.white,
      elevation: 2,
    );
  }
  AppBar _getAppBarF() {
    String? title;

    if (_selBottom == 1)
      title = "Favorite";
    else if (_selBottom == 2)
      title = "My Cart";
    // title = getTranslated(context, 'OFFER');
    else
      title = "";

    return AppBar(
      toolbarHeight: 80,
      centerTitle: true,
      title: Text(
        "Favorite",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.white,
      elevation: 2,
    );
  }

  AppBar _getAppBar2() {
    String? title;

    if (_selBottom == 1)
      title = "Favorite";
    else if (_selBottom == 2)
      title = "My Cart";
    // title = getTranslated(context, 'OFFER');
    else
      title = "";

    return AppBar(
      toolbarHeight: 80,
      centerTitle: true,
      title: Text(
        "My Cart",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.white,
      elevation: 2,
    );
  }

  // AppBar _getAppBar() {
  //   String? title;
  //   if (_selBottom == 1)
  //     title = "Favrite";
  //         // getTranslated(context, 'CATEGORY');
  //   else if (_selBottom == 2)
  //     title = getTranslated(context, 'OFFER');
  //   // else if (_selBottom == 3)
  //   //   title = getTranslated(context, 'MYBAG');
  //   // else if (_selBottom == 3) title = getTranslated(context, 'PROFILE');
  //   // if (_selBottom == 3) return null;
  //
  //   return AppBar(
  //     toolbarHeight: 80,
  //     centerTitle: false, // Not needed since title is empty or logo is leading
  //     title: _selBottom == 0
  //         ? null
  //         : Text(
  //       title.toString(),
  //       style: TextStyle(
  //           color: colors.primary, fontWeight: FontWeight.normal),
  //     ),
  //     leadingWidth: 80, // <-- shrink the space for the leading widget
  //
  //     // leading: _selBottom == 0
  //     //     ? Padding(
  //     //   padding: const EdgeInsets.only(left: 12.0),
  //     //   child: Image.asset(
  //     //     'assets/images/home_logo.png',
  //     //     height: 10,
  //     //     width: 20,
  //     //     fit: BoxFit.cover,
  //     //   ),
  //     // )
  //     //     : null,
  //     leading: _selBottom == 0
  //         ? Padding(
  //       padding: const EdgeInsets.only(left: 12.0),
  //       child: SizedBox(
  //         height: 20,  // control vertical size here
  //         width: 30,   // optional, can also be tight fit
  //         child: Image.asset(
  //           'assets/images/home_logo.png',
  //           height: 10, // image itself will shrink too
  //           fit: BoxFit.contain, // or .fitHeight if you want it to stay tall
  //         ),
  //       ),
  //     )
  //         : null,
  //
  //     actions: <Widget>[
  //       // Notification Icon
  //       IconButton(
  //         icon: SvgPicture.asset(
  //           imagePath + "desel_notification.svg",
  //           color: colors.primary,
  //         ),
  //         onPressed: () {
  //           CUR_USERID != null
  //               ? Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => NotificationList(),
  //               ))
  //               : Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => Login(),
  //               ));
  //         },
  //       ),
  //
  //       // Search Icon
  //       IconButton(
  //         icon: SvgPicture.asset(
  //           imagePath + "search.svg",
  //           height: 20,
  //           color: colors.primary,
  //         ),
  //         onPressed: () {
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => Search(),
  //               ));
  //         },
  //       ),
  //
  //       // Favorite Icon
  //       IconButton(
  //         padding: EdgeInsets.all(0),
  //         icon: SvgPicture.asset(
  //           imagePath + "desel_fav.svg",
  //           color: colors.primary,
  //         ),
  //         onPressed: () {
  //           CUR_USERID != null
  //               ? Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => Favorite(),
  //               ))
  //               : Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => Login(),
  //               ));
  //         },
  //       ),
  //     ],
  //     backgroundColor: Theme.of(context).colorScheme.white,
  //   );
  //
  //   // return AppBar(
  //   //   toolbarHeight: 80,
  //   //   centerTitle: _selBottom == 0 ? true : false,
  //   //   title: _selBottom == 0
  //   //       ? Image.asset(
  //   //           'assets/images/home_logo.png',
  //   //
  //   //           height: 60,
  //   //
  //   //           width: 200,
  //   //           // height: 25,
  //   //           //s
  //   //           // width: 45,
  //   //         )
  //   //       : Text(
  //   //           title!,
  //   //           style: TextStyle(
  //   //               color: colors.primary, fontWeight: FontWeight.normal),
  //   //         ),
  //   //
  //   //   leading: _selBottom == 0
  //   //       ? InkWell(
  //   //           child: Center(
  //   //               child: SvgPicture.asset(
  //   //             imagePath + "search.svg",
  //   //             height: 20,
  //   //             color: colors.primary,
  //   //           )),
  //   //           onTap: () {
  //   //             Navigator.push(
  //   //                 context,
  //   //                 MaterialPageRoute(
  //   //                   builder: (context) => Search(),
  //   //                 ));
  //   //           },
  //   //         )
  //   //       : null,
  //   //   // iconTheme: new IconThemeData(color: colors.primary),
  //   //   // centerTitle:_curSelected == 0? false:true,
  //   //   actions: <Widget>[
  //   //     _selBottom == 0
  //   //         ? Container()
  //   //         : IconButton(
  //   //             icon: SvgPicture.asset(
  //   //               imagePath + "search.svg",
  //   //               height: 20,
  //   //               color: colors.primary,
  //   //             ),
  //   //             onPressed: () {
  //   //               Navigator.push(
  //   //                   context,
  //   //                   MaterialPageRoute(
  //   //                     builder: (context) => Search(),
  //   //                   ));
  //   //             }),
  //   //     IconButton(
  //   //       icon: SvgPicture.asset(
  //   //         imagePath + "desel_notification.svg",
  //   //         color: colors.primary,
  //   //       ),
  //   //       onPressed: () {
  //   //         CUR_USERID != null
  //   //             ? Navigator.push(
  //   //                 context,
  //   //                 MaterialPageRoute(
  //   //                   builder: (context) => NotificationList(),
  //   //                 ))
  //   //             : Navigator.push(
  //   //                 context,
  //   //                 MaterialPageRoute(
  //   //                   builder: (context) => Login(),
  //   //                 ));
  //   //       },
  //   //     ),
  //   //     IconButton(
  //   //       padding: EdgeInsets.all(0),
  //   //       icon: SvgPicture.asset(
  //   //         imagePath + "desel_fav.svg",
  //   //         color: colors.primary,
  //   //       ),
  //   //       onPressed: () {
  //   //         CUR_USERID != null
  //   //             ? Navigator.push(
  //   //                 context,
  //   //                 MaterialPageRoute(
  //   //                   builder: (context) => Favorite(),
  //   //                 ))
  //   //             : Navigator.push(
  //   //                 context,
  //   //                 MaterialPageRoute(
  //   //                   builder: (context) => Login(),
  //   //                 ));
  //   //       },
  //   //     ),
  //   //   ],
  //   //   backgroundColor: Theme.of(context).colorScheme.white,
  //   // );
  // }

  AppBar _getAppBar() {
    String? title;
    if (_selBottom == 1)
      title = "Favorite";
    else if (_selBottom == 2)
      title = "MY Cart";

    return AppBar(
      toolbarHeight: 80,
      automaticallyImplyLeading: false, // Prevent default back button
      centerTitle: _selBottom == 1 ? true : false,
      title: _selBottom == 0
          ? Row(
        children: [
          Container(
            width: 80,
            // color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: SizedBox(
                height: 60,
                width: 20,
                child: Image.asset(
                  'assets/images/home_icons.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title ?? '',
            style: TextStyle(
              color: colors.primary,
              fontWeight: FontWeight.normal,
              fontSize: 18,
            ),
          ),
        ],
      )
          : Text(
        title ?? '',
        style: TextStyle(
          color: colors.primary,
          fontWeight: FontWeight.normal,
          fontSize: 18,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.white,
      elevation: 2,
      actions: _selBottom == 1
          ? [] // No icons when on Favorite tab
          : <Widget>[

        IconButton(
          icon: Image.asset(
            imagePath + "search.png",
            height: 40,
            // color: colors.darkIcon,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Search(),
              ),
            );
          },
        ),
        IconButton(
          icon: Image.asset(
            imagePath + "desel_notification.png",
            // color: colors.darkIcon,
          ),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? curUserId = prefs.getString('CUR_USERID');
            curUserId != null
                ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationList(),
                ))
                : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ));
          },
        ),

      ],
    );
  }

  // AppBar _getAppBar() {
  //   String? title;
  //   if (_selBottom == 1)
  //     title = "Favorite";
  //   else if (_selBottom == 2) title = "MY Cart";
  //   // title = getTranslated(context, 'OFFER');
  //
  //   return AppBar(
  //     toolbarHeight: 80,
  //     centerTitle: _selBottom == 1 ? true : false,
  //     title: Text(
  //       title ?? '',
  //       style: TextStyle(
  //         color: colors.primary,
  //         fontWeight: FontWeight.normal,
  //         fontSize: 18,
  //       ),
  //     ),
  //     backgroundColor: Theme.of(context).colorScheme.white,
  //     elevation: 0,
  //     _selBottom == 1
  //         ? null
  //         : _selBottom == 0
  //         ? Container(
  //       width: 100,
  //       color: Colors.red,
  //       child: Padding(
  //         padding: const EdgeInsets.only(left: 30.0),
  //         child: SizedBox(
  //           height: 30,
  //           width: 40,
  //           child: Image.asset(
  //             'assets/images/home_icons.png',
  //             fit: BoxFit.contain,
  //           ),
  //         ),
  //       ),
  //     )
  //         : null,
  //
  //
  //   // ✅ Remove leading & actions when on Favorite tab
  //     // leading: _selBottom == 1
  //     //     ? null
  //     //     : _selBottom == 0
  //     //         ? Container(
  //     //   width: 100,
  //     //             color: Colors.red,
  //     //             child: Padding(
  //     //               padding: const EdgeInsets.only(left: 30.0),
  //     //               child: SizedBox(
  //     //                 height: 30,
  //     //                 width: 40,
  //     //                 child: Image.asset(
  //     //                   'assets/images/home_icons.png',
  //     //                   fit: BoxFit.contain,
  //     //                 ),
  //     //               ),
  //     //             ),
  //     //           )
  //     //         : null,
  //
  //     actions: _selBottom == 1
  //         ? [] // No icons when on Favorite
  //         : <Widget>[
  //             IconButton(
  //               icon: SvgPicture.asset(
  //                 imagePath + "desel_notification.svg",
  //                 color: colors.darkIcon,
  //               ),
  //               onPressed: () {
  //                 CUR_USERID != null
  //                     ? Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                           builder: (context) => NotificationList(),
  //                         ))
  //                     : Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                           builder: (context) => Login(),
  //                         ));
  //               },
  //             ),
  //             IconButton(
  //               icon: SvgPicture.asset(
  //                 imagePath + "search.svg",
  //                 height: 20,
  //                 color: colors.darkIcon,
  //               ),
  //               onPressed: () {
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => Search(),
  //                     ));
  //               },
  //             ),
  //             // IconButton(
  //             //   padding: EdgeInsets.all(0),
  //             //   icon: SvgPicture.asset(
  //             //     imagePath + "desel_fav.svg",
  //             //     color: colors.primary,
  //             //   ),
  //             //   onPressed: () {
  //             //     CUR_USERID != null
  //             //         ? Navigator.push(
  //             //         context,
  //             //         MaterialPageRoute(
  //             //           builder: (context) => Favorite(),
  //             //         ))
  //             //         : Navigator.push(
  //             //         context,
  //             //         MaterialPageRoute(
  //             //           builder: (context) => Login(),
  //             //         ));
  //             //   },
  //             // ),
  //           ],
  //   );
  // }

  Widget _getBottomBar() {
    return Material(
        color: Theme.of(context).colorScheme.white,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.white,
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).colorScheme.black26, blurRadius: 10)
            ],
          ),
          child: TabBar(
            onTap: (_) async {
              if (_tabController.index == 3) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? curUserId = prefs.getString('CUR_USERID');
                if (curUserId == null) {
                  print('PrintDaaaaaaaaaaaaata____${CUR_USERID}_____');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                  _tabController.animateTo(0);
                }
              }
            },
            controller: _tabController,
            tabs: [
              Tab(
                icon: _selBottom == 0
                    ? SvgPicture.asset(
                        imagePath + "home001.svg",
                        // imagePath + "sel_home.svg",
                        // color: colors.primary,
                      )
                    : SvgPicture.asset(
                        imagePath + "Home002.svg",
                        // color: Colors.grey,
                      ),
                text: _selBottom == 0 ? getTranslated(context, 'HOME_LBL') : null,
              ),
              Tab(
                icon: _selBottom == 1
                    ? SvgPicture.asset(
                        imagePath + "Heart001.svg",
                        // color: colors.primary,
                      )
                    : SvgPicture.asset(
                        imagePath + "Heart.svg",
                        color: Colors.grey,
                      ),
                text:
                    _selBottom == 1 ? /*getTranslated(context, 'category')*/"Favrite" : null,
              ),
              // Tab(
              //   icon: _selBottom == 2
              //       ? SvgPicture.asset(
              //           imagePath + "sale02.svg",
              //           color: colors.primary,
              //         )
              //       : SvgPicture.asset(
              //           imagePath + "sale.svg",
              //           color: colors.primary,
              //         ),
              //   text: _selBottom == 2 ? getTranslated(context, 'SALE') : null,
              // ),
              Tab(
                icon: Selector<UserProvider, String>(
                  builder: (context, data, child) {
                    return Stack(
                      children: [
                        Center(
                          child: _selBottom == 2
                              ? SvgPicture.asset(
                                  imagePath + "cart001.svg",
                                  // color: colors.primary,
                                )
                              : SvgPicture.asset(
                                  imagePath + "cart01.svg",
                                  color: Colors.grey,
                                ),
                        ),
                        (data != null && data.isNotEmpty && data != "0")
                            ? new Positioned.directional(
                                bottom: _selBottom == 3 ? 6 : 20,
                                textDirection: Directionality.of(context),
                                end: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: colors.primary),
                                  child: new Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(3),
                                      child: new Text(
                                        data,
                                        style: TextStyle(
                                            fontSize: 7,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .white),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    );
                  },
                  selector: (_, homeProvider) => homeProvider.curCartCount,
                ),
                text: _selBottom == 2 ? getTranslated(context, 'CART') : null,
              ),
              Tab(
                icon: _selBottom == 3
                    ? SvgPicture.asset(
                        imagePath + "profile01.svg",
                        color: colors.primary,
                      )
                    : SvgPicture.asset(
                        imagePath + "profile.svg",
                        color: Colors.grey,
                      ),
                text:
                    _selBottom == 3 ? getTranslated(context, 'ACCOUNT') : null,
              ),
            ],
         /*   indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: colors.primary, width: 5.0),
              insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 70.0),
            ),*/
            labelColor: colors.primary,
            labelStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.w600),
          ),
        ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
