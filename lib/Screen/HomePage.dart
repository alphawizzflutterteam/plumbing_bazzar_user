import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:get/get.dart' as getx;
import 'package:Plumbingbazzar/Screen/pop_up_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Plumbingbazzar/Helper/ApiBaseHelper.dart';
import 'package:Plumbingbazzar/Helper/AppBtn.dart';
import 'package:Plumbingbazzar/Helper/Color.dart';
import 'package:Plumbingbazzar/Helper/Constant.dart';
import 'package:Plumbingbazzar/Helper/Session.dart';
import 'package:Plumbingbazzar/Helper/SimBtn.dart';
import 'package:Plumbingbazzar/Helper/String.dart';
import 'package:Plumbingbazzar/Helper/widgets.dart';
import 'package:Plumbingbazzar/Model/Model.dart';
import 'package:Plumbingbazzar/Model/Section_Model.dart';
import 'package:Plumbingbazzar/Provider/CartProvider.dart';
import 'package:Plumbingbazzar/Provider/CategoryProvider.dart';
import 'package:Plumbingbazzar/Provider/FavoriteProvider.dart';
import 'package:Plumbingbazzar/Provider/HomeProvider.dart';
import 'package:Plumbingbazzar/Provider/SettingProvider.dart';
import 'package:Plumbingbazzar/Provider/UserProvider.dart';
import 'package:Plumbingbazzar/Screen/SellerList.dart';
import 'package:Plumbingbazzar/Screen/Seller_Details.dart';
import 'package:Plumbingbazzar/Screen/SubCategory.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';
// import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';
import 'package:video_player/video_player.dart';
import '../Model/homescreen_category.dart';
import '../Model/offer_categories.dart';
import '../Model/offer_categories.dart';
import 'Login.dart';
import 'ProductList.dart';
import 'Product_Detail.dart';
import 'SectionList.dart';
import 'package:http/http.dart' as http;
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

List<SectionModel> sectionList = [];
List<Product> catList = [];
List<Product> popularList = [];
ApiBaseHelper apiBaseHelper = ApiBaseHelper();
List<String> tagList = [];
List<Product> sellerList = [];
int count = 1;
List<Data> homeSliderList = [];
List<Widget> pages = [];
class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage>, TickerProviderStateMixin, WidgetsBindingObserver,RouteAware  {
/*class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage>, TickerProviderStateMixin {*/
  bool _isNetworkAvail = true;

  final _controller = PageController();
  late Animation buttonSqueezeanimation;
  late AnimationController buttonController;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  List<Model> offerImages = [];

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  //String? curPin;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  /*  final popupController = Get.put(PopupController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      popupController.setContext(context);
      popupController.fetchAndStartPopup();

      // 👇 Register to RouteObserver after context is available
      final ModalRoute? modalRoute = ModalRoute.of(context);
    });
*/
    fetchSubCategories();
    fetchSubCategories1();
    fetchSubCategories2();
    offerCatg();
    callApi();

    buttonController = AnimationController(
      duration: Duration(seconds: 200),
      vsync: this,
    );

    buttonSqueezeanimation = Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: buttonController,
        curve: Interval(0.0, 1.1),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _animateSlider());
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 👈 Remove observer
    final popupController = Get.find<PopupController>();
    popupController.stopPopup();
    super.dispose();
  }

/*  void initState() {
    super.initState();
    final PopupController popupController = Get.put(PopupController());

    // Set context if not already
    WidgetsBinding.instance.addPostFrameCallback((_) {
      popupController.setContext(context);
      popupController.fetchAndStartPopup();
    });
    fetchSubCategories();
    offerCatg();
    callApi();
    buttonController = new AnimationController(
        duration: new Duration(seconds: 200), vsync: this);

    buttonSqueezeanimation = new Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(
      new CurvedAnimation(
        parent: buttonController,
        curve: new Interval(
          0.0,
          1.1,
        ),
      ),
    );

    WidgetsBinding.instance!.addPostFrameCallback((_) => _animateSlider());
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isNetworkAvail
          ? RefreshIndicator(
              color: colors.primary,
              key: _refreshIndicatorKey,
              onRefresh: _refresh,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: 20,),
                    // _deliverPincode(),
                    SizedBox(
                      height: 20,
                    ),

                    _slider(),
                    // SizedBox(height: 20,),
                    // _slider(),
                    SizedBox(
                      height: 20,
                    ),
                    mainOffer(),
                    SizedBox(
                      height: 20,
                    ),
                    lineWithText("Sanitary"),
                    _catList(),
                    _section(),

                    SizedBox(
                      height: 20,
                    ),
                    lText("Sanitary"),
                    SizedBox(
                      height: 10,
                    ),
                    listItem(),
                    /*--------------------------------SECTION WISE   1-----------------------------------------------------------------*/

                    SizedBox(
                      height: 20,
                    ),
                    lineWithText1("Sanitary"),
                    _catList1(),
                    _section1(),

                    SizedBox(
                      height: 20,
                    ),
                    lText("Sanitary"),
                    SizedBox(
                      height: 10,
                    ),
                    listItem1(),
                    /*--------------------------------SECTION WISE  2-----------------------------------------------------------------*/

                    SizedBox(
                      height: 20,
                    ),
                    lineWithText2("Sanitary"),
                    _catList2(),
                    _section2(),

                    SizedBox(
                      height: 20,
                    ),
                    lText("Sanitary"),
                    SizedBox(
                      height: 10,
                    ),
                    listItem2(),
                    /*--------------------------------SECTION WISE-----------------------------------------------------------------*/

                    SizedBox(
                      height: 20,
                    ),
                    lineWithText1("Sanitary"),
                    _catList1(),
                    _section1(),

                    SizedBox(
                      height: 20,
                    ),
                    lText("Sanitary"),
                    SizedBox(
                      height: 10,
                    ),
                    listItem1(),
                    // _section1(),
                    // _seller()
                  ],
                ),
              ),
            )
          : noInternet(context),
    );
  }


  Timer? popupTimer;
  String? imageUrl;
  bool _isDialogShowing = false;
/*  Future<String?> fetchImageUrl() async {
    try {
      final response = await http.get(
        Uri.parse('https://plumbing-new.alphawizzserver.com/app/v1/api/get_popup_images'),
      );
      print("Image URL Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check for list and first image
        if (data['data'] != null &&
            data['data'] is List &&
            data['data'].isNotEmpty &&
            data['data'][0]['image'] != null) {
          return data['data'][0]['image'];
        } else {
          print("No image found in API response");
          return null;
        }
      } else {
        print("Failed to fetch image URL: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching image URL: $e");
      return null;
    }
  }


  void fetchAndStartPopup() async {
    if (popupTimer != null && popupTimer!.isActive) return;

    imageUrl = await fetchImageUrl();

    if (imageUrl != null && imageUrl!.isNotEmpty && mounted) {
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          popupTimer = Timer.periodic(Duration(seconds: 3), (timer) {
            if (mounted && !_isDialogShowing) {
              showImagePopup();
            } else if (!mounted) { // If the widget is not mounted, cancel the timer
              timer.cancel();
            }
          });
        }
      });
    }
  }


  void showImagePopup() {
    if (!mounted || _isDialogShowing) {
      print("Cannot show popup - Mounted: $mounted, Dialog showing: $_isDialogShowing");
      return;
    }

    _isDialogShowing = true;
    print('Showing image popup with URL: $imageUrl');

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height*91/100,
            ),
            // padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button
              *//*  Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),*//*
                // Image
                Flexible(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.98,
                    height: MediaQuery.of(context).size.height * 0.23,
                    child: Stack(
                      children: [
                        // The image
                        Positioned.fill(
                          child: Image.network(
                            imageUrl!,
                            fit: BoxFit.fill,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              print("Error loading image: $error");
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.error, size: 50, color: Colors.red),
                                    Text("Failed to load image"),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        // Cross icon
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(), // close the dialog
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
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
        );
      },
    ).then((_) {
      // Reset the flag when dialog is dismissed
      _isDialogShowing = false;
      print('Dialog dismissed, _isDialogShowing reset to false');
    });
  }*/


  Future<Null> _refresh() {
    context.read<HomeProvider>().setCatLoading(true);
    context.read<HomeProvider>().setSecLoading(true);
    context.read<HomeProvider>().setSliderLoading(true);

    return callApi();
  }

