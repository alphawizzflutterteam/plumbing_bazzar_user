import 'package:Plumbingbazzar/Model/Section_Model.dart';
import 'package:flutter/cupertino.dart';

import '../Model/homescreen_category.dart';

class CategoryProvider extends ChangeNotifier {
  List<Product>? _subList = [];
  List<SubCategory1>? _subList1 = [];
  List<CategoryProduct>? _subList2 = [];
  int _curCat = 0;

  get subList => _subList;
  get subList1 => _subList1;
  get subList2 => _subList2;

  get curCat => _curCat;

  setCurSelected(int index) {
    _curCat = index;
    notifyListeners();
  }

  setSubList(List<Product>? subList) {
    _subList = subList;
    notifyListeners();
  }

  setSubList1(List<SubCategory1>? subList1) {
    _subList1 = subList1;
    notifyListeners();
  }
  setProductList(List<CategoryProduct>? subList2) {
    _subList2 = subList2;
    notifyListeners();
  }
}
