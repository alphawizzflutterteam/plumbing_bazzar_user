import 'dart:convert';

import 'package:Plumbingbazzar/Model/homescreen_category.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Plumbingbazzar/Helper/Session.dart';
import 'package:Plumbingbazzar/Model/Section_Model.dart';
import 'package:flutter/material.dart';
import 'package:Plumbingbazzar/Helper/Color.dart';
import '../Model/Sub_Categories.dart';
import 'ProductList.dart';
import 'package:http/http.dart' as http;

/*class SubCategory extends StatelessWidget {
  final List<Product>? subList;
  final String title;
  const SubCategory({Key? key, this.subList, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(title, context),
      body: GridView.count(
          padding: EdgeInsets.all(20),
          crossAxisCount: 2,
          shrinkWrap: true,
          childAspectRatio: .70,
          children: List.generate(
            subList!.length,
            (index) {
              return subCatItem(index, context);
            },
          )),
    );
  }
  subCatItem(int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (subList![index].subList == null || subList![index].subList!.isEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductList(
                name: subList![index].name,
                id: subList![index].id,
                tag: false,
                fromSeller: false,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubCategory(
                subList: subList![index].subList,
                title: subList![index].name ?? "",
              ),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 1,
                child: CachedNetworkImage(
                  imageUrl: subList![index].image!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => placeHolder(50),
                  errorWidget: (context, url, error) => erroWidget(50),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                subList![index].name ?? "",
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.fontColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }*/

  // subCatItem(int index, BuildContext context) {
  //   return GestureDetector(
  //     child: Column(
  //       children: <Widget>[
  //         Expanded(
  //           child: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(10.0),
  //                 child: FadeInImage(
  //                   image: CachedNetworkImageProvider(subList![index].image!),
  //                   fadeInDuration: Duration(milliseconds: 150),
  //                   imageErrorBuilder: (context, error, stackTrace) =>
  //                       erroWidget(50),
  //                   placeholder: placeHolder(50),
  //                 )),
  //           ),
  //         ),
  //         Text(
  //           subList![index].name! + "\n",
  //           textAlign: TextAlign.center,
  //           maxLines: 2,
  //           overflow: TextOverflow.ellipsis,
  //           style: Theme.of(context)
  //               .textTheme
  //               .caption!
  //               .copyWith(color: Theme.of(context).colorScheme.fontColor),
  //         )
  //       ],
  //     ),
  //     onTap: () {
  //       if (subList![index].subList == null ||
  //           subList![index].subList!.length == 0) {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => ProductList(
  //                 name: subList![index].name,
  //                 id: subList![index].id,
  //                 tag: false,
  //                 fromSeller: false,
  //               ),
  //             ));
  //       } else {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => SubCategory(
  //                 subList: subList![index].subList,
  //                 title: subList![index].name ?? "",
  //               ),
  //             ));
  //       }
  //     },
  //   );
  // }
// }
class SubCategoryWithBanner extends StatelessWidget {
  final String slug;
  final String title;

  const SubCategoryWithBanner({required this.slug, required this.title});
  Future<Data?> fetchSubCategoryData(String slug) async {
    try {
      final response = await http.post(
        Uri.parse("https://plumbingbazzar.com/app/v1/api/get_category_banner_and_subcategories"),
        body: {"slug": slug},
      );
      print('PrintData____${response.body}_____');
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return Data.fromJson(decoded["data"]);
        ;
      }
    } catch (e) {
      print("Error fetching subcategory: $e");
    }
    return null;
  }


  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(title, context),
      body: FutureBuilder<Data?>(
        future: fetchSubCategoryData(slug),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("No data found"));
          }

          final data = snapshot.data!;
          final banner = data.categoryBanner ?? '';
          final subCategories = data.subCategories ?? [];

          return Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Column(
              children: [
                SizedBox(height: 20,),
                if (banner.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: banner,
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 180,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: double.infinity,
                        height: 180,
                        color: Colors.grey[300],
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: double.infinity,
                        height: 180,
                        color: Colors.grey[300],
                        child: Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                  ),
                SizedBox(height: 20,),

                  // CachedNetworkImage(
                  //   imageUrl: banner,
                  //   width: MediaQuery.of(context).size.width*90/100,
                  //   height: 180,
                  //   fit: BoxFit.cover,
                  // ),
                if (subCategories.isEmpty)
                  Expanded(child: Center(child: Text("No Subcategories found")))
                else
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      padding: const EdgeInsets.all(10),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.70,
                      children: subCategories.map((item) {
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SecondSubCategory(
                                  title: item.name!,
                                  slug: item.slug!,
                                ),
                              ),);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: CachedNetworkImage(
                                      imageUrl: item.image ?? '',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item.name ?? '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }

}
class SecondSubCategory extends StatelessWidget {
  final String slug;
  final String title;

  const SecondSubCategory({required this.slug, required this.title});
  Future<Data?> fetchSubCategoryData(String slug) async {
    try {
      final response = await http.post(
        Uri.parse("https://plumbingbazzar.com/app/v1/api/get_category_banner_and_subcategories"),
        body: {"slug": slug},
      );
      print('PrintDatfdfdfda____${response.body}_____');
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return Data.fromJson(decoded["data"]);
        ;
      }
    } catch (e) {
      print("Error fetching subcategory: $e");
    }
    return null;
  }


  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(title, context),
      body: FutureBuilder<Data?>(
        future: fetchSubCategoryData(slug),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("No data found"));
          }

          final data = snapshot.data!;
          final banner = data.categoryBanner ?? '';
          final subCategories = data.subCategories ?? [];

          return Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Column(
              children: [
                SizedBox(height: 20,),
                if (banner.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: banner,
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 180,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: double.infinity,
                        height: 180,
                        color: Colors.grey[300],
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: double.infinity,
                        height: 180,
                        color: Colors.grey[300],
                        child: Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                  ),
                SizedBox(height: 20,),

                  // CachedNetworkImage(
                  //   imageUrl: banner,
                  //   width: MediaQuery.of(context).size.width*90/100,
                  //   height: 180,
                  //   fit: BoxFit.cover,
                  // ),
                if (subCategories.isEmpty)
                  Expanded(child: Center(child: Text("No Subcategories found")))
                else
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.count(
                        crossAxisCount: 2,
                        padding: const EdgeInsets.all(10),
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.70, // Adjusted for better UI
                        children: subCategories.map((item) {
                          return GestureDetector(
                            onTap: (){
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
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: CachedNetworkImage(
                                        imageUrl: item.image ?? '',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      item.name ?? '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  )

              ],
            ),
          );
        },
      ),
    );
  }

}
