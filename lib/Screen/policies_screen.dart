import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Helper/Color.dart';
import '../Helper/Constant.dart';
import '../Helper/Session.dart';
import '../Helper/String.dart';
import 'Customer_Support.dart';
import 'Faqs.dart';
import 'Login.dart';
import 'Manage_Address.dart';
import 'MyOrder.dart';
import 'MyTransactions.dart';
import 'My_Wallet.dart';
import 'Privacy_Policy.dart';
import 'ReferEarn.dart';
import 'Refund_policy.dart';
import 'Setting.dart';
import 'Shipping_policy.dart';

class PoliciesScreen extends StatefulWidget {
  const PoliciesScreen({super.key});

  @override
  State<PoliciesScreen> createState() => _PoliciesScreenState();
}

class _PoliciesScreenState extends State<PoliciesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          getTranslated(context, 'POLICIES') ?? 'Policies',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _getDrawer()),
          ],
        ),
      ),
    );
  }
  Widget _getDrawerItem(String title, String img) {
    return Column(
      children: [
        Container(

          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              // BoxShadow(
              //   color: Colors.grey.withOpacity(0.3),
              //   offset: Offset(0, 4),
              //   blurRadius: 8,
              //   spreadRadius: 1,
              // ),
            ],
          ),
          child: ListTile(
            trailing: Icon(
              Icons.navigate_next,
              color: colors.primary,
            ),
            leading: SvgPicture.asset(
              img,
              height: 25,
              width: 25,
              color: colors.primary,
            ),
            dense: true,
            title: Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.lightBlack,
                fontSize: 15,
              ),
            ),
            onTap: () async {
              if (title == getTranslated(context, 'REFEREARN')) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ReferEarn()));
              } else if (title == getTranslated(context, 'CONTACT_LBL')) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicy(title: getTranslated(context, 'CONTACT_LBL'))));
              } else if (title == getTranslated(context, 'CUSTOMER_SUPPORT')) {
                CUR_USERID == null
                    ? Navigator.push(context, MaterialPageRoute(builder: (context) => Login()))
                    : Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerSupport()));
              } else if (title == getTranslated(context, 'TERM')) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicy(title: getTranslated(context, 'TERM'))));
              } else if (title == getTranslated(context, 'PRIVACY')) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicy(title: getTranslated(context, 'PRIVACY'))));
              } else if (title == getTranslated(context, 'SHIPPING')) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ShippingPolicy()));
              } else if (title == getTranslated(context, 'REFUND')) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RefundPolicy()));
              } else if (title == getTranslated(context, 'RATE_US')) {
                _launchURLBrowser();
              } else if (title == getTranslated(context, 'FAQS')) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Faqs(title: getTranslated(context, 'FAQS'))));
              } else if (title == getTranslated(context, 'MYTRANSACTION')) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionHistory()));
              }
            },
          ),
        ),
        const Divider(
          height: 16,
          thickness: 1,
          color: Colors.grey,
          indent: 16,
          endIndent: 16,
        ),
      ],
    );
  }

  // Widget _getDrawerItem(String title, String img) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.3),
  //           offset: Offset(0, 4),
  //           blurRadius: 8,
  //           spreadRadius: 1,
  //         ),
  //       ],
  //     ),
  //     child: ListTile(
  //       trailing: Icon(
  //         Icons.navigate_next,
  //         color: colors.primary,
  //       ),
  //       leading: SvgPicture.asset(
  //         img,
  //         height: 25,
  //         width: 25,
  //         color: colors.primary,
  //       ),
  //       dense: true,
  //       title: Text(
  //         title,
  //         style: TextStyle(
  //           color: Theme.of(context).colorScheme.lightBlack,
  //           fontSize: 15,
  //         ),
  //       ),
  //       onTap: () async {
  //
  //         // Your entire existing onTap logic remains unchanged
  //    if (title == getTranslated(context, 'REFEREARN')) {
  //           Navigator.push(context, MaterialPageRoute(builder: (context) => ReferEarn()));
  //         } else if (title == getTranslated(context, 'CONTACT_LBL')) {
  //           Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicy(title: getTranslated(context, 'CONTACT_LBL'))));
  //         } else if (title == getTranslated(context, 'CUSTOMER_SUPPORT')) {
  //           CUR_USERID == null
  //               ? Navigator.push(context, MaterialPageRoute(builder: (context) => Login()))
  //               : Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerSupport()));
  //         } else if (title == getTranslated(context, 'TERM')) {
  //           Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicy(title: getTranslated(context, 'TERM'))));
  //         } else if (title == getTranslated(context, 'PRIVACY')) {
  //           Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicy(title: getTranslated(context, 'PRIVACY'))));
  //         } else if (title == getTranslated(context, 'SHIPPING')) {
  //           Navigator.push(context, MaterialPageRoute(builder: (context) => ShippingPolicy()));
  //         } else if (title == getTranslated(context, 'REFUND')) {
  //           Navigator.push(context, MaterialPageRoute(builder: (context) => RefundPolicy()));
  //         } else if (title == getTranslated(context, 'RATE_US')) {
  //           _launchURLBrowser();
  //         }
  //        else if (title == getTranslated(context, 'CONTACT_LBL')) {
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicy(title: getTranslated(context, 'CONTACT_LBL'))));
  //   }
  //         else if (title == getTranslated(context, 'FAQS')) {
  //           Navigator.push(context, MaterialPageRoute(builder: (context) => Faqs(title: getTranslated(context, 'FAQS'))));
  //         }
  //         else if (title == getTranslated(context, 'MYTRANSACTION')) {
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => TransactionHistory(),
  //               ));
  //         }
  //
  //       },
  //     ),
  //   );
  // }
  _launchURLBrowser() async {
    const url = 'https://play.google.com/store/apps/details?id=com.ZuqZuq';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _getDrawer() {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      children: <Widget>[

        _getDrawerItem(
            getTranslated(context, 'FAQS')!, 'assets/images/pro_faq.svg'),
        // _getDivider(),
        _getDrawerItem(
            getTranslated(context, 'PRIVACY')!, 'assets/images/pro_pp.svg'),
        _getDrawerItem(
            getTranslated(context, 'SHIPPING')!, 'assets/images/pro_pp.svg'),
        _getDrawerItem(
            getTranslated(context, 'REFUND')!, 'assets/images/pro_pp.svg'),

        _getDrawerItem(
            getTranslated(context, 'TERM')!, 'assets/images/pro_tc.svg'),
        _getDrawerItem(getTranslated(context, 'CONTACT_LBL')!,
            'assets/images/pro_aboutus.svg'),
        // _getDivider(),
        // _getDrawerItem(
        //     getTranslated(context, 'RATE_US')!, 'assets/images/pro_rateus.svg'),
        // _getDivider(),
        // _getDrawerItem(getTranslated(context, 'SHARE_APP')!,
        //     'assets/images/pro_share.svg'),
        // CUR_USERID == "" || CUR_USERID == null ? Container() : _getDivider(),


      ],
    );
  }
}