//   Widget _slider() {
//
//     double height = deviceWidth! / 2.2;
// print("dfddfffff");
//     return Selector<HomeProvider, bool>(
//       builder: (context, data, child) {
//         return data
//             ? sliderLoading()
//             : Stack(
//                 children: [
//                   Container(
//                     height: height,
//                     width: double.infinity,
//                     // margin: EdgeInsetsDirectional.only(top: 10),
//                     child: PageView.builder(
//                       itemCount: homeSliderList.length,
//                       scrollDirection: Axis.horizontal,
//                       controller: _controller,
//                       physics: AlwaysScrollableScrollPhysics(),
//                       onPageChanged: (index) {
//                         context.read<HomeProvider>().setCurSlider(index);
//                       },
//                       itemBuilder: (BuildContext context, int index) {
//                         print("homeSliderList: ${homeSliderList.length}");
//
//                         return pages[index];
//                       },
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     height: 40,
//                     left: 0,
//                     width: deviceWidth,
//                     child: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: map<Widget>(
//                         homeSliderList,
//                         (index, url) {
//                           return Container(
//                               width: 8.0,
//                               height: 8.0,
//                               margin: EdgeInsets.symmetric(
//                                   vertical: 10.0, horizontal: 2.0),
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: context.read<HomeProvider>().curSlider ==
//                                         index
//                                     ? Theme.of(context).colorScheme.fontColor
//                                     : Theme.of(context).colorScheme.lightBlack,
//                               ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//       },
//       selector: (_, homeProvider) => homeProvider.sliderLoading,
//     );
//   }
  Widget _slider() {
    double height = deviceWidth! / 1.8;
    double width = deviceWidth! * 0.99;

    return Selector<HomeProvider, bool>(
      builder: (context, data, child) {
        // print("xxxxxxxxxxxxxxxxxxxxxxx${data?.model.video}");
        return data
            ? sliderLoading()
            : Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: height,
                    width: width,
                    color: Colors.grey.shade200,
                    child: Stack(
                      children: [
                        // Main PageView slider
                        PageView.builder(
                          itemCount: homeSliderList.length,
                          scrollDirection: Axis.horizontal,
                          controller: _controller,
                          physics: AlwaysScrollableScrollPhysics(),
                          onPageChanged: (index) {
                            context.read<HomeProvider>().setCurSlider(index);
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return pages[index];
                          },
                        ),

                       /*   Positioned(
                        top: 150,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: map<Widget>(
                            homeSliderList,
                                (index, url) {
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: const EdgeInsets.symmetric(horizontal: 3.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: context.read<HomeProvider>().curSlider == index
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.secondary,
                                ),
                              );
                            },
                          ),
                        ),
                      ),*/
                      ],
                    ),
                  ),
                ),
              );
      },
      selector: (_, homeProvider) => homeProvider.sliderLoading,
    );
  }

  Widget _carouselSlider(List<Data> sliderData) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 180,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        autoPlayInterval: Duration(seconds: 5),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
      ),
      items: sliderData.map((slider) {
        final String videoUrl = 'https://plumbingbazzar.com/${slider.video}';
        return NetworkVideoWidget(videoUrl: videoUrl);
      }).toList(),
    );
  }

  void _animateSlider() {
    Future.delayed(Duration(seconds: 30)).then(
      (_) {
        if (mounted) {
          int nextPage = _controller.hasClients
              ? _controller.page!.round() + 1
              : _controller.initialPage;

          if (nextPage == homeSliderList.length) {
            nextPage = 0;
          }
          if (_controller.hasClients)
            _controller
                .animateToPage(nextPage,
                    duration: Duration(milliseconds: 200), curve: Curves.linear)
                .then((_) => _animateSlider());
        }
      },
    );
  }

  // _singleSection() {
  //   print('PrintData____jjjjjjjjjjjjjjjjjjjjjjj_____');
  //   Color back;
  //   // int pos = index % 5;
  //   // if (pos == 0)
  //   //   back = Theme.of(context).colorScheme.back1;
  //   // else if (pos == 1)
  //   //   back = Theme.of(context).colorScheme.back2;
  //   // else if (pos == 2)
  //   //   back = Theme.of(context).colorScheme.back3;
  //   // else if (pos == 3)
  //   //   back = Theme.of(context).colorScheme.back4;
  //   // else
  //   //   back = Theme.of(context).colorScheme.back5;
  //
  //   return products.length > 0
  //       ? Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             Padding(
  //               padding: const EdgeInsets.only(top: 8.0),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: <Widget>[
  //                   // _getHeading(sectionList[index].title ?? "", index),
  //                   _getSection(),
  //                 ],
  //               ),
  //             ),
  //             // products.length > index ? _getOfferImage(index) : Container(),
  //           ],
  //         )
  //       : Container();
  // }

  // _singleSection1(int index) {
  //   Color back;
  //   int pos = index % 5;
  //   if (pos == 0)
  //     back = Theme.of(context).colorScheme.back1;
  //   else if (pos == 1)
  //     back = Theme.of(context).colorScheme.back2;
  //   else if (pos == 2)
  //     back = Theme.of(context).colorScheme.back3;
  //   else if (pos == 3)
  //     back = Theme.of(context).colorScheme.back4;
  //   else
  //     back = Theme.of(context).colorScheme.back5;
  //
  //   return products.length > 0
  //       ? Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             Padding(
  //               padding: const EdgeInsets.only(top: 8.0),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: <Widget>[
  //                   // _getHeading(sectionList[index].title ?? "", index),
  //                   _getSection1(index),
  //                 ],
  //               ),
  //             ),
  //             products.length > index ? _getOfferImage(index) : Container(),
  //           ],
  //         )
  //       : Container();
  // }

  _getHeading(String title, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerRight,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: colors.yellow,
                ),
                padding: EdgeInsetsDirectional.only(
                    start: 10, bottom: 3, top: 3, end: 10),
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: colors.blackTemp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              /*   Positioned(
                  // clipBehavior: Clip.hardEdge,
                  // margin: EdgeInsets.symmetric(horizontal: 20),

                  right: -14,
                  child: SvgPicture.asset("assets/images/eshop.svg"))*/
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(sectionList[index].shortDesc ?? "",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Theme.of(context).colorScheme.fontColor)),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    minimumSize: Size.zero, // <
                    backgroundColor: (Theme.of(context).colorScheme.white),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                child: Text(
                  getTranslated(context, 'SHOP_NOW')!,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      color: Theme.of(context).colorScheme.fontColor,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  SectionModel model = sectionList[index];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SectionList(
                        index: index,
                        section_model: model,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  _getOfferImage(index) {
    print('PrintData____${products[index].image}_____');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWell(
        child: FadeInImage(
          fit: BoxFit.contain,
          fadeInDuration: Duration(milliseconds: 150),
          image: CachedNetworkImageProvider(products[index].image!),
          width: double.maxFinite,
          imageErrorBuilder: (context, error, stackTrace) => erroWidget(50),

          // errorWidget: (context, url, e) => placeHolder(50),
          placeholder: AssetImage(
            "assets/images/sliderph.png",
          ),
        ),
        onTap: () {
          if (offerImages[index].type == "products") {
            Product? item = offerImages[index].list;

            Navigator.push(
              context,
              PageRouteBuilder(
                //transitionDuration: Duration(seconds: 1),
                pageBuilder: (_, __, ___) =>
                    ProductDetail1(model: item, secPos: 0, index: 0, list: true
                        //  title: sectionList[secPos].title,
                        ),
              ),
            );
          } else if (offerImages[index].type == "categories") {
            Product item = offerImages[index].list;
            if (item.subList == null || item.subList!.length == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductList(
                    name: item.name,
                    id: item.id,
                    tag: false,
                    fromSeller: false,
                  ),
                ),
              );
            } else {
             /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubCategory(
                    title: item.name!,
                    subList: item.subList,
                  ),
                ),
              );*/
            }
          }
        },
      ),
    );
  }

  _getSection() {
    print('PrintData____}_____');
    var orient = MediaQuery.of(context).orientation;

    return /*products[i] == DEFAULT*/
         Padding(
            padding: const EdgeInsets.all(15.0),
            child: GridView.count(
              // mainAxisSpacing: 12,
              // crossAxisSpacing: 12,
              padding: EdgeInsetsDirectional.only(top: 5),
              crossAxisCount: 2,
              shrinkWrap: true,
              childAspectRatio: 0.950,

              //  childAspectRatio: 1.0,
              physics: NeverScrollableScrollPhysics(),
              children:
                  //  [
                  //   Container(height: 500, width: 1200, color: Colors.red),
                  //   Text("hello"),
                  //   Container(height: 10, width: 50, color: Colors.green),
                  // ]
                  List.generate(
                    products.length,
                    // products.length < 4
                    //                   ? products.length
                    //                   : 4,
                (index) {
                  print('PrintData____qqqqqqqqq${products.length}_____');
                  // return Container(
                  //   width: 600,
                  //   height: 50,
                  //   color: Colors.red,
                  // );

                  return
                    BranndproductItem(
                      products[index]);
                  // return productItem(i, index, index % 2 == 0 ? true : false);
                },
              ),
            ),
          );
        /* products[i] == STYLE1
            ? products.length > 0
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 3,
                          fit: FlexFit.loose,
                          child: Container(
                            height: orient == Orientation.portrait
                                ? deviceHeight! * 0.4
                                : deviceHeight!,
                            child: BranndproductItem(i, 0, true),
                          ),
                        ),
                        // child: productItem(i, 0, true),),),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.loose,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: orient == Orientation.portrait
                                    ? deviceHeight! * 0.2
                                    : deviceHeight! * 0.5,
                                child: BranndproductItem(i, 1, false),
                              ),
                              // child: productItem(i, 1, false),),
                              Container(
                                height: orient == Orientation.portrait
                                    ? deviceHeight! * 0.2
                                    : deviceHeight! * 0.5,
                                child: BranndproductItem(i, 2, false),
                              ),
                              // child: productItem(i, 2, false),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Container()
            : products[i] == STYLE2
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 2,
                          fit: FlexFit.loose,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  height: orient == Orientation.portrait
                                      ? deviceHeight! * 0.2
                                      : deviceHeight! * 0.5,
                                  child: BranndproductItem(i, 0, true)),
                              // child: productItem(i, 0, true)),
                              Container(
                                height: orient == Orientation.portrait
                                    ? deviceHeight! * 0.2
                                    : deviceHeight! * 0.5,
                                child: BranndproductItem(i, 1, true),
                              ),
                              // child: productItem(i, 1, true),),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          fit: FlexFit.loose,
                          child: Container(
                            height: orient == Orientation.portrait
                                ? deviceHeight! * 0.4
                                : deviceHeight,
                            child: BranndproductItem(i, 2, false),
                          ),
                        ),
                        // child: productItem(i, 2, false),),),
                      ],
                    ),
                  )
                : sectionList[i].style == STYLE3
                    ? Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              flex: 1,
                              fit: FlexFit.loose,
                              child: Container(
                                height: orient == Orientation.portrait
                                    ? deviceHeight! * 0.3
                                    : deviceHeight! * 0.6,
                                child: BranndproductItem(i, 0, false),
                              ),
                            ),
                            // child: productItem(i, 0, false),),),
                            Container(
                              height: orient == Orientation.portrait
                                  ? deviceHeight! * 0.2
                                  : deviceHeight! * 0.5,
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.loose,
                                    child: BranndproductItem(i, 1, true),
                                  ),
                                  // child: productItem(i, 1, true),),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.loose,
                                    child: BranndproductItem(i, 2, true),
                                  ),
                                  // child: productItem(i, 2, true),),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.loose,
                                    child: BranndproductItem(i, 3, false),
                                  ),
                                  // child: productItem(i, 3, false),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : sectionList[i].style == STYLE4
                        ? Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                    flex: 1,
                                    fit: FlexFit.loose,
                                    child: Container(
                                        height: orient == Orientation.portrait
                                            ? deviceHeight! * 0.25
                                            : deviceHeight! * 0.5,
                                        child: BranndproductItem(i, 0, false))),
                                // child: productItem(i, 0, false))),
                                Container(
                                  height: orient == Orientation.portrait
                                      ? deviceHeight! * 0.2
                                      : deviceHeight! * 0.5,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.loose,
                                        child: BranndproductItem(i, 1, true),
                                      ),
                                      // child: productItem(i, 1, true),),
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.loose,
                                        child: BranndproductItem(i, 2, false),
                                      ),
                                      // child: productItem(i, 2, false),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: GridView.count(
                              padding: EdgeInsetsDirectional.only(top: 5),
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              childAspectRatio: 1.2,
                              physics: NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 0,
                              crossAxisSpacing: 0,
                              children: List.generate(
                                sectionList[i].productList!.length < 6
                                    ? sectionList[i].productList!.length
                                    : 6,
                                (index) {
                                  return BranndproductItem(
                                      i, index, index % 2 == 0 ? true : false);
                                  // return productItem(i, index,
                                  //     index % 2 == 0 ? true : false);
                                },
                              ),
                            ),
                          );*/
  }
  _getSection1() {
    print('PrintData____}_____');
    var orient = MediaQuery.of(context).orientation;

    return /*products[i] == DEFAULT*/
         Padding(
            padding: const EdgeInsets.all(15.0),
            child: GridView.count(
              // mainAxisSpacing: 12,
              // crossAxisSpacing: 12,
              padding: EdgeInsetsDirectional.only(top: 5),
              crossAxisCount: 2,
              shrinkWrap: true,
              childAspectRatio: 0.950,

              //  childAspectRatio: 1.0,
              physics: NeverScrollableScrollPhysics(),
              children:
                  //  [
                  //   Container(height: 500, width: 1200, color: Colors.red),
                  //   Text("hello"),
                  //   Container(height: 10, width: 50, color: Colors.green),
                  // ]
                  List.generate(
                    products1.length,
                    // products.length < 4
                    //                   ? products.length
                    //                   : 4,
                (index) {
                  print('PrintData____qqqqqqqqq${products1.length}_____');
                  // return Container(
                  //   width: 600,
                  //   height: 50,
                  //   color: Colors.red,
                  // );

                  return
                    BranndproductItem1(
                      products1[index]);
                  // return productItem(i, index, index % 2 == 0 ? true : false);
                },
              ),
            ),
          );
        /* products[i] == STYLE1
            ? products.length > 0
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 3,
                          fit: FlexFit.loose,
                          child: Container(
                            height: orient == Orientation.portrait
                                ? deviceHeight! * 0.4
                                : deviceHeight!,
                            child: BranndproductItem(i, 0, true),
                          ),
                        ),
                        // child: productItem(i, 0, true),),),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.loose,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: orient == Orientation.portrait
                                    ? deviceHeight! * 0.2
                                    : deviceHeight! * 0.5,
                                child: BranndproductItem(i, 1, false),
                              ),
                              // child: productItem(i, 1, false),),
                              Container(
                                height: orient == Orientation.portrait
                                    ? deviceHeight! * 0.2
                                    : deviceHeight! * 0.5,
                                child: BranndproductItem(i, 2, false),
                              ),
                              // child: productItem(i, 2, false),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Container()
            : products[i] == STYLE2
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 2,
                          fit: FlexFit.loose,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  height: orient == Orientation.portrait
                                      ? deviceHeight! * 0.2
                                      : deviceHeight! * 0.5,
                                  child: BranndproductItem(i, 0, true)),
                              // child: productItem(i, 0, true)),
                              Container(
                                height: orient == Orientation.portrait
                                    ? deviceHeight! * 0.2
                                    : deviceHeight! * 0.5,
                                child: BranndproductItem(i, 1, true),
                              ),
                              // child: productItem(i, 1, true),),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          fit: FlexFit.loose,
                          child: Container(
                            height: orient == Orientation.portrait
                                ? deviceHeight! * 0.4
                                : deviceHeight,
                            child: BranndproductItem(i, 2, false),
                          ),
                        ),
                        // child: productItem(i, 2, false),),),
                      ],
                    ),
                  )
                : sectionList[i].style == STYLE3
                    ? Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              flex: 1,
                              fit: FlexFit.loose,
                              child: Container(
                                height: orient == Orientation.portrait
                                    ? deviceHeight! * 0.3
                                    : deviceHeight! * 0.6,
                                child: BranndproductItem(i, 0, false),
                              ),
                            ),
                            // child: productItem(i, 0, false),),),
                            Container(
                              height: orient == Orientation.portrait
                                  ? deviceHeight! * 0.2
                                  : deviceHeight! * 0.5,
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.loose,
                                    child: BranndproductItem(i, 1, true),
                                  ),
                                  // child: productItem(i, 1, true),),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.loose,
                                    child: BranndproductItem(i, 2, true),
                                  ),
                                  // child: productItem(i, 2, true),),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.loose,
                                    child: BranndproductItem(i, 3, false),
                                  ),
                                  // child: productItem(i, 3, false),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : sectionList[i].style == STYLE4
                        ? Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                    flex: 1,
                                    fit: FlexFit.loose,
                                    child: Container(
                                        height: orient == Orientation.portrait
                                            ? deviceHeight! * 0.25
                                            : deviceHeight! * 0.5,
                                        child: BranndproductItem(i, 0, false))),
                                // child: productItem(i, 0, false))),
                                Container(
                                  height: orient == Orientation.portrait
                                      ? deviceHeight! * 0.2
                                      : deviceHeight! * 0.5,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.loose,
                                        child: BranndproductItem(i, 1, true),
                                      ),
                                      // child: productItem(i, 1, true),),
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.loose,
                                        child: BranndproductItem(i, 2, false),
                                      ),
                                      // child: productItem(i, 2, false),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: GridView.count(
                              padding: EdgeInsetsDirectional.only(top: 5),
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              childAspectRatio: 1.2,
                              physics: NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 0,
                              crossAxisSpacing: 0,
                              children: List.generate(
                                sectionList[i].productList!.length < 6
                                    ? sectionList[i].productList!.length
                                    : 6,
                                (index) {
                                  return BranndproductItem(
                                      i, index, index % 2 == 0 ? true : false);
                                  // return productItem(i, index,
                                  //     index % 2 == 0 ? true : false);
                                },
                              ),
                            ),
                          );*/
  }
  _getSection2() {
    print('PrintData____}_____');
    var orient = MediaQuery.of(context).orientation;

    return /*products[i] == DEFAULT*/
         Padding(
            padding: const EdgeInsets.all(15.0),
            child: GridView.count(
              // mainAxisSpacing: 12,
              // crossAxisSpacing: 12,
              padding: EdgeInsetsDirectional.only(top: 5),
              crossAxisCount: 2,
              shrinkWrap: true,
              childAspectRatio: 0.950,

              //  childAspectRatio: 1.0,
              physics: NeverScrollableScrollPhysics(),
              children:
                  //  [
                  //   Container(height: 500, width: 1200, color: Colors.red),
                  //   Text("hello"),
                  //   Container(height: 10, width: 50, color: Colors.green),
                  // ]
                  List.generate(
                    products2.length,
                    // products.length < 4
                    //                   ? products.length
                    //                   : 4,
                (index) {
                  print('PrintData____qqqqqqqqq${products2.length}_____');
                  // return Container(
                  //   width: 600,
                  //   height: 50,
                  //   color: Colors.red,
                  // );

                  return
                    BranndproductItem2(
                      products2[index]);
                  // return productItem(i, index, index % 2 == 0 ? true : false);
                },
              ),
            ),
          );

  }

  // _getSection1(int i) {
  //   var orient = MediaQuery.of(context).orientation;
  //
  //   return sectionList[i].style == DEFAULT
  //       ? Padding(
  //           padding: const EdgeInsets.all(15.0),
  //           child: Column(
  //             children: List.generate(
  //               sectionList[i].productList!.length < 4
  //                   ? sectionList[i].productList!.length
  //                   : 4,
  //               (index) {
  //                 return Padding(
  //                   padding: const EdgeInsets.only(bottom: 12.0),
  //                   child: productItem(i, index, index % 2 == 0),
  //                 );
  //               },
  //             ),
  //           ),
  //         )
  //
  //       // Padding(
  //       //         padding: const EdgeInsets.all(15.0),
  //       //         child: GridView.count(
  //       //           // mainAxisSpacing: 12,
  //       //           // crossAxisSpacing: 12,
  //       //           padding: EdgeInsetsDirectional.only(top: 5),
  //       //           crossAxisCount: 2,
  //       //           shrinkWrap: true,
  //       //           childAspectRatio: 0.550,
  //       //
  //       //           //  childAspectRatio: 1.0,
  //       //           physics: NeverScrollableScrollPhysics(),
  //       //           children:
  //       //               //  [
  //       //               //   Container(height: 500, width: 1200, color: Colors.red),
  //       //               //   Text("hello"),
  //       //               //   Container(height: 10, width: 50, color: Colors.green),
  //       //               // ]
  //       //               List.generate(
  //       //             sectionList[i].productList!.length < 4
  //       //                 ? sectionList[i].productList!.length
  //       //                 : 4,
  //       //             (index) {
  //       //               // return Container(
  //       //               //   width: 600,
  //       //               //   height: 50,
  //       //               //   color: Colors.red,
  //       //               // );
  //       //
  //       //               // return BranndproductItem(i, index, index % 2 == 0 ? true : false);
  //       //               return productItem(i, index, index % 2 == 0 ? true : false);
  //       //             },
  //       //           ),
  //       //         ),
  //       //       )
  //       : sectionList[i].style == STYLE1
  //           ? sectionList[i].productList!.length > 0
  //               ? Padding(
  //                   padding: const EdgeInsets.all(15.0),
  //                   child: Row(
  //                     children: [
  //                       Flexible(
  //                         flex: 3,
  //                         fit: FlexFit.loose,
  //                         child: Container(
  //                           height: orient == Orientation.portrait
  //                               ? deviceHeight! * 0.4
  //                               : deviceHeight!,
  //                           // child: BranndproductItem(i, 0, true),),),
  //                           child: productItem(i, 0, true),
  //                         ),
  //                       ),
  //                       Flexible(
  //                         flex: 2,
  //                         fit: FlexFit.loose,
  //                         child: Column(
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             Container(
  //                               height: orient == Orientation.portrait
  //                                   ? deviceHeight! * 0.2
  //                                   : deviceHeight! * 0.5,
  //                               // child: BranndproductItem(i, 1, false),),
  //                               child: productItem(i, 1, false),
  //                             ),
  //                             Container(
  //                               height: orient == Orientation.portrait
  //                                   ? deviceHeight! * 0.2
  //                                   : deviceHeight! * 0.5,
  //                               // child: BranndproductItem(i, 2, false),),
  //                               child: productItem(i, 2, false),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 )
  //               : Container()
  //           : sectionList[i].style == STYLE2
  //               ? Padding(
  //                   padding: const EdgeInsets.all(15.0),
  //                   child: Row(
  //                     children: [
  //                       Flexible(
  //                         flex: 2,
  //                         fit: FlexFit.loose,
  //                         child: Column(
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             Container(
  //                                 height: orient == Orientation.portrait
  //                                     ? deviceHeight! * 0.2
  //                                     : deviceHeight! * 0.5,
  //                                 // child: BranndproductItem(i, 0, true)),
  //                                 child: productItem(i, 0, true)),
  //                             Container(
  //                               height: orient == Orientation.portrait
  //                                   ? deviceHeight! * 0.2
  //                                   : deviceHeight! * 0.5,
  //                               // child: BranndproductItem(i, 1, true),),
  //                               child: productItem(i, 1, true),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       Flexible(
  //                         flex: 3,
  //                         fit: FlexFit.loose,
  //                         child: Container(
  //                           height: orient == Orientation.portrait
  //                               ? deviceHeight! * 0.4
  //                               : deviceHeight,
  //                           // child: BranndproductItem(i, 2, false),),),
  //                           child: productItem(i, 2, false),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 )
  //               : sectionList[i].style == STYLE3
  //                   ? Padding(
  //                       padding: const EdgeInsets.all(15.0),
  //                       child: Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           Flexible(
  //                             flex: 1,
  //                             fit: FlexFit.loose,
  //                             child: Container(
  //                               height: orient == Orientation.portrait
  //                                   ? deviceHeight! * 0.3
  //                                   : deviceHeight! * 0.6,
  //                               // child: BranndproductItem(i, 0, false),),),
  //                               child: productItem(i, 0, false),
  //                             ),
  //                           ),
  //                           Container(
  //                             height: orient == Orientation.portrait
  //                                 ? deviceHeight! * 0.2
  //                                 : deviceHeight! * 0.5,
  //                             child: Row(
  //                               children: [
  //                                 Flexible(
  //                                   flex: 1,
  //                                   fit: FlexFit.loose,
  //                                   // child: BranndproductItem(i, 1, true),),
  //                                   child: productItem(i, 1, true),
  //                                 ),
  //                                 Flexible(
  //                                   flex: 1,
  //                                   fit: FlexFit.loose,
  //                                   // child: BranndproductItem(i, 2, true),),
  //                                   child: productItem(i, 2, true),
  //                                 ),
  //                                 Flexible(
  //                                   flex: 1,
  //                                   fit: FlexFit.loose,
  //                                   // child: BranndproductItem(i, 3, false),),
  //                                   child: productItem(i, 3, false),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     )
  //                   : sectionList[i].style == STYLE4
  //                       ? Padding(
  //                           padding: const EdgeInsets.all(15.0),
  //                           child: Column(
  //                             mainAxisSize: MainAxisSize.min,
  //                             children: [
  //                               Flexible(
  //                                   flex: 1,
  //                                   fit: FlexFit.loose,
  //                                   child: Container(
  //                                       height: orient == Orientation.portrait
  //                                           ? deviceHeight! * 0.25
  //                                           : deviceHeight! * 0.5,
  //                                       // child: BranndproductItem(i, 0, false))),
  //                                       child: productItem(i, 0, false))),
  //                               Container(
  //                                 height: orient == Orientation.portrait
  //                                     ? deviceHeight! * 0.2
  //                                     : deviceHeight! * 0.5,
  //                                 child: Row(
  //                                   children: [
  //                                     Flexible(
  //                                       flex: 1,
  //                                       fit: FlexFit.loose,
  //                                       // child: BranndproductItem(i, 1, true),),
  //                                       child: productItem(i, 1, true),
  //                                     ),
  //                                     Flexible(
  //                                       flex: 1,
  //                                       fit: FlexFit.loose,
  //                                       // child: BranndproductItem(i, 2, false),),
  //                                       child: productItem(i, 2, false),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         )
  //                       : Padding(
  //                           padding: const EdgeInsets.all(15.0),
  //                           child: GridView.count(
  //                             padding: EdgeInsetsDirectional.only(top: 5),
  //                             crossAxisCount: 2,
  //                             shrinkWrap: true,
  //                             childAspectRatio: 1.2,
  //                             physics: NeverScrollableScrollPhysics(),
  //                             mainAxisSpacing: 0,
  //                             crossAxisSpacing: 0,
  //                             children: List.generate(
  //                               sectionList[i].productList!.length < 6
  //                                   ? sectionList[i].productList!.length
  //                                   : 6,
  //                               (index) {
  //                                 // return BranndproductItem(i, index,
  //                                 //     index % 2 == 0 ? true : false);
  //                                 return productItem(
  //                                     i, index, index % 2 == 0 ? true : false);
  //                               },
  //                             ),
  //                           ),
  //                         );
  // }

 /* Widget BranndproductItem(int secPos, int index, bool pad) {
    // if (products.length > index) {
      // double price = double.parse(
      //     sectionList[secPos].productList![index].prVarientList![0].disPrice!);
      // double originalPrice = double.parse(
      //     sectionList[secPos].productList![index].prVarientList![0].price!);

      String? offPer;
      // if (price != 0) {
      //   double off = originalPrice - price;
      //   offPer = ((off * 100) / originalPrice).toStringAsFixed(0);
      // }

      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: const EdgeInsets.all(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            Product model = sectionList[secPos].productList![index];
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetail(
                  model: model,
                  secPos: secPos,
                  index: index,
                  list: false,
                ),
              ),
            );
          },
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Hero(
                  tag:
                      "${products[index].id}",
                      // "${sectionList[secPos].productList![index].id}$secPos$index",
                  child: FadeInImage(
                    image: CachedNetworkImageProvider(products[index].image!),
                    placeholder: placeHolder(deviceWidth! * 0.5),
                    fit: BoxFit.cover,
                    // height: 150, // ✅ Fixed height
                    width: double.infinity, height: double.infinity,
                    imageErrorBuilder: (context, error, stackTrace) =>
                        erroWidget(deviceWidth! * 0.5),
                  ),
                ),
              ),
            *//*  if (offPer != null && offPer != "0")
                Positioned(
// bottom: 120,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "$offPer% OFF",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),*//*
            ],
          ),
        ),
      );

      //   Card(
      //   elevation: 0,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //   margin: const EdgeInsets.all(8),
      //   child: InkWell(
      //     borderRadius: BorderRadius.circular(10),
      //     onTap: () {
      //       Product model = sectionList[secPos].productList![index];
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => ProductDetail(
      //             model: model,
      //             secPos: secPos,
      //             index: index,
      //             list: false,
      //           ),
      //         ),
      //       );
      //     },
      //     child: Stack(
      //       children: [
      //         ClipRRect(
      //           borderRadius: BorderRadius.circular(10),
      //           child: Hero(
      //             tag: "${sectionList[secPos].productList![index].id}$secPos$index",
      //             child: FadeInImage(
      //               image: CachedNetworkImageProvider(
      //                   sectionList[secPos].productList![index].image!),
      //               placeholder: placeHolder(deviceWidth! * 0.5),
      //               fit: BoxFit.cover,
      //               // height: double.infinity,
      //               width: double.infinity,
      //               imageErrorBuilder: (context, error, stackTrace) =>
      //                   erroWidget(deviceWidth! * 0.5),
      //             ),
      //           ),
      //         ),
      //
      //
      //         if (offPer != null && offPer != "0")
      //           Positioned(
      //             top: 8,
      //             right: 8,
      //             child: Container(
      //               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      //               decoration: BoxDecoration(
      //                 color: Colors.red,
      //                 borderRadius: BorderRadius.circular(8),
      //               ),
      //               child: Text(
      //                 "$offPer% OFF",
      //                 style: TextStyle(
      //                   color: Colors.white,
      //                   fontSize: 12,
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //             ),
      //           ),
      //       ],
      //     ),
      //   ),
      // );
    // } else {
    //   return Container();
    // }
  }*/
  Widget BranndproductItem(CategoryProduct product) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      margin: const EdgeInsets.all(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () {
          print('PrintData1111111111____${product.slug}_____');
          /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetail(
                model: product,
                secPos: 0,  // optional or remove if not used
                index: 0,   // optional or remove if not used
                list: false,
              ),
            ),
          );*/
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductList1(
                name: product.name,
                id:product.slug ,
                  fromSeller: false,
                tag: false,



              ),
            ),
          );
         /* Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubCategory(
                title: product.name,
                subList: product.,
              ),
            ),);*/
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Hero(
                tag: "${product.id}",
                child: FadeInImage(
                  image: CachedNetworkImageProvider(product.image),
                  placeholder: placeHolder(deviceWidth! * 0.5),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      erroWidget(deviceWidth! * 0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget BranndproductItem1(CategoryProduct product) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      margin: const EdgeInsets.all(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () {
          print('PrintData1111111111____${product.slug}_____');
          /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetail(
                model: product,
                secPos: 0,  // optional or remove if not used
                index: 0,   // optional or remove if not used
                list: false,
              ),
            ),
          );*/
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductList1(
                name: product.name,
                id:product.slug ,
                  fromSeller: false,
                tag: false,



              ),
            ),
          );
         /* Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubCategory(
                title: product.name,
                subList: product.,
              ),
            ),);*/
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Hero(
                tag: "${product.id}",
                child: FadeInImage(
                  image: CachedNetworkImageProvider(product.image),
                  placeholder: placeHolder(deviceWidth! * 0.5),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      erroWidget(deviceWidth! * 0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget BranndproductItem2(CategoryProduct product) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      margin: const EdgeInsets.all(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () {
          print('PrintData1111111111____${product.slug}_____');
          /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetail(
                model: product,
                secPos: 0,  // optional or remove if not used
                index: 0,   // optional or remove if not used
                list: false,
              ),
            ),
          );*/
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductList1(
                name: product.name,
                id:product.slug ,
                  fromSeller: false,
                tag: false,



              ),
            ),
          );
         /* Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubCategory(
                title: product.name,
                subList: product.,
              ),
            ),);*/
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Hero(
                tag: "${product.id}",
                child: FadeInImage(
                  image: CachedNetworkImageProvider(product.image),
                  placeholder: placeHolder(deviceWidth! * 0.5),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      erroWidget(deviceWidth! * 0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget BranndproductItem3(CategoryProduct product) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      margin: const EdgeInsets.all(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () {
          print('PrintData1111111111____${product.slug}_____');
          /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetail(
                model: product,
                secPos: 0,  // optional or remove if not used
                index: 0,   // optional or remove if not used
                list: false,
              ),
            ),
          );*/
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductList1(
                name: product.name,
                id:product.slug ,
                  fromSeller: false,
                tag: false,



              ),
            ),
          );
         /* Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubCategory(
                title: product.name,
                subList: product.,
              ),
            ),);*/
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Hero(
                tag: "${product.id}",
                child: FadeInImage(
                  image: CachedNetworkImageProvider(product.image),
                  placeholder: placeHolder(deviceWidth! * 0.5),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      erroWidget(deviceWidth! * 0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget productItem(int secPos, int index, bool pad) {
    if (sectionList[secPos].productList!.length <= index)
      return SizedBox.shrink();

    final product = sectionList[secPos].productList![index];
    final imageUrl = product.image!;
    final name = product.name ?? '';

    double disPrice = double.parse(product.prVarientList![0].disPrice!);
    double originalPrice = double.parse(product.prVarientList![0].price!);
    double finalPrice = disPrice == 0 ? originalPrice : disPrice;

    String? offPer;
    if (disPrice != 0) {
      double off = originalPrice - disPrice;
      offPer = ((off * 100) / originalPrice).toStringAsFixed(0);
    }

    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetail1(
                model: product,
                secPos: secPos,
                index: index,
                list: false,
              ),
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 1,
                child: FadeInImage(
                  image: CachedNetworkImageProvider(imageUrl),
                  placeholder: placeHolder(100),
                  imageErrorBuilder: (context, error, stackTrace) =>
                      erroWidget(100),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "$CUR_CURRENCY $finalPrice",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            if (disPrice != 0)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$CUR_CURRENCY ${originalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (offPer != null)
                      Text(
                        "$offPer% OFF",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetail1(
                          model: product,
                          secPos: secPos,
                          index: index,
                          list: false,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  ),
                  child: const Text(
                    "View Details",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Widget productItem(int secPos, int index, bool pad) {
  //   if (sectionList[secPos].productList!.length > index) {
  //     String? offPer;
  //     double price = double.parse(
  //         sectionList[secPos].productList![index].prVarientList![0].disPrice!);
  //     if (price == 0) {
  //       price = double.parse(
  //           sectionList[secPos].productList![index].prVarientList![0].price!);
  //     } else {
  //       double off = double.parse(sectionList[secPos]
  //               .productList![index]
  //               .prVarientList![0]
  //               .price!) -
  //           price;
  //       offPer = ((off * 100) /
  //               double.parse(sectionList[secPos]
  //                   .productList![index]
  //                   .prVarientList![0]
  //                   .price!))
  //           .toStringAsFixed(2);
  //     }
  //
  //     double width = deviceWidth! * 0.5;
  //
  //     return Card(
  //       elevation: 0.0,
  //
  //       margin: EdgeInsetsDirectional.only(bottom: 2, end: 2),
  //       //end: pad ? 5 : 0),
  //       child: InkWell(
  //         borderRadius: BorderRadius.circular(4),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: <Widget>[
  //             Expanded(
  //               /*       child: ClipRRect(
  //                   borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(5),
  //                       topRight: Radius.circular(5)),
  //                   child: Hero(
  //                     tag:
  //                     "${sectionList[secPos].productList![index].id}$secPos$index",
  //                     child: FadeInImage(
  //                       fadeInDuration: Duration(milliseconds: 150),
  //                       image: NetworkImage(
  //                           sectionList[secPos].productList![index].image!),
  //                       height: double.maxFinite,
  //                       width: double.maxFinite,
  //                       fit: extendImg ? BoxFit.fill : BoxFit.contain,
  //                       imageErrorBuilder: (context, error, stackTrace) =>
  //                           erroWidget(width),
  //
  //                       // errorWidget: (context, url, e) => placeHolder(width),
  //                       placeholder: placeHolder(width),
  //                     ),
  //                   )),*/
  //               child: Stack(
  //                 alignment: Alignment.topRight,
  //                 children: [
  //                   ClipRRect(
  //                     borderRadius: BorderRadius.only(
  //                         topLeft: Radius.circular(5),
  //                         topRight: Radius.circular(5)),
  //                     child: Hero(
  //                       transitionOnUserGestures: true,
  //                       tag:
  //                           "${sectionList[secPos].productList![index].id}$secPos$index",
  //                       child: FadeInImage(
  //                         fadeInDuration: Duration(milliseconds: 150),
  //                         image: CachedNetworkImageProvider(
  //                             sectionList[secPos].productList![index].image!),
  //                         height: double.maxFinite,
  //                         width: double.maxFinite,
  //                         imageErrorBuilder: (context, error, stackTrace) =>
  //                             erroWidget(double.maxFinite),
  //                         fit: BoxFit.contain,
  //                         placeholder: placeHolder(width),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsetsDirectional.only(
  //                 start: 5.0,
  //                 top: 3,
  //               ),
  //               child: Text(
  //                 sectionList[secPos].productList![index].name!,
  //                 style: Theme.of(context).textTheme.caption!.copyWith(
  //                     color: Theme.of(context).colorScheme.lightBlack),
  //                 maxLines: 1,
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //             ),
  //             Text(
  //               " " + CUR_CURRENCY! + " " + price.toString(),
  //               style: TextStyle(
  //                 color: Theme.of(context).colorScheme.fontColor,
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 15
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsetsDirectional.only(
  //                   start: 5.0, bottom: 5, top: 3),
  //               child: double.parse(sectionList[secPos]
  //                           .productList![index]
  //                           .prVarientList![0]
  //                           .disPrice!) !=
  //                       0
  //                   ? Row(
  //                       children: <Widget>[
  //                         Text(
  //                           double.parse(sectionList[secPos]
  //                                       .productList![index]
  //                                       .prVarientList![0]
  //                                       .disPrice!) !=
  //                                   0
  //                               ? CUR_CURRENCY! +
  //                                   "" +
  //                                   sectionList[secPos]
  //                                       .productList![index]
  //                                       .prVarientList![0]
  //                                       .price!
  //                               : "",
  //                           style: Theme.of(context)
  //                               .textTheme
  //                               .overline!
  //                               .copyWith(
  //                                   decoration: TextDecoration.lineThrough,
  //                                   letterSpacing: 0,
  //                             fontSize: 15,
  //                             fontWeight: FontWeight.bold
  //                           ),
  //                         ),
  //                         Flexible(
  //                           child: Text(" | " + "$offPer%",
  //                               maxLines: 1,
  //                               overflow: TextOverflow.ellipsis,
  //                               style: Theme.of(context)
  //                                   .textTheme
  //                                   .overline!
  //                                   .copyWith(
  //                                       color: colors.primary,
  //                                       letterSpacing: 0,
  //                                 fontSize: 15,
  //                                 fontWeight: FontWeight.bold
  //                               ),
  //                           ),
  //                         ),
  //                       ],
  //                     )
  //                   : Container(
  //                       height: 5,
  //                     ),
  //             ),
  //           ],
  //         ),
  //         onTap: () {
  //           Product model = sectionList[secPos].productList![index];
  //           Navigator.push(
  //             context,
  //             PageRouteBuilder(
  //               // transitionDuration: Duration(milliseconds: 150),
  //               pageBuilder: (_, __, ___) => ProductDetail(
  //                   model: model, secPos: secPos, index: index, list: false
  //                   //  title: sectionList[secPos].title,
  //                   ),
  //             ),
  //           );
  //         },
  //       ),
  //     );
  //   } else
  //     return Container();
  // }

  _section() {
    print('PrintData____gfggggggggggggggggg_____');
    return Selector<HomeProvider, bool>(
      selector: (_, homeProvider) => homeProvider.secLoading,
      builder: (context, isLoading, child) {
        print('PrintDataaaaaaaaa____${products.length}_____');

        // if (isLoading) {
        //   return Container(
        //     width: double.infinity,
        //     child: Shimmer.fromColors(
        //       baseColor: Theme.of(context).colorScheme.simmerBase,
        //       highlightColor: Theme.of(context).colorScheme.simmerHigh,
        //       child: sectionLoading(),
        //     ),
        //   );
        // }

        if (products.isEmpty) {
          return Center(child: Text("No products found."));
        }
        print("dfffffffffffffffffffffff");
        return  _getSection();

        //   ListView.builder(
        //   padding: EdgeInsets.zero,
        //   itemCount: products.length,
        //   shrinkWrap: true,
        //   physics: NeverScrollableScrollPhysics(),
        //   itemBuilder: (context, index) {
        //     print("Rendering product at index $index");
        //     return _getSection();
        //   },
        // );
      },
    );
  }
  _section1() {
    print('PrintData____gfggggggggggggggggg_____');
    return Selector<HomeProvider, bool>(
      selector: (_, homeProvider) => homeProvider.secLoading,
      builder: (context, isLoading, child) {
        print('PrintDataaaaaaaaa____${products1.length}_____');

        // if (isLoading) {
        //   return Container(
        //     width: double.infinity,
        //     child: Shimmer.fromColors(
        //       baseColor: Theme.of(context).colorScheme.simmerBase,
        //       highlightColor: Theme.of(context).colorScheme.simmerHigh,
        //       child: sectionLoading(),
        //     ),
        //   );
        // }

        if (products1.isEmpty) {
          return Center(child: Text("No products found."));
        }
        print("dfffffffffffffffffffffff");
        return  _getSection1();

        //   ListView.builder(
        //   padding: EdgeInsets.zero,
        //   itemCount: products.length,
        //   shrinkWrap: true,
        //   physics: NeverScrollableScrollPhysics(),
        //   itemBuilder: (context, index) {
        //     print("Rendering product at index $index");
        //     return _getSection();
        //   },
        // );
      },
    );
  }
  _section2() {
    print('PrintData____gfggggggggggggggggg_____');
    return Selector<HomeProvider, bool>(
      selector: (_, homeProvider) => homeProvider.secLoading,
      builder: (context, isLoading, child) {
        print('PrintDataaaaaaaaa____${products2.length}_____');

        // if (isLoading) {
        //   return Container(
        //     width: double.infinity,
        //     child: Shimmer.fromColors(
        //       baseColor: Theme.of(context).colorScheme.simmerBase,
        //       highlightColor: Theme.of(context).colorScheme.simmerHigh,
        //       child: sectionLoading(),
        //     ),
        //   );
        // }

        if (products2.isEmpty) {
          return Center(child: Text("No products found."));
        }
        print("dfffffffffffffffffffffff");
        return  _getSection2();

        //   ListView.builder(
        //   padding: EdgeInsets.zero,
        //   itemCount: products.length,
        //   shrinkWrap: true,
        //   physics: NeverScrollableScrollPhysics(),
        //   itemBuilder: (context, index) {
        //     print("Rendering product at index $index");
        //     return _getSection();
        //   },
        // );
      },
    );
  }

  // _section1() {
  //   return Selector<HomeProvider, bool>(
  //     builder: (context, data, child) {
  //       return data
  //           ? Container(
  //               width: double.infinity,
  //               child: Shimmer.fromColors(
  //                 baseColor: Theme.of(context).colorScheme.simmerBase,
  //                 highlightColor: Theme.of(context).colorScheme.simmerHigh,
  //                 child: sectionLoading(),
  //               ),
  //             )
  //           : ListView.builder(
  //               padding: EdgeInsets.all(0),
  //               itemCount: sectionList.length,
  //               shrinkWrap: true,
  //               physics: NeverScrollableScrollPhysics(),
  //               itemBuilder: (context, index) {
  //                 print("hecxxxxxxxxxxxxxxxre");
  //                 return _singleSection1(index);
  //               },
  //             );
  //     },
  //     selector: (_, homeProvider) => homeProvider.secLoading,
  //   );
  // }
  Widget mainOffer() {
    return offerCategory.isEmpty
        ? Container(
        width: double.infinity,
        child: Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.simmerBase,
            highlightColor: Theme.of(context).colorScheme.simmerHigh,
            child: catLoading()))
        : Container(

      height: 120,
      padding: const EdgeInsets.only(top: 10, left: 10),
      child: ListView.builder(
        itemCount: offerCategory.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final sub = offerCategory[index];
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubCategoryWithBanner(
                      title: offerCategory[index].name!,
                      slug: offerCategory[index].slug!,
                    ),
                  ),);
                // Open the product list via subcategory.url
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => WebViewScreen(url: sub.url, title: sub.name),
                //   ),
                // );
              },
              child:/* Column(
                children: <Widget>[
                  Container(
                    width: 130,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.red,


                    
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        sub.image.toString(),
                      
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),


                  SizedBox(height: 5),
           *//*       Container(
                    width: 70,
                    child: Text(
                      sub.name ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(
                        color:
                        Theme.of(context).colorScheme.fontColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),*//*
                ],
              ),*/
              Column(
            children: <Widget>[
            Stack(
              children: [
              Container(
              width: 130,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.red,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  sub.image.toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.transparent.withOpacity(0.3), // Transparent background
                  borderRadius: BorderRadius.circular(20),
                  // border: Border.all(color: Colors.white, width: 1),
                ),
                child: Text(
                  sub.name ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            ],
          ),
          SizedBox(height: 5),
          ],
          ),

          ),
          );
        },
      ),
    );
  }
  // i  want  to  givwe  the  image   name  of  thre image  ke  upar  with transparent  backgound   white text  with  rounded  border with  white color
  Widget _catList() {
    return subCategories.isEmpty
        ? Container(
            width: double.infinity,
            child: Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.simmerBase,
                highlightColor: Theme.of(context).colorScheme.simmerHigh,
                child: catLoading()))
        : Container(

            height: 120,
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: ListView.builder(
              itemCount: subCategories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final sub = subCategories[index];
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubCategoryWithBanner(
                            title: subCategories[index].name!,
                            slug: subCategories[index].slug!,
                          ),
                        ),);
                      // Open the product list via subcategory.url
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => WebViewScreen(url: sub.url, title: sub.name),
                      //   ),
                      // );
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colors.grey,
                              width: 1, // Optional: adjust border width
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ClipOval(
                              child: Image.network(
                                sub.image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),

                        /*    Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                          ),
                          // color: Colors.white,
                          child: ClipOval(

                            child: Image.network(
                              sub.image,
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),*/
                        // CircleAvatar(
                        //   radius: 40,
                        //   backgroundImage: NetworkImage(sub.image,),f
                        // ),
                        SizedBox(height: 5),
                        Container(
                          width: 70,
                          child: Text(
                            sub.name.toUpperCase() ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.fontColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }
  Widget _catList1() {
    return subCategories1.isEmpty
        ? Container(
            width: double.infinity,
            child: Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.simmerBase,
                highlightColor: Theme.of(context).colorScheme.simmerHigh,
                child: catLoading()))
        : Container(

            height: 120,
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: ListView.builder(
              itemCount: subCategories1.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final sub = subCategories1[index];
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubCategoryWithBanner(
                            title: subCategories1[index].name!,
                            slug: subCategories1[index].slug!,
                          ),
                        ),);
                      // Open the product list via subcategory.url
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => WebViewScreen(url: sub.url, title: sub.name),
                      //   ),
                      // );
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colors.grey,
                              width: 1, // Optional: adjust border width
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ClipOval(
                              child: Image.network(
                                sub.image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),

                        /*    Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                          ),
                          // color: Colors.white,
                          child: ClipOval(

                            child: Image.network(
                              sub.image,
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),*/
                        // CircleAvatar(
                        //   radius: 40,
                        //   backgroundImage: NetworkImage(sub.image,),f
                        // ),
                        SizedBox(height: 5),
                        Container(
                          width: 70,
                          child: Text(
                            sub.name.toUpperCase() ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.fontColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }
  Widget _catList2() {
    return subCategories2.isEmpty
        ? Container(
            width: double.infinity,
            child: Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.simmerBase,
                highlightColor: Theme.of(context).colorScheme.simmerHigh,
                child: catLoading()))
        : Container(

            height: 120,
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: ListView.builder(
              itemCount: subCategories2.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final sub = subCategories2[index];
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubCategoryWithBanner(
                            title: subCategories2[index].name!,
                            slug: subCategories2[index].slug!,
                          ),
                        ),);
                      // Open the product list via subcategory.url
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => WebViewScreen(url: sub.url, title: sub.name),
                      //   ),
                      // );
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colors.grey,
                              width: 1, // Optional: adjust border width
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ClipOval(
                              child: Image.network(
                                sub.image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),

                        /*    Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                          ),
                          // color: Colors.white,
                          child: ClipOval(

                            child: Image.network(
                              sub.image,
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),*/
                        // CircleAvatar(
                        //   radius: 40,
                        //   backgroundImage: NetworkImage(sub.image,),f
                        // ),
                        SizedBox(height: 5),
                        Container(
                          width: 70,
                          child: Text(
                            sub.name.toUpperCase() ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.fontColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }
 /* Widget _catList3() {
    return subCategories3.isEmpty
        ? Container(
            width: double.infinity,
            child: Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.simmerBase,
                highlightColor: Theme.of(context).colorScheme.simmerHigh,
                child: catLoading()))
        : Container(

            height: 120,
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: ListView.builder(
              itemCount: subCategories3.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final sub = subCategories3[index];
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubCategoryWithBanner(
                            title: subCategories3[index].name!,
                            slug: subCategories3[index].slug!,
                          ),
                        ),);
                      // Open the product list via subcategory.url
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => WebViewScreen(url: sub.url, title: sub.name),
                      //   ),
                      // );
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colors.grey,
                              width: 1, // Optional: adjust border width
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ClipOval(
                              child: Image.network(
                                sub.image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),

                        *//*    Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                          ),
                          // color: Colors.white,
                          child: ClipOval(

                            child: Image.network(
                              sub.image,
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),*//*
                        // CircleAvatar(
                        //   radius: 40,
                        //   backgroundImage: NetworkImage(sub.image,),f
                        // ),
                        SizedBox(height: 5),
                        Container(
                          width: 70,
                          child: Text(
                            sub.name.toUpperCase() ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.fontColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }
  Widget _catList4() {
    return subCategories4.isEmpty
        ? Container(
            width: double.infinity,
            child: Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.simmerBase,
                highlightColor: Theme.of(context).colorScheme.simmerHigh,
                child: catLoading()))
        : Container(

            height: 120,
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: ListView.builder(
              itemCount: subCategories4.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final sub = subCategories4[index];
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubCategoryWithBanner(
                            title: subCategories4[index].name!,
                            slug: subCategories4[index].slug!,
                          ),
                        ),);
                      // Open the product list via subcategory.url
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => WebViewScreen(url: sub.url, title: sub.name),
                      //   ),
                      // );
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colors.grey,
                              width: 1, // Optional: adjust border width
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ClipOval(
                              child: Image.network(
                                sub.image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),

                        *//*    Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                          ),
                          // color: Colors.white,
                          child: ClipOval(

                            child: Image.network(
                              sub.image,
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),*//*
                        // CircleAvatar(
                        //   radius: 40,
                        //   backgroundImage: NetworkImage(sub.image,),f
                        // ),
                        SizedBox(height: 5),
                        Container(
                          width: 70,
                          child: Text(
                            sub.name.toUpperCase() ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.fontColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }*/

/*  _catList() {
    return Selector<HomeProvider, bool>(
      builder: (context, data, child) {
        return data
            ? Container(
                width: double.infinity,
                child: Shimmer.fromColors(
                    baseColor: Theme.of(context).colorScheme.simmerBase,
                    highlightColor: Theme.of(context).colorScheme.simmerHigh,
                    child: catLoading()))
            : Container(
                height: 120,
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: ListView.builder(
                  itemCount: catList.length < 10 ? catList.length : 10,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (index == 0)
                      return Container();
                    else
                      return Padding(
                        padding: const EdgeInsetsDirectional.only(end: 10),
                        child: GestureDetector(
                          onTap: () async {
                            if (catList[index].subList == null ||
                                catList[index].subList!.length == 0) {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductList(
                                      name: catList[index].name,
                                      id: catList[index].id,
                                      tag: false,
                                      fromSeller: false,
                                    ),
                                  ));
                            } else {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SubCategory(
                                      title: catList[index].name!,
                                      subList: catList[index].subList,
                                    ),
                                  ),);
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    "${catList[index].image}",

                                ),
                              ),
                              // CircleAvatar(
                              //   child: FadeInImage(
                              //     fadeInDuration: Duration(milliseconds: 150),
                              //     image: CachedNetworkImageProvider(
                              //       catList[index].image!,
                              //     ),
                              //     height: 50.0,
                              //     width: 50.0,
                              //     fit: BoxFit.contain,
                              //     imageErrorBuilder:
                              //         (context, error, stackTrace) =>
                              //         erroWidget(50),
                              //     placeholder: placeHolder(50),
                              //   ),
                              // ),
                              // Container(
                              //   child: Text(
                              //     catList[index].name!,
                              //     style: Theme.of(context)
                              //         .textTheme
                              //         .caption!
                              //         .copyWith(
                              //             color: Theme.of(context)
                              //                 .colorScheme
                              //                 .fontColor,
                              //             fontWeight: FontWeight.w600,
                              //             fontSize: 10),
                              //     overflow: TextOverflow.ellipsis,
                              //     textAlign: TextAlign.center,
                              //   ),
                              //   width: 50,
                              // ),
                              Container(
                                child: Text(
                                  catList[index].name!.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .fontColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                                width: 70,
                              ),
                            ],
                          ),
                        ),
                      );
                  },
                ),
              );
      },
      selector: (_, homeProvider) => homeProvider.catLoading,
    );
  }*/
  Widget lineWithText(String text) {
    return
      categorys.isEmpty ?
      Container(
          width: double.infinity,
          child: Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.simmerBase,
              highlightColor: Theme.of(context).colorScheme.simmerHigh,
              child: catLoading1())):
      Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: <Widget>[
          // Left line
          Expanded(
            flex: 3, // 30%
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              height: 1,
              color: Colors.grey,
            ),
          ),

          // Center text
          Text(
            categorys.first.categoryName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          // Right line
          Expanded(
            flex: 3, // 30%
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              height: 1,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
  Widget lineWithText1(String text) {
    return
      categorys1.isEmpty ?
      Container(
          width: double.infinity,
          child: Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.simmerBase,
              highlightColor: Theme.of(context).colorScheme.simmerHigh,
              child: catLoading1())):
      Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: <Widget>[
          // Left line
          Expanded(
            flex: 3, // 30%
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              height: 1,
              color: Colors.grey,
            ),
          ),

          // Center text
          Text(
            categorys1.first.categoryName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          // Right line
          Expanded(
            flex: 3, // 30%
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              height: 1,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
  Widget lineWithText2(String text) {
    return
      categorys2.isEmpty ?
      Container(
          width: double.infinity,
          child: Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.simmerBase,
              highlightColor: Theme.of(context).colorScheme.simmerHigh,
              child: catLoading1())):
      Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: <Widget>[
          // Left line
          Expanded(
            flex: 3, // 30%
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              height: 1,
              color: Colors.grey,
            ),
          ),

          // Center text
          Text(
            categorys2.first.categoryName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          // Right line
          Expanded(
            flex: 3, // 30%
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              height: 1,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
/*  Widget lineWithText3(String text) {
    return
      categorys4.isEmpty ?
      Container(
          width: double.infinity,
          child: Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.simmerBase,
              highlightColor: Theme.of(context).colorScheme.simmerHigh,
              child: catLoading1())):
      Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: <Widget>[
          // Left line
          Expanded(
            flex: 3, // 30%
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              height: 1,
              color: Colors.grey,
            ),
          ),

          // Center text
          Text(
            categorys4.first.categoryName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          // Right line
          Expanded(
            flex: 3, // 30%
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              height: 1,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }*/

  Widget lText(String text) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          "MOST LIKED PRODUCTS",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  Future<Null> callApi() async {
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    SettingProvider setting =
        Provider.of<SettingProvider>(context, listen: false);

    user.setUserId(setting.userId);

    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      getSetting();
      // getSlider();
      fetchSubCategories();
      fetchSubCategories1();
      offerCatg();
      getCat();
      getSeller();
      // getSection();
      getOfferImages();
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
        });
    }
    return null;
  }

  Future _getFav() async {
    _isNetworkAvail = await isNetworkAvailable();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? curUserId = prefs.getString('CUR_USERID');
    if (_isNetworkAvail) {
      if (curUserId != null) {
        Map parameter = {
          USER_ID: curUserId,
        };
        apiBaseHelper.postAPICall(getFavApi, parameter).then((getdata) {
          bool error = getdata["error"];
          String? msg = getdata["message"];
          if (!error) {
            var data = getdata["data"];

            List<Product> tempList = (data as List)
                .map((data) => new Product.fromJson(data))
                .toList();

            context.read<FavoriteProvider>().setFavlist(tempList);
          } else {
            if (msg != 'No Favourite(s) Product Are Added')
              setSnackbar(msg!, context);
          }

          context.read<FavoriteProvider>().setLoading(false);
        }, onError: (error) {
          setSnackbar(error.toString(), context);
          context.read<FavoriteProvider>().setLoading(false);
        });
      } else {
        context.read<FavoriteProvider>().setLoading(false);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
        });
    }
  }

  void getOfferImages() {
    Map parameter = Map();

    apiBaseHelper.postAPICall(getOfferImageApi, parameter).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        var data = getdata["data"];
        offerImages.clear();
        offerImages =
            (data as List).map((data) => new Model.fromSlider(data)).toList();
      } else {
        setSnackbar(msg!, context);
      }

      context.read<HomeProvider>().setOfferLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setOfferLoading(false);
    });
  }

  Future<void> getSection() async {
    print('PrintData_________');
    // Map parameter = {PRODUCT_LIMIT: "5", PRODUCT_OFFSET: "6"};
    Map parameter = {PRODUCT_LIMIT: "5"};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? curUserId = prefs.getString('CUR_USERID');
    if (curUserId != null) parameter[USER_ID] = curUserId!;
    String curPin = context.read<UserProvider>().curPincode;
    if (curPin != '') parameter[ZIPCODE] = curPin;

    apiBaseHelper.postAPICall(getSectionApi, parameter).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      print("Get Section Data---------: $getdata");
      sectionList.clear();
      if (!error) {
        var data = getdata["data"];
        print("Get Section Data2: $data");
        sectionList = (data as List)
            .map((data) => new SectionModel.fromJson(data))
            .toList();
      } else {
        if (curPin != '') context.read<UserProvider>().setPincode('');
        setSnackbar(msg!, context);
        print("Get Section Error Msg: $msg");
      }
      context.read<HomeProvider>().setSecLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setSecLoading(false);
    });
  }

  Future<void> getSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? curUserId = prefs.getString('CUR_USERID');
    // CUR_USERID = context.read<SettingProvider>().userId;
    //print("")
    Map parameter = Map();
    if (curUserId != null) parameter = {USER_ID: curUserId};

    apiBaseHelper.postAPICall(getSettingApi, parameter).then((getdata) async {
      bool error = getdata["error"];
      String? msg = getdata["message"];

      print("Get Setting Api${getSettingApi.toString()}");
      print(parameter.toString());

      if (!error) {
        var data = getdata["data"]["system_settings"][0];
        cartBtnList = data["cart_btn_on_list"] == "1" ? true : false;
        refer = data["is_refer_earn_on"] == "1" ? true : false;
        CUR_CURRENCY = data["currency"];
        RETURN_DAYS = data['max_product_return_days'];
        MAX_ITEMS = data["max_items_cart"];
        MIN_AMT = data['min_amount'];
        CUR_DEL_CHR = data['delivery_charge'];
        String? isVerion = data['is_version_system_on'];
        extendImg = data["expand_product_images"] == "1" ? true : false;
        String? del = data["area_wise_delivery_charge"];
        MIN_ALLOW_CART_AMT = data[MIN_CART_AMT];

        if (del == "0")
          ISFLAT_DEL = true;
        else
          ISFLAT_DEL = false;

        if (curUserId != null) {
          REFER_CODE = getdata['data']['user_data'][0]['referral_code'];

          context
              .read<UserProvider>()
              .setPincode(getdata["data"]["user_data"][0][PINCODE]);

          if (REFER_CODE == null || REFER_CODE == '' || REFER_CODE!.isEmpty)
            generateReferral();

          context.read<UserProvider>().setCartCount(
              getdata["data"]["user_data"][0]["cart_total_items"].toString());
          context
              .read<UserProvider>()
              .setBalance(getdata["data"]["user_data"][0]["balance"]);

          _getFav();
          fetchSubCategories();
          fetchSubCategories1();
        }

        UserProvider user = Provider.of<UserProvider>(context, listen: false);
        SettingProvider setting =
            Provider.of<SettingProvider>(context, listen: false);
        user.setMobile(setting.mobile);
        user.setName(setting.userName);
        user.setEmail(setting.email);
        user.setProfilePic(setting.profileUrl);

        Map<String, dynamic> tempData = getdata["data"];
        if (tempData.containsKey(TAG))
          tagList = List<String>.from(getdata["data"][TAG]);

        if (isVerion == "1") {
          String? verionAnd = data['current_version'];
          String? verionIOS = data['current_version_ios'];

          // PackageInfo packageInfo = await PackageInfo.fromPlatform();

          // String version = packageInfo.version;

          // final Version currentVersion = Version.parse(version);
          final Version latestVersionAnd = Version.parse(verionAnd.toString());
          final Version latestVersionIos = Version.parse(verionIOS.toString());

          // if ((Platform.isAndroid && latestVersionAnd > currentVersion) ||
          //     (Platform.isIOS && latestVersionIos > currentVersion))
            updateDailog();
        }
      } else {
        setSnackbar(msg!, context);
      }
    }, onError: (error) {
      setSnackbar(error.toString(), context);
    });
  }

  List<SubCategory1> subCategories = [];
  List<offerCategories> offerCategory = [];
  List<CategoryProduct> products = [];
  List<CategoryData> categorys = [];

  Future<void> fetchSubCategories() async  {
    print('PrintData____jhjhj_____');
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      Response response = await post(getCatApi1, headers: headers)
          .timeout(Duration(seconds: timeOut));
      var getdata = json.decode(response.body);
      print("sdddddddddddddddddddddd${getdata}");
      // fetchAndStartPopup();
      if (!getdata['error']) {
        List list = getdata["data"]["sub_categories"];
        List list1 = getdata["data"]["products"];
        Map<String, dynamic> categoryDataMap = getdata["data"];
        subCategories = list.map((e) => SubCategory1.fromJson(e)).toList();
        products = list1.map((e) => CategoryProduct.fromJson(e)).toList();
        CategoryData categoryData = CategoryData.fromJson(categoryDataMap);
        categorys = [categoryData];
        setState(() {});
      }

      print("Error fetching subcategories: $e");
    }
  }
  List<SubCategory1> subCategories1 = [];
  List<offerCategories> offerCategory1 = [];
  List<CategoryProduct> products1 = [];
  List<CategoryData> categorys1 = [];
  Future<void> fetchSubCategories1() async {
    print('Calling fetchSubCategories1 for category: ');
    _isNetworkAvail = await isNetworkAvailable();

    if (_isNetworkAvail) {
      try {
        Map<String, String> body = {
          "category_id": "95",
        };

        final response = await http
            .post(
          Uri.parse(getCatApi1.toString()),
          headers: headers,
          body: body,
        )
            .timeout(Duration(seconds: timeOut));

        final getdata = json.decode(response.body);
        print("API Response: $getdata");

        if (!getdata['error']) {
          List list = getdata["data"]["sub_categories"];
          List list1 = getdata["data"]["products"];
          Map<String, dynamic> categoryDataMap = getdata["data"];

          subCategories1 = list.map((e) => SubCategory1.fromJson(e)).toList();
          products1 = list1.map((e) => CategoryProduct.fromJson(e)).toList();
          CategoryData categoryData = CategoryData.fromJson(categoryDataMap);
          categorys1 = [categoryData];

          setState(() {});
        }
      } catch (e) {
        print("Error fetching subcategories: $e");
      }
    }
  }
  List<SubCategory1> subCategories2 = [];
  List<offerCategories> offerCategory2 = [];
  List<CategoryProduct> products2 = [];
  List<CategoryData> categorys2 = [];
  Future<void> fetchSubCategories2() async {
    print('Calling fetchSubCategories1 for category: ');
    _isNetworkAvail = await isNetworkAvailable();

    if (_isNetworkAvail) {
      try {
        Map<String, String> body = {
          "category_id": "143",
        };

        final response = await http
            .post(
          Uri.parse(getCatApi1.toString()),
          headers: headers,
          body: body,
        )
            .timeout(Duration(seconds: timeOut));

        final getdata = json.decode(response.body);
        print("API Response: $getdata");

        if (!getdata['error']) {
          List list = getdata["data"]["sub_categories"];
          List list1 = getdata["data"]["products"];
          Map<String, dynamic> categoryDataMap = getdata["data"];

          subCategories2 = list.map((e) => SubCategory1.fromJson(e)).toList();
          products2 = list1.map((e) => CategoryProduct.fromJson(e)).toList();
          CategoryData categoryData = CategoryData.fromJson(categoryDataMap);
          categorys2 = [categoryData];

          setState(() {});
        }
      } catch (e) {
        print("Error fetching subcategories: $e");
      }
    }
  }

  Future<void> offerCatg() async {
    print('PrintData____jhjhj_____');
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      Response response = await post(getCatOff, headers: headers)
          .timeout(Duration(seconds: timeOut));
      var getdata = json.decode(response.body);
      print("AAAAAAAAAAAAAAAAAAAAAAAAAA${getdata}");
      if (!getdata['error']) {
        List list = getdata["data"]["categories"];

        // Map<String, dynamic> categoryDataMap = getdata["data"];
        offerCategory = list.map((e) => offerCategories.fromJson(e)).toList();
        // products = list1.map((e) => CategoryProduct.fromJson(e)).toList();
        // CategoryData categoryData = CategoryData.fromJson(categoryDataMap);
        // categorys = [categoryData];
        setState(() {});
      }

      print("Error fetching subcategories: $e");
    }
  }

/*  Future<void> _getCart(String save) async {
    _isNetworkAvail = await isNetworkAvailable();

    if (_isNetworkAvail) {
      try {
        var parameter = {USER_ID: CUR_USERID, SAVE_LATER: save};

        Response response =
            await post(getCartApi, body: parameter, headers: headers)
                .timeout(Duration(seconds: timeOut));

        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String? msg = getdata["message"];
        if (!error) {
          var data = getdata["data"];

          List<SectionModel> cartList = (data as List)
              .map((data) => new SectionModel.fromCart(data))
              .toList();
          context.read<CartProvider>().setCartlist(cartList);
        }
      } on TimeoutException catch (_) {}
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
        });
    }
  }*/

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<Null> generateReferral() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? curUserId = prefs.getString('CUR_USERID');
    String refer = getRandomString(8);

    Map parameter = {
      REFERCODE: refer,
    };

    apiBaseHelper.postAPICall(validateReferalApi, parameter).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        REFER_CODE = refer;

        Map parameter = {
          USER_ID: curUserId,
          REFERCODE: refer,
        };

        apiBaseHelper.postAPICall(getUpdateUserApi, parameter);
      } else {
        if (count < 5) generateReferral();
        count++;
      }

      context.read<HomeProvider>().setSecLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setSecLoading(false);
    });
  }

  updateDailog() async {
    await dialogAnimate(context,
        StatefulBuilder(builder: (BuildContext context, StateSetter setStater) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        title: Text(getTranslated(context, 'UPDATE_APP')!),
        content: Text(
          getTranslated(context, 'UPDATE_AVAIL')!,
          style: Theme.of(this.context)
              .textTheme
              .subtitle1!
              .copyWith(color: Theme.of(context).colorScheme.fontColor),
        ),
        actions: <Widget>[
          new TextButton(
              child: Text(
                getTranslated(context, 'NO')!,
                style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
                    color: Theme.of(context).colorScheme.lightBlack,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              }),
          new TextButton(
              child: Text(
                getTranslated(context, 'YES')!,
                style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
                    color: Theme.of(context).colorScheme.fontColor,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                Navigator.of(context).pop(false);

                String _url = '';
                if (Platform.isAndroid) {
                  _url = androidLink + packageName;
                } else if (Platform.isIOS) {
                  _url = iosLink;
                }

                if (await canLaunch(_url)) {
                  await launch(_url);
                } else {
                  throw 'Could not launch $_url';
                }
              })
        ],
      );
    }));
  }

  Widget homeShimmer() {
    return Container(
      width: double.infinity,
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.simmerBase,
        highlightColor: Theme.of(context).colorScheme.simmerHigh,
        child: SingleChildScrollView(
            child: Column(
          children: [
            catLoading(),
            sliderLoading(),
            sectionLoading(),
          ],
        )),
      ),
    );
  }

  Widget sliderLoading() {
    double width = MediaQuery.of(context).size.width*90/100;
    double height = width / 2;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.simmerBase,
          highlightColor: Theme.of(context).colorScheme.simmerHigh,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            height: height,
            color: Theme.of(context).colorScheme.white,
          )),
    );
  }

  Widget _buildImagePageItem(Model slider) {
    double height = deviceWidth! / 0.5;

    return GestureDetector(
      child: FadeInImage(
          fadeInDuration: Duration(milliseconds: 150),
          image: CachedNetworkImageProvider(slider.image!),
          height: height,
          width: double.maxFinite,
          fit: BoxFit.cover,
          imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                "assets/images/sliderph.png",
                fit: BoxFit.cover,
                height: height,
                color: colors.primary,
              ),
          placeholderErrorBuilder: (context, error, stackTrace) => Image.asset(
                "assets/images/sliderph.png",
                fit: BoxFit.cover,
                height: height,
                color: colors.primary,
              ),
          placeholder: AssetImage(imagePath + "sliderph.png")),
      onTap: () async {
        int curSlider = context.read<HomeProvider>().curSlider;

        /*  if (homeSliderList[curSlider].type == "products") {
          Product? item = homeSliderList[curSlider].list;

          Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => ProductDetail(
                    model: item, secPos: 0, index: 0, list: true)),
          );
        } else if (homeSliderList[curSlider].type == "categories") {
          Product item = homeSliderList[curSlider].list;
          if (item.subList == null || item.subList!.length == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductList(
                    name: item.name,
                    id: item.id,
                    tag: false,
                    fromSeller: false,
                  ),
                ));
          } */ /*else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubCategory(
                    title: item.name!,
                    subList: item.subList,
                  ),
                ));
          }*/
      },
    );
  }

  Widget deliverLoading() {
    return Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.simmerBase,
        highlightColor: Theme.of(context).colorScheme.simmerHigh,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          width: double.infinity,
          height: 18.0,
          color: Theme.of(context).colorScheme.white,
        ));
  }

  Widget catLoading() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
                    .map((_) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.white,
                            shape: BoxShape.circle,
                          ),
                          width: 50.0,
                          height: 50.0,
                        ))
                    .toList()),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          width: double.infinity,
          height: 18.0,
          color: Theme.of(context).colorScheme.white,
        ),
      ],
    );
  }
  Widget catLoading1() {
    return Column(
      children: [

        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          width: double.infinity,
          height: 18.0,
          color: Theme.of(context).colorScheme.white,
        ),
      ],
    );
  }

  // Widget listItem() {
  //     return categorys.isEmpty ? Container() :
  //       Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
  //       child: Stack(
  //         clipBehavior: Clip.none,
  //         children: [
  //           // Card(
  //           //   elevation: 0.1,
  //           //   child: InkWell(
  //           //     borderRadius: BorderRadius.circular(4),
  //           //     child: Row(
  //           //       mainAxisSize: MainAxisSize.min,
  //           //       children: <Widget>[
  //           //         Hero(
  //           //             tag: "$index${favList[index].id}",
  //           //             child: ClipRRect(
  //           //                 borderRadius: BorderRadius.only(
  //           //                     topLeft: Radius.circular(10),
  //           //                     bottomLeft: Radius.circular(10)),
  //           //                 child: Stack(
  //           //                   children: [
  //           //                     FadeInImage(
  //           //                       image: CachedNetworkImageProvider(
  //           //                           favList[index].image!),
  //           //                       height: 125.0,
  //           //                       width: 110.0,
  //           //                       fit: BoxFit.cover,
  //           //
  //           //                       imageErrorBuilder:
  //           //                           (context, error, stackTrace) =>
  //           //                               erroWidget(125),
  //           //
  //           //                       // errorWidget: (context, url, e) => placeHolder(80),
  //           //                       placeholder: placeHolder(125),
  //           //                     ),
  //           //                     Positioned.fill(
  //           //                         child: favList[index].availability == "0"
  //           //                             ? Container(
  //           //                                 height: 55,
  //           //                                 color: Colors.white70,
  //           //                                 // width: double.maxFinite,
  //           //                                 padding: EdgeInsets.all(2),
  //           //                                 child: Center(
  //           //                                   child: Text(
  //           //                                     getTranslated(context,
  //           //                                         'OUT_OF_STOCK_LBL')!,
  //           //                                     style: Theme.of(context)
  //           //                                         .textTheme
  //           //                                         .caption!
  //           //                                         .copyWith(
  //           //                                           color: Colors.red,
  //           //                                           fontWeight:
  //           //                                               FontWeight.bold,
  //           //                                         ),
  //           //                                     textAlign: TextAlign.center,
  //           //                                   ),
  //           //                                 ),
  //           //                               )
  //           //                             : Container()),
  //           //                     off != 0
  //           //                         ? Container(
  //           //                             decoration: BoxDecoration(
  //           //                                 color: colors.red,
  //           //                                 borderRadius:
  //           //                                     BorderRadius.circular(10)),
  //           //                             child: Padding(
  //           //                               padding: const EdgeInsets.all(5.0),
  //           //                               child: Text(
  //           //                                 off.toStringAsFixed(2) + "%",
  //           //                                 style: TextStyle(
  //           //                                     color: colors.whiteTemp,
  //           //                                     fontWeight: FontWeight.bold,
  //           //                                     fontSize: 9),
  //           //                               ),
  //           //                             ),
  //           //                             margin: EdgeInsets.all(5),
  //           //                           )
  //           //                         : Container(),
  //           //                   ],
  //           //                 ))),
  //           //         Expanded(
  //           //           child: Padding(
  //           //             padding: const EdgeInsetsDirectional.only(start: 8.0),
  //           //             child: Column(
  //           //               mainAxisSize: MainAxisSize.min,
  //           //               crossAxisAlignment: CrossAxisAlignment.start,
  //           //               children: <Widget>[
  //           //                 Row(
  //           //                   children: [
  //           //                     Expanded(
  //           //                       child: Text(
  //           //                         favList[index].name!,
  //           //                         style: Theme.of(context)
  //           //                             .textTheme
  //           //                             .subtitle1!
  //           //                             .copyWith(
  //           //                                 color: Theme.of(context)
  //           //                                     .colorScheme
  //           //                                     .lightBlack),
  //           //                         maxLines: 2,
  //           //                         overflow: TextOverflow.ellipsis,
  //           //                       ),
  //           //                     ),
  //           //                     Container(
  //           //                       padding: EdgeInsets.only(right: 5),
  //           //                       child: InkWell(
  //           //                         child: Icon(
  //           //                           Icons.close,
  //           //                           color: Theme.of(context)
  //           //                               .colorScheme
  //           //                               .lightBlack,
  //           //                         ),
  //           //                         onTap: () {
  //           //                           _removeFav(index, favList, context);
  //           //                         },
  //           //                       ),
  //           //                     ),
  //           //                   ],
  //           //                 ),
  //           //                 favList[index].noOfRating! != "0"
  //           //                     ? Row(
  //           //                         children: [
  //           //                           RatingBarIndicator(
  //           //                             rating: double.parse(
  //           //                                 favList[index].rating!),
  //           //                             itemBuilder: (context, index) => Icon(
  //           //                               Icons.star_rate_rounded,
  //           //                               color: Colors.amber,
  //           //                               //color: colors.primary,
  //           //                             ),
  //           //                             unratedColor:
  //           //                                 Colors.grey.withOpacity(0.5),
  //           //                             itemCount: 5,
  //           //                             itemSize: 18.0,
  //           //                             direction: Axis.horizontal,
  //           //                           ),
  //           //                           Text(
  //           //                             " (" + favList[index].noOfRating! + ")",
  //           //                             style: Theme.of(context)
  //           //                                 .textTheme
  //           //                                 .overline,
  //           //                           )
  //           //                         ],
  //           //                       )
  //           //                     : Container(),
  //           //                 Row(
  //           //                   children: <Widget>[
  //           //                     Text(
  //           //                       CUR_CURRENCY! + " " + price.toString() + " ",
  //           //                       style: TextStyle(
  //           //                           color: Theme.of(context)
  //           //                               .colorScheme
  //           //                               .fontColor,
  //           //                           fontWeight: FontWeight.w600),
  //           //                     ),
  //           //                     Text(
  //           //                       double.parse(favList[index]
  //           //                                   .prVarientList![0]
  //           //                                   .disPrice!) !=
  //           //                               0
  //           //                           ? CUR_CURRENCY! +
  //           //                               "" +
  //           //                               favList[index]
  //           //                                   .prVarientList![0]
  //           //                                   .price!
  //           //                           : "",
  //           //                       style: Theme.of(context)
  //           //                           .textTheme
  //           //                           .overline!
  //           //                           .copyWith(
  //           //                               decoration:
  //           //                                   TextDecoration.lineThrough,
  //           //                               letterSpacing: 0.7),
  //           //                     ),
  //           //                   ],
  //           //                 ),
  //           //                 /*  Row(
  //           //                     mainAxisAlignment: MainAxisAlignment.end,
  //           //                     children: [
  //           //                       Container(
  //           //                         height: 20,
  //           //                         child: PopupMenuButton(
  //           //                           padding: EdgeInsets.zero,
  //           //                           onSelected: (dynamic result) async {
  //           //                             if (result == 0) {
  //           //                               _removeFav(index, favList, context);
  //           //                             }
  //           //                             if (result == 1) {
  //           //                               addToCart(index, favList, context);
  //           //                             }
  //           //                             if (result == 2) {}
  //           //                           },
  //           //                           itemBuilder: (BuildContext context) =>
  //           //                               <PopupMenuEntry>[
  //           //                             PopupMenuItem(
  //           //                               value: 0,
  //           //                               child: ListTile(
  //           //                                 dense: true,
  //           //                                 contentPadding:
  //           //                                     EdgeInsetsDirectional.only(
  //           //                                         start: 0.0, end: 0.0),
  //           //                                 leading: Icon(
  //           //                                   Icons.close,
  //           //                                   color: Theme.of(context).colorScheme.fontColor,
  //           //                                   size: 20,
  //           //                                 ),
  //           //                                 title: Text('Remove'),
  //           //                               ),
  //           //                             ),
  //           //                             PopupMenuItem(
  //           //                               value: 1,
  //           //                               child: ListTile(
  //           //                                 dense: true,
  //           //                                 contentPadding:
  //           //                                     EdgeInsetsDirectional.only(
  //           //                                         start: 0.0, end: 0.0),
  //           //                                 leading: Icon(Icons.shopping_cart,
  //           //                                     color: Theme.of(context).colorScheme.fontColor,
  //           //                                     size: 20),
  //           //                                 title: Text('Add to Cart'),
  //           //                               ),
  //           //                             ),
  //           //                             PopupMenuItem(
  //           //                               value: 2,
  //           //                               child: ListTile(
  //           //                                 dense: true,
  //           //                                 contentPadding:
  //           //                                     EdgeInsetsDirectional.only(
  //           //                                         start: 0.0, end: 0.0),
  //           //                                 leading: Icon(
  //           //                                     Icons.share_outlined,
  //           //                                     color: Theme.of(context).colorScheme.fontColor,
  //           //                                     size: 20),
  //           //                                 title: Text('Share'),
  //           //                               ),
  //           //                             ),
  //           //                           ],
  //           //                         ),
  //           //                       ),
  //           //                     ],
  //           //                   )*/
  //           //               ],
  //           //             ),
  //           //           ),
  //           //         ),
  //           //       ],
  //           //     ),
  //           //     splashColor: colors.primary.withOpacity(0.2),
  //           //     onTap: () {
  //           //       Product model = favList[index];
  //           //       Navigator.push(
  //           //         context,
  //           //         PageRouteBuilder(
  //           //             pageBuilder: (_, __, ___) => ProductDetail(
  //           //                   model: model,
  //           //
  //           //                   secPos: 0,
  //           //                   index: index,
  //           //                   list: true,
  //           //                   //  title: productList[index].name,
  //           //                 )),
  //           //       );
  //           //     },
  //           //   ),
  //           // ),
  //           // ListView.builder(
  //           //   itemCount: subCategories.length,
  //           //   scrollDirection: Axis.horizontal,
  //           GridView.builder(
  //             padding: const EdgeInsets.all(8),
  //             shrinkWrap: true,
  //             physics: NeverScrollableScrollPhysics(),
  //             itemCount: categorys.length,
  //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 2,
  //               crossAxisSpacing: 10,
  //               mainAxisSpacing: 10,
  //               childAspectRatio: 0.6,
  //             ),
  //             itemBuilder: (context, index) {
  //               var item = categorys[index];
  //
  //
  //               return Card(
  //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //                 elevation: 1,
  //                 child: InkWell(
  //                   borderRadius: BorderRadius.circular(12),
  //                   onTap: () {
  //                     // Product model = categorys[index];
  //                     // Navigator.push(
  //                     //   context,
  //                     //   PageRouteBuilder(
  //                     //     pageBuilder: (_, __, ___) => ProductDetail(
  //                     //       model: model,
  //                     //       secPos: 0,
  //                     //       index: index,
  //                     //       list: true,
  //                     //     ),
  //                     //   ),
  //                     // );
  //                   },
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Stack(
  //                         children: [
  //                           ClipRRect(
  //                             borderRadius:
  //                             BorderRadius.vertical(top: Radius.circular(12)),
  //                             child: FadeInImage(
  //                               image: CachedNetworkImageProvider(item.mostLikedProducts.first.image!),
  //                               placeholder: placeHolder(150),
  //                               imageErrorBuilder: (context, error, stackTrace) =>
  //                                   erroWidget(150),
  //                               height: 120,
  //                               width: double.infinity,
  //                               fit: BoxFit.cover,
  //                             ),
  //                           ),
  //                           Positioned(
  //                             top: 8,
  //                             right: 8,
  //                             child: CircleAvatar(
  //                               backgroundColor: Colors.white,
  //                               radius: 12,
  //                               child: InkWell(
  //                                 onTap: () {
  //                                   // _removeFav(index, favList, context);
  //                                 },
  //                                 child: Icon(Icons.favorite, color: Colors.red, size: 16),
  //                               ),
  //                             ),
  //                           ),
  //                           // if (item.availability == "0")
  //                             Positioned.fill(
  //                               child: Container(
  //                                 color: Colors.white70,
  //                                 alignment: Alignment.center,
  //                                 child: Text(
  //                                   getTranslated(context, 'OUT_OF_STOCK_LBL')!,
  //                                   style: Theme.of(context).textTheme.caption!.copyWith(
  //                                     color: Colors.red,
  //                                     fontWeight: FontWeight.bold,
  //                                   ),
  //                                   textAlign: TextAlign.center,
  //                                 ),
  //                               ),
  //                             ),
  //                         ],
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //                         child: Text(
  //                           item.mostLikedProducts.first.name!,
  //                           style: Theme.of(context).textTheme.subtitle1!.copyWith(
  //                             fontWeight: FontWeight.w600,
  //                             fontSize: 14,
  //                           ),
  //                           maxLines: 1,
  //                           overflow: TextOverflow.ellipsis,
  //                         ),
  //                       ),
  //                       // Padding(
  //                       //   padding: const EdgeInsets.symmetric(horizontal: 8),
  //                       //   child: Text(
  //                       //     item.desc ?? "ONE PIECE COMMODE",
  //                       //     style: Theme.of(context).textTheme.caption,
  //                       //     maxLines: 1,
  //                       //     overflow: TextOverflow.ellipsis,
  //                       //   ),
  //                       // ),
  //                       // Padding(
  //                       //   padding: const EdgeInsets.symmetric(horizontal: 8),
  //                       //   child: SizedBox(
  //                       //     height: 30, // limit height for compact look
  //                       //     child: Html(
  //                       //       data: item.desc ?? "ONE PIECE COMMODE",
  //                       //       style: {
  //                       //         "body": Style(
  //                       //           margin: Margins.zero,
  //                       //           padding: HtmlPaddings.zero,
  //                       //           fontSize: FontSize.small,
  //                       //           maxLines: 1,
  //                       //           textOverflow: TextOverflow.ellipsis,
  //                       //           color: Theme.of(context).textTheme.caption?.color,
  //                       //         ),
  //                       //       },
  //                       //     ),
  //                       //   ),
  //                       // ),
  //
  //                       // Padding(
  //                       //   padding:
  //                       //   const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //                       //   child: Row(
  //                       //     children: [
  //                       //       RatingBarIndicator(
  //                       //         rating: double.parse(item.rating ?? "0"),
  //                       //         itemBuilder: (context, _) => Icon(
  //                       //           Icons.star,
  //                       //           color: Colors.amber,
  //                       //         ),
  //                       //         unratedColor: Colors.grey[300],
  //                       //         itemCount: 5,
  //                       //         itemSize: 14.0,
  //                       //       ),
  //                       //       SizedBox(width: 4),
  //                       //       Text(
  //                       //         "(${item.noOfRating ?? "0"})",
  //                       //         style: Theme.of(context).textTheme.overline,
  //                       //       ),
  //                       //     ],
  //                       //   ),
  //                       // ),
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(horizontal: 8),
  //                         child: Row(
  //                           children: [
  //                             Text(
  //                               "₹${item.mostLikedProducts.first.price}",
  //                               style: TextStyle(
  //                                 color: Colors.green,
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 14,
  //                               ),
  //                             ),
  //                             SizedBox(width: 4),
  //                             // if (oldPrice != 0)
  //                               Text(
  //                                 "₹${item.mostLikedProducts.first.specialPrice}",
  //                                 style: TextStyle(
  //                                   decoration: TextDecoration.lineThrough,
  //                                   color: Colors.grey,
  //                                   fontSize: 12,
  //                                 ),
  //                               ),
  //                           ],
  //                         ),
  //                       ),
  //
  //                       Padding(
  //                         padding:
  //                         const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //                         child: Row(
  //                           children: [
  //                             RatingBarIndicator(
  //                               rating: double.parse(item.mostLikedProducts.first.averageRating.toString() ?? "0"),
  //                               itemBuilder: (context, _) => Icon(
  //                                 Icons.star,
  //                                 color: Colors.amber,
  //                               ),
  //                               unratedColor: Colors.grey[300],
  //                               itemCount: 5,
  //                               itemSize: 14.0,
  //                             ),
  //                             SizedBox(width: 4),
  //                             Text(
  //                               "(${item.mostLikedProducts.first.averageRating ?? "0"})",
  //                               style: Theme.of(context).textTheme.overline,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       Spacer(),
  //                       Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: SizedBox(
  //                           width: double.infinity,
  //                           child: ElevatedButton(
  //                             style: ElevatedButton.styleFrom(
  //                               backgroundColor: ColorResources.buttonColor,
  //                               padding: EdgeInsets.symmetric(vertical: 8),
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(8),
  //                               ),
  //                             ),
  //                             child: Text("View Details"),
  //                             onPressed: () {
  //                              /* Product model = categorys[index];
  //                               Navigator.push(
  //                                 context,
  //                                 PageRouteBuilder(
  //                                   pageBuilder: (_, __, ___) => ProductDetail(
  //                                     model: model,
  //                                     secPos: 0,
  //                                     index: index,
  //                                     list: true,
  //                                   ),
  //                                 ),
  //                               );*/
  //                             },
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               );
  //             },
  //           )
  //           ,
  //           // Positioned(
  //           //   bottom: -10,
  //           //   right: 180,
  //           //   child: InkWell(
  //           //     onTap: () {
  //           //       if (_isProgress == false) addToCart(index, favList, context);
  //           //
  //           //       /*  addToCart(
  //           //                     index,
  //           //                     (int.parse(model
  //           //                                 .prVarientList![model.selVarient!]
  //           //                                 .cartCount!) +
  //           //                             int.parse(model.qtyStepSize!))
  //           //                         .toString());*/
  //           //     },
  //           //     child: SvgPicture.asset(
  //           //       imagePath + 'bag.svg',
  //           //       color: colors.primary,
  //           //     ),
  //           //   ),
  //           // )
  //         ],
  //       ),
  //     );
  // }

