import 'package:efood_multivendor/data/model/response/restaurant_model.dart';

class BasicCampaignModel {
  int id;
  String title;
  String image;
  String description;
  String startDate;
  String endDate;
  String startTime;
  String endTime;
  List<Restaurant> restaurants;

  BasicCampaignModel(
      {this.id,
        this.title,
        this.image,
        this.description,
        this.startDate,
        this.endDate,
        this.startTime,
        this.endTime,
        this.restaurants});

  BasicCampaignModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    if (json['restaurants'] != null) {
      restaurants = [];
      json['restaurants'].forEach((v) {
        restaurants.add(new Restaurant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['description'] = this.description;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    if (this.restaurants != null) {
      data['restaurants'] = this.restaurants.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
