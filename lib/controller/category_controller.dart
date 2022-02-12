import 'package:efood_multivendor/data/api/api_checker.dart';
import 'package:efood_multivendor/data/model/response/category_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/repository/category_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController implements GetxService {
  final CategoryRepo categoryRepo;
  CategoryController({@required this.categoryRepo});

  List<CategoryModel> _categoryList;
  List<CategoryModel> _subCategoryList;
  List<Product> _categoryProductList;
  List<Product> _searchProductList = [];
  List<bool> _interestSelectedList;
  bool _isLoading = false;
  int _pageSize;
  bool _isSearching = false;
  int _subCategoryIndex = 0;

  List<CategoryModel> get categoryList => _categoryList;
  List<CategoryModel> get subCategoryList => _subCategoryList;
  List<Product> get categoryProductList => _categoryProductList;
  List<Product> get searchProductList => _searchProductList;
  List<bool> get interestSelectedList => _interestSelectedList;
  bool get isLoading => _isLoading;
  int get pageSize => _pageSize;
  bool get isSearching => _isSearching;
  int get subCategoryIndex => _subCategoryIndex;

  Future<void> getCategoryList(bool reload) async {
    if(_categoryList == null || reload) {
      Response response = await categoryRepo.getCategoryList();
      if (response.statusCode == 200) {
        _categoryList = [];
        _interestSelectedList = [];
        response.body.forEach((category) {
          _categoryList.add(CategoryModel.fromJson(category));
          _interestSelectedList.add(false);
        });
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  void getSubCategoryList(String categoryID) async {
    _subCategoryIndex = 0;
    _subCategoryList = null;
    _categoryProductList = null;
    Response response = await categoryRepo.getSubCategoryList(categoryID);
    if (response.statusCode == 200) {
      _subCategoryList= [];
      _subCategoryList.add(CategoryModel(id: int.parse(categoryID), name: 'all'.tr));
      response.body.forEach((category) => _subCategoryList.add(CategoryModel.fromJson(category)));
      getCategoryProductList(categoryID, '1');
    } else {
      ApiChecker.checkApi(response);
    }
  }

  void setSubCategoryIndex(int index) {
    _subCategoryIndex = index;
    getCategoryProductList(_subCategoryList[index].id.toString(), '1');
    update();
  }

  void getCategoryProductList(String categoryID, String offset) async {
    if(offset == '1') {
      _categoryProductList = null;
      _isSearching = false;
    }
    Response response = await categoryRepo.getCategoryProductList(categoryID, offset);
    if (response.statusCode == 200) {
      if (offset == '1') {
        _categoryProductList = [];
      }
      _categoryProductList.addAll(ProductModel.fromJson(response.body).products);
      _pageSize = ProductModel.fromJson(response.body).totalSize;
      _isLoading = false;
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void searchData(String query, String categoryID) async {
    _searchProductList = null;
    update();
    Response response = await categoryRepo.getSearchData(query, categoryID);
    if (response.statusCode == 200) {
      _searchProductList = [];
      _searchProductList.addAll(ProductModel.fromJson(response.body).products);
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void toggleSearch() {
    _isSearching = !_isSearching;
    _searchProductList = [];
    if(_categoryProductList != null) {
      _searchProductList.addAll(_categoryProductList);
    }
    update();
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  Future<bool> saveInterest(List<int> interests) async {
    _isLoading = true;
    update();
    Response response = await categoryRepo.saveUserInterests(interests);
    bool _isSuccess;
    if(response.statusCode == 200) {
      _isSuccess = true;
    }else {
      _isSuccess = false;
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
    return _isSuccess;
  }

  void addInterestSelection(int index) {
    _interestSelectedList[index] = !_interestSelectedList[index];
    update();
  }

}