/*  Widget listItem() {
    return categorys.isEmpty
        ? Container()
        : Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: categorys.length,
        itemBuilder: (context, index) {
          var item = categorys[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.mostLikedProducts.first.name ?? "Category",
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: item.mostLikedProducts.length,
                itemBuilder: (context, prodIndex) {
                  final product = item.mostLikedProducts[prodIndex];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        // Navigate to details if needed
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                            child: FadeInImage(
                              image: CachedNetworkImageProvider(product.image ?? ""),
                              placeholder: placeHolder(120),
                              imageErrorBuilder: (context, error, stackTrace) =>
                                  erroWidget(120),
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        "₹${product.price}",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "₹${product.specialPrice}",
                                        style: TextStyle(
                                          decoration:
                                          TextDecoration.lineThrough,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  RatingBarIndicator(
                                    rating: double.tryParse(product.averageRating.toString()) ?? 0.0,
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    unratedColor: Colors.grey[300],
                                    itemCount: 5,
                                    itemSize: 16.0,
                                  ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        ColorResources.buttonColor,
                                        padding: EdgeInsets.symmetric(vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text("View Details"),
                                      onPressed: () {
                                        // Navigation logic
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }*/

  Widget listItem() {
    return categorys.isEmpty
        ? Container()
        : Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: categorys.length,
        itemBuilder: (context, index) {
          final category = categorys[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           /*   Text(
                category.mostLikedProducts.first.name ?? "Category",
                style: Theme.of(context).textTheme.headline6,
              ),*/
              const SizedBox(height: 8),
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: category.mostLikedProducts.length,
                  itemBuilder: (context, pIndex) {
                    final product = category.mostLikedProducts[pIndex];
                    print('PrintData____${category.mostLikedProducts.first.image}_____');
                    return Container(
                      width: 160, // control card width
                      // margin: EdgeInsets.only(right: 12),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    child: FadeInImage(
                                      image: CachedNetworkImageProvider(product.image!),
                                      placeholder: placeHolder(100),
                                      imageErrorBuilder: (ctx, e, st) => erroWidget(100),
                                      height: 115,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // favImg(category ),
                                ],
                              ),

                              /*ClipRRect(
                              *//*  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12)
                                ),*//*
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: FadeInImage(
                                  image: CachedNetworkImageProvider(product.image!),
                                  placeholder: placeHolder(100),
                                  imageErrorBuilder: (ctx, e, st) => erroWidget(100),
                                  height: 115,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),

                              ),*/
                            ),
                            Padding(
                              padding: const EdgeInsets.only(  left: 8.0,right: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                  // const SizedBox(height: 4),
                                  RatingBarIndicator(
                                    rating: double.tryParse(product.averageRating.toString()) ?? 0.0,
                                    itemCount: 5,
                                    itemSize: 14,
                                    unratedColor: Colors.grey[300],
                                    itemBuilder: (ctx, _) => Icon(Icons.star, color: Colors.amber),
                                  ),
                                /*  Row(
                                    children: [
                                      Text(
                                        "₹${product.price}",
                                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "₹${product.specialPrice}",
                                        style: TextStyle(
                                          decoration: TextDecoration.lineThrough,
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),*/


                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        "₹${product.price}",
                                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "₹${product.specialPrice}",
                                        style: TextStyle(
                                          decoration: TextDecoration.lineThrough,
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                /*  RatingBarIndicator(
                                    rating: double.tryParse(product.averageRating.toString()) ?? 0.0,
                                    itemCount: 5,
                                    itemSize: 14,
                                    unratedColor: Colors.grey[300],
                                    itemBuilder: (ctx, _) => Icon(Icons.star, color: Colors.amber),
                                  ),*/
                                  SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height*4/100,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorResources.buttonColor,
                                        visualDensity: VisualDensity.compact,
                                        padding: EdgeInsets.symmetric(vertical: 6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                     /*   onPressed: () async {
                                          final slug = product.slug ?? ''; // make sure 'slug' exists in your model
                                          if (slug.isEmpty) return;

                                          final response = await http.post(
                                            Uri.parse('https://plumbingbazzar.com/app/v1/api/get_single_product_details_slug'),
                                            body: {'slug': slug},
                                          );
                                          print('DETAILS DATA KGKJGJKKJGKJGKJHGJHGKJHGHJGJHGJH${response.body}_____');
                                          if (response.statusCode == 200) {
                                            final data = json.decode(response.body);
                                            // if (data['status'] == true) {
                                              final productData = data['data'];
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ProductDetail1(model: productData),
                                                ),
                                              );
                                            // }
                                          } else {
                                            // handle error
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Failed to load product details')),
                                            );
                                          }
                                        },*/
                                        onPressed: () async {
                                          final slug = product.slug ?? '';
                                          if (slug.isEmpty) return;

                                          final response = await http.post(
                                            Uri.parse('https://plumbingbazzar.com/app/v1/api/get_single_product_details_slug'),
                                            body: {'slug': slug},
                                          );

                                          print("AAAAAAAAAAAAHHHHHHHHHHHHHHHHHHHHHHHHH${response.body}");

                                          if (response.statusCode == 200) {
                                            final data = json.decode(response.body);
                                            final productData = data['data'];

                                            // FIX: extract the actual product map
                                            final productModel = Product.fromJson(productData['product']);

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ProductDetail1(model: productModel , list: true,),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Failed to load product details')),
                                            );
                                          }
                                        }
,
                                        /*   onPressed: () {

                                        // MostLikedProduct model = category.mostLikedProducts[pIndex];
                                        Navigator.push(
                                            context, (MaterialPageRoute(builder: (context) => ProductDetail1(



                                        ))));
                                        // // Navigate to product details
                                      },*/
                                      child: Text("View Details",style: TextStyle(fontWeight: FontWeight.w600),),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  Widget listItem1() {
    return categorys1.isEmpty
        ? Container()
        : Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: categorys1.length,
        itemBuilder: (context, index) {
          final category = categorys1[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           /*   Text(
                category.mostLikedProducts.first.name ?? "Category",
                style: Theme.of(context).textTheme.headline6,
              ),*/
              const SizedBox(height: 8),
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: category.mostLikedProducts.length,
                  itemBuilder: (context, pIndex) {
                    final product = category.mostLikedProducts[pIndex];
                    print('PrintData____${category.mostLikedProducts.first.image}_____');
                    return Container(
                      width: 160, // control card width
                      // margin: EdgeInsets.only(right: 12),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    child: FadeInImage(
                                      image: CachedNetworkImageProvider(product.image!),
                                      placeholder: placeHolder(100),
                                      imageErrorBuilder: (ctx, e, st) => erroWidget(100),
                                      height: 115,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // favImg(category ),
                                ],
                              ),

                              /*ClipRRect(
                              *//*  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12)
                                ),*//*
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: FadeInImage(
                                  image: CachedNetworkImageProvider(product.image!),
                                  placeholder: placeHolder(100),
                                  imageErrorBuilder: (ctx, e, st) => erroWidget(100),
                                  height: 115,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),

                              ),*/
                            ),
                            Padding(
                              padding: const EdgeInsets.only(  left: 8.0,right: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                  // const SizedBox(height: 4),
                                  RatingBarIndicator(
                                    rating: double.tryParse(product.averageRating.toString()) ?? 0.0,
                                    itemCount: 5,
                                    itemSize: 14,
                                    unratedColor: Colors.grey[300],
                                    itemBuilder: (ctx, _) => Icon(Icons.star, color: Colors.amber),
                                  ),
                                /*  Row(
                                    children: [
                                      Text(
                                        "₹${product.price}",
                                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "₹${product.specialPrice}",
                                        style: TextStyle(
                                          decoration: TextDecoration.lineThrough,
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),*/


                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        "₹${product.price}",
                                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "₹${product.specialPrice}",
                                        style: TextStyle(
                                          decoration: TextDecoration.lineThrough,
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                /*  RatingBarIndicator(
                                    rating: double.tryParse(product.averageRating.toString()) ?? 0.0,
                                    itemCount: 5,
                                    itemSize: 14,
                                    unratedColor: Colors.grey[300],
                                    itemBuilder: (ctx, _) => Icon(Icons.star, color: Colors.amber),
                                  ),*/
                                  SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height*4/100,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorResources.buttonColor,
                                        visualDensity: VisualDensity.compact,
                                        padding: EdgeInsets.symmetric(vertical: 6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                     /*   onPressed: () async {
                                          final slug = product.slug ?? ''; // make sure 'slug' exists in your model
                                          if (slug.isEmpty) return;

                                          final response = await http.post(
                                            Uri.parse('https://plumbingbazzar.com/app/v1/api/get_single_product_details_slug'),
                                            body: {'slug': slug},
                                          );
                                          print('DETAILS DATA KGKJGJKKJGKJGKJHGJHGKJHGHJGJHGJH${response.body}_____');
                                          if (response.statusCode == 200) {
                                            final data = json.decode(response.body);
                                            // if (data['status'] == true) {
                                              final productData = data['data'];
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ProductDetail1(model: productData),
                                                ),
                                              );
                                            // }
                                          } else {
                                            // handle error
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Failed to load product details')),
                                            );
                                          }
                                        },*/
                                        onPressed: () async {
                                          final slug = product.slug ?? '';
                                          if (slug.isEmpty) return;

                                          final response = await http.post(
                                            Uri.parse('https://plumbingbazzar.com/app/v1/api/get_single_product_details_slug'),
                                            body: {'slug': slug},
                                          );

                                          print("AAAAAAAAAAAAHHHHHHHHHHHHHHHHHHHHHHHHH${response.body}");

                                          if (response.statusCode == 200) {
                                            final data = json.decode(response.body);
                                            final productData = data['data'];

                                            // FIX: extract the actual product map
                                            final productModel = Product.fromJson(productData['product']);

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ProductDetail1(model: productModel , list: true,),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Failed to load product details')),
                                            );
                                          }
                                        }
,
                                        /*   onPressed: () {

                                        // MostLikedProduct model = category.mostLikedProducts[pIndex];
                                        Navigator.push(
                                            context, (MaterialPageRoute(builder: (context) => ProductDetail1(



                                        ))));
                                        // // Navigate to product details
                                      },*/
                                      child: Text("View Details",style: TextStyle(fontWeight: FontWeight.w600),),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  Widget listItem2() {
    return categorys2.isEmpty
        ? Container()
        : Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: categorys2.length,
        itemBuilder: (context, index) {
          final category = categorys2[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           /*   Text(
                category.mostLikedProducts.first.name ?? "Category",
                style: Theme.of(context).textTheme.headline6,
              ),*/
              const SizedBox(height: 8),
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: category.mostLikedProducts.length,
                  itemBuilder: (context, pIndex) {
                    final product = category.mostLikedProducts[pIndex];
                    print('PrintData____${category.mostLikedProducts.first.image}_____');
                    return Container(
                      width: 160, // control card width
                      // margin: EdgeInsets.only(right: 12),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    child: FadeInImage(
                                      image: CachedNetworkImageProvider(product.image!),
                                      placeholder: placeHolder(100),
                                      imageErrorBuilder: (ctx, e, st) => erroWidget(100),
                                      height: 115,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // favImg(category ),
                                ],
                              ),


                            ),
                            Padding(
                              padding: const EdgeInsets.only(  left: 8.0,right: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                  // const SizedBox(height: 4),
                                  RatingBarIndicator(
                                    rating: double.tryParse(product.averageRating.toString()) ?? 0.0,
                                    itemCount: 5,
                                    itemSize: 14,
                                    unratedColor: Colors.grey[300],
                                    itemBuilder: (ctx, _) => Icon(Icons.star, color: Colors.amber),
                                  ),



                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        "₹${product.price}",
                                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "₹${product.specialPrice}",
                                        style: TextStyle(
                                          decoration: TextDecoration.lineThrough,
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height*4/100,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorResources.buttonColor,
                                        visualDensity: VisualDensity.compact,
                                        padding: EdgeInsets.symmetric(vertical: 6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),

                                        onPressed: () async {
                                          final slug = product.slug ?? '';
                                          if (slug.isEmpty) return;

                                          final response = await http.post(
                                            Uri.parse('https://plumbingbazzar.com/app/v1/api/get_single_product_details_slug'),
                                            body: {'slug': slug},
                                          );

                                          print("AAAAAAAAAAAAHHHHHHHHHHHHHHHHHHHHHHHHH${response.body}");

                                          if (response.statusCode == 200) {
                                            final data = json.decode(response.body);
                                            final productData = data['data'];

                                            // FIX: extract the actual product map
                                            final productModel = Product.fromJson(productData['product']);

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ProductDetail1(model: productModel , list: true,),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Failed to load product details')),
                                            );
                                          }
                                        }
,
                                        /*   onPressed: () {

                                        // MostLikedProduct model = category.mostLikedProducts[pIndex];
                                        Navigator.push(
                                            context, (MaterialPageRoute(builder: (context) => ProductDetail1(



                                        ))));
                                        // // Navigate to product details
                                      },*/
                                      child: Text("View Details",style: TextStyle(fontWeight: FontWeight.w600),),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  Widget favImg(Product product) {
    return Positioned.directional(
      textDirection: Directionality.of(context),
      end: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: product!.isFavLoading!
                  ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 0.7,
                    )),
              )
                  : Selector<FavoriteProvider, List<String?>>(
                builder: (context, data, child) {
                  // print("object*****${data[0].id}***${widget.model!.id}");

                  return InkWell(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            !data.contains(product!.id)
                                ? (Icons.favorite_border)
                                : Icons.favorite ,color: (!data.contains(product!.id)) ? colors.primary : Colors.red,
                            size: 20,
                          )),
                      onTap: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        String? curUserId = prefs.getString('CUR_USERID');
                        if (curUserId != null) {
                          !data.contains(product.id)
                              ? _setFav(-1 , product)
                              : _removeFav(-1 , product);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login()),
                          );
                        }
                      });
                },
                selector: (_, provider) => provider.favIdList,
              )),
        ),
      ),
    );
  }

  _setFav(int index , Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? curUserId = prefs.getString('CUR_USERID');
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        if (mounted)
          setState(() {
            index == -1
                ? product!.isFavLoading = true
                : product.isFavLoading = true;
          });

        var parameter = {USER_ID: curUserId, PRODUCT_ID:product!.id};
        Response response =
        await post(setFavoriteApi, body: parameter, headers: headers)
            .timeout(Duration(seconds: timeOut));

        var getdata = json.decode(response.body);

        bool error = getdata["error"];
        String? msg = getdata["message"];
        if (!error) {
          index == -1
              ? product!.isFav = "1"
              : product.isFav = "1";

          context.read<FavoriteProvider>().addFavItem(product);
        } else {
          setSnackbar(msg!, context);
        }

        if (mounted)
          setState(() {
            index == -1
                ? product.isFavLoading = false
                : product.isFavLoading = false;
          });
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!, context);
      }
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
        });
    }
  }

  _removeFav(int index , Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? curUserId = prefs.getString('CUR_USERID');
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        if (mounted)
          setState(() {
            index == -1
                ? product!.isFavLoading = true
                : product.isFavLoading = true;
          });

        var parameter = {USER_ID: curUserId, PRODUCT_ID: product!.id};
        Response response =
        await post(removeFavApi, body: parameter, headers: headers)
            .timeout(Duration(seconds: timeOut));

        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String? msg = getdata["message"];
        if (!error) {
          ;
          index == -1
              ? product!.isFav = "0"
              : product.isFav = "0";
          context
              .read<FavoriteProvider>()
              .removeFavItem(product!.prVarientList![0].id!);
        } else {
          setSnackbar(msg!, context);
        }

        if (mounted)
          setState(() {
            index == -1
                ? product!.isFavLoading = false
                : product.isFavLoading = false;
          });
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!, context);
      }
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
        });
    }
  }
  Widget noInternet(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          noIntImage(),
          noIntText(context),
          noIntDec(context),
          AppBtn(
            title: getTranslated(context, 'TRY_AGAIN_INT_LBL'),
            btnAnim: buttonSqueezeanimation,
            btnCntrl: buttonController,
            onBtnSelected: () async {
              context.read<HomeProvider>().setCatLoading(true);
              context.read<HomeProvider>().setSecLoading(true);
              context.read<HomeProvider>().setSliderLoading(true);
              _playAnimation();

              Future.delayed(Duration(seconds: 2)).then((_) async {
                _isNetworkAvail = await isNetworkAvailable();
                if (_isNetworkAvail) {
                  if (mounted)
                    setState(() {
                      _isNetworkAvail = true;
                    });
                  callApi();
                } else {
                  await buttonController.reverse();
                  if (mounted) setState(() {});
                }
              });
            },
          )
        ]),
      ),
    );
  }

  _deliverPincode() {
    // String curpin = context.read<UserProvider>().curPincode;
    return GestureDetector(
      child: Container(
        // padding: EdgeInsets.symmetric(vertical: 8),
        color: Theme.of(context).colorScheme.white,
        child: ListTile(
          dense: true,
          minLeadingWidth: 10,
          leading: Icon(
            Icons.location_pin,
          ),
          title: Selector<UserProvider, String>(
            builder: (context, data, child) {
              return Text(
                data == ''
                    ? getTranslated(context, 'SELOC')!
                    : getTranslated(context, 'DELIVERTO')! + data,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.fontColor),
              );
            },
            selector: (_, provider) => provider.curPincode,
          ),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
      ),
      onTap: _pincodeCheck,
    );
  }

  void _pincodeCheck() {
    showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        builder: (builder) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9),
              child: ListView(shrinkWrap: true, children: [
                Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20, bottom: 40, top: 30),
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Form(
                          key: _formkey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.close),
                                ),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                validator: (val) => validatePincode(val!,
                                    getTranslated(context, 'PIN_REQUIRED')),
                                onSaved: (String? value) {
                                  context
                                      .read<UserProvider>()
                                      .setPincode(value!);
                                },
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .fontColor),
                                decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: Icon(Icons.location_on),
                                  hintText:
                                      getTranslated(context, 'PINCODEHINT_LBL'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsetsDirectional.only(start: 20),
                                      width: deviceWidth! * 0.35,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          context
                                              .read<UserProvider>()
                                              .setPincode('');

                                          context
                                              .read<HomeProvider>()
                                              .setSecLoading(true);
                                          getSection();
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                            getTranslated(context, 'All')!),
                                      ),
                                    ),
                                    Spacer(),
                                    SimBtn(
                                        size: 0.35,
                                        title: getTranslated(context, 'APPLY'),
                                        onBtnSelected: () async {
                                          if (validateAndSave()) {
                                            // validatePin(curPin);
                                            context
                                                .read<HomeProvider>()
                                                .setSecLoading(true);
                                            getSection();

                                            context
                                                .read<HomeProvider>()
                                                .setSellerLoading(true);
                                            sellerList.clear();
                                            getSeller();
                                            Navigator.pop(context);
                                          }
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ))
              ]),
            );
            //});
          });
        });
  }

  bool validateAndSave() {
    final form = _formkey.currentState!;

    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward();
    } on TickerCanceled {}
  }

  void getSlider() {
    print("sdfsdfsfsdfsfsdsdfsdfsdfs");
    Map map = Map();
    print('PrintData____${getSliderApi}_____');
    apiBaseHelper.postAPICall(getSliderApi, map).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];

      if (!error) {
        var data = getdata["data"]; // This is an array
        print('PrintData11111111____${data}_____');
        print("ddfgdfffffffffffffff${getSliderApi.toString()}");

        // Option 1: If you have a Data model class, convert the dynamic list
        homeSliderList =
            (data as List).map((item) => Data.fromJson(item)).toList();

        // Option 2: If you want to work with dynamic data directly
        // List<dynamic> dynamicSliderList = data;
        // pages = [_carouselSlider(dynamicSliderList)];

        // Pass the converted data to _carouselSlider
        pages = [_carouselSlider(homeSliderList)];
      } else {
        setSnackbar(msg!, context);
      }

      context.read<HomeProvider>().setSliderLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setSliderLoading(false);
    });
  }

  void getCat() {
    Map parameter = {
      CAT_FILTER: "false",
    };
    apiBaseHelper.postAPICall(getCatApi, parameter).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        var data = getdata["data"];

        catList =
            (data as List).map((data) => new Product.fromCat(data)).toList();

        if (getdata.containsKey("popular_categories")) {
          var data = getdata["popular_categories"];
          popularList =
              (data as List).map((data) => new Product.fromCat(data)).toList();

          if (popularList.length > 0) {
            Product pop =
                new Product.popular("Popular", imagePath + "popular.svg");
            catList.insert(0, pop);
            context.read<CategoryProvider>().setSubList(popularList);
          }
        }
      } else {
        setSnackbar(msg!, context);
      }

      context.read<HomeProvider>().setCatLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setCatLoading(false);
    });
  }

  sectionLoading() {
    return Column(
        children: [0, 1, 2, 3, 4]
            .map((_) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 40),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                width: double.infinity,
                                height: 18.0,
                                color: Theme.of(context).colorScheme.white,
                              ),
                              GridView.count(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                childAspectRatio: 1.0,
                                physics: NeverScrollableScrollPhysics(),
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5,
                                children: List.generate(
                                  4,
                                  (index) {
                                    return Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      color:
                                          Theme.of(context).colorScheme.white,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    sliderLoading()
                    //offerImages.length > index ? _getOfferImage(index) : Container(),
                  ],
                ))
            .toList());
  }

  void getSeller() {
    String pin = context.read<UserProvider>().curPincode;
    Map parameter = {};
    if (pin != '') {
      parameter = {
        ZIPCODE: pin,
      };
    }

    apiBaseHelper.postAPICall(getSellerApi, parameter).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        var data = getdata["data"];
        print("Seller Parameter =========> $parameter");
        print("Seller Data=====================> : $data ");
        sellerList =
            (data as List).map((data) => new Product.fromSeller(data)).toList();
      } else {
        setSnackbar(msg!, context);
      }
      context.read<HomeProvider>().setSellerLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setSellerLoading(false);
    });
  }

  // _seller() {
  //   return Selector<HomeProvider, bool>(
  //     builder: (context, data, child) {
  //       return data
  //           ? Container(
  //               width: double.infinity,
  //               child: Shimmer.fromColors(
  //                   baseColor: Theme.of(context).colorScheme.simmerBase,
  //                   highlightColor: Theme.of(context).colorScheme.simmerHigh,
  //                   child: catLoading()))
  //           : Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 sellerList.isNotEmpty ? Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text(getTranslated(context, 'SHOP_BY_SELLER')!,
  //                           style: TextStyle(
  //                               color: Theme.of(context).colorScheme.fontColor,
  //                               fontWeight: FontWeight.bold)),
  //                       GestureDetector(
  //                         child: Text(getTranslated(context, 'VIEW_ALL')!),
  //                         onTap: () {
  //                           Navigator.push(
  //                               context,
  //                               MaterialPageRoute(
  //                                   builder: (context) => SellerList()));
  //                         },
  //                       )
  //                     ],
  //                   ),
  //                 ) : Container(),
  //                 Container(
  //                   height: 100,
  //                   padding: const EdgeInsets.only(top: 10, left: 10),
  //                   child: ListView.builder(
  //                     itemCount: sellerList.length,
  //                     scrollDirection: Axis.horizontal,
  //                     shrinkWrap: true,
  //                     physics: AlwaysScrollableScrollPhysics(),
  //                     itemBuilder: (context, index) {
  //                       return Padding(
  //                         padding: const EdgeInsetsDirectional.only(end: 10),
  //                         child: GestureDetector(
  //                           onTap: () {
  //                             print(sellerList[index].open_close_status);
  //                             if(sellerList[index].open_close_status == '1'){
  //                               Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                       builder: (context) => SellerProfile(
  //                                         sellerStoreName: sellerList[index].store_name ?? "",
  //                                         sellerRating: sellerList[index]
  //                                             .seller_rating ??
  //                                             "",
  //                                         sellerImage: sellerList[index]
  //                                             .seller_profile ??
  //                                             "",
  //                                         sellerName:
  //                                         sellerList[index].seller_name ??
  //                                             "",
  //                                         sellerID:
  //                                         sellerList[index].seller_id,
  //                                         storeDesc: sellerList[index]
  //                                             .store_description,
  //                                       )));
  //                             } else {
  //                               showToast("Currently Store is Off");
  //                             }
  //                           },
  //                           child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.start,
  //                             mainAxisSize: MainAxisSize.min,
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: <Widget>[
  //                               Padding(
  //                                 padding: const EdgeInsetsDirectional.only(
  //                                     bottom: 5.0),
  //                                 child: CircleAvatar(
  //                                   radius: 30,
  //                                   backgroundImage: NetworkImage(
  //                                       "${sellerList[index].seller_profile!}"
  //                                   ),
  //                                 ),
  //
  //                                 // new ClipRRect(
  //                                 //   borderRadius: BorderRadius.circular(25.0),
  //                                 //   child: new FadeInImage(
  //                                 //     fadeInDuration:
  //                                 //         Duration(milliseconds: 150),
  //                                 //     image: CachedNetworkImageProvider(
  //                                 //       sellerList[index].seller_profile!,
  //                                 //     ),
  //                                 //     height: 50.0,
  //                                 //     width: 50.0,
  //                                 //     fit: BoxFit.contain,
  //                                 //     imageErrorBuilder:
  //                                 //         (context, error, stackTrace) =>
  //                                 //             erroWidget(50),
  //                                 //     placeholder: placeHolder(50),
  //                                 //   ),
  //                                 // ),
  //                               ),
  //                               Container(
  //                                 child: Text(
  //                                   sellerList[index].seller_name!,
  //                                   style: Theme.of(context)
  //                                       .textTheme
  //                                       .caption!
  //                                       .copyWith(
  //                                           color: Theme.of(context)
  //                                               .colorScheme
  //                                               .fontColor,
  //                                           fontWeight: FontWeight.w600,
  //                                           fontSize: 10),
  //                                   overflow: TextOverflow.ellipsis,
  //                                   textAlign: TextAlign.center,
  //                                 ),
  //                                 width: 50,
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             );
  //     },
  //     selector: (_, homeProvider) => homeProvider.sellerLoading,
  //   );
  // }
}

class NetworkVideoWidget extends StatefulWidget {
  final String videoUrl;
  const NetworkVideoWidget({super.key, required this.videoUrl});

  @override
  State<NetworkVideoWidget> createState() => _NetworkVideoWidgetState();
}

class _NetworkVideoWidgetState extends State<NetworkVideoWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.setVolume(0.0); // Muted autoplay
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // void _togglePlayPause() {
  //   setState(() {
  //     _controller.value.isPlaying ? _controller.pause() : _controller.play();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width * 95 / 100;
    final height = screenWidth * 0.65;
  /*  final PopupController popupController = Get.put(PopupController());

    // Set context if not already
    WidgetsBinding.instance.addPostFrameCallback((_) {
      popupController.setContext(context);
      popupController.fetchAndStartPopup();
    });*/


    return _controller.value.isInitialized
        ? ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              color: Colors.red,
              child: SizedBox(
                height: height,
                width: screenWidth,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    GestureDetector(
                      onTap: /*_togglePlayPause*/ () {},
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : SizedBox(
            height: height,
            child: const Center(child: CircularProgressIndicator()),
          );
  }
}
