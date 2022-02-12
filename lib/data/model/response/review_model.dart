import 'package:efood_multivendor/data/model/response/userinfo_model.dart';

class ReviewModel {
  int id;
  String comment;
  int rating;
  String createdAt;
  String updatedAt;
  UserInfoModel customer;

  ReviewModel(
      {this.id,
        this.comment,
        this.rating,
        this.createdAt,
        this.updatedAt,
        this.customer});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    rating = json['rating'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    customer = json['customer'] != null
        ? new UserInfoModel.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment'] = this.comment;
    data['rating'] = this.rating;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    return data;
  }
}
