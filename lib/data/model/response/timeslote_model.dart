class TimeSlotModel {
  DateTime startTime;
  DateTime endTime;

  TimeSlotModel(
      {this.startTime,
        this.endTime});

  TimeSlotModel.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    return data;
  }
}
