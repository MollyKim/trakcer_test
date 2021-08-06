class TrackerData {
  DateTime createdAt;
  num value;
  num battery;
  String macAddress;
  String tagName;

  TrackerData({
    this.createdAt,
    this.value = 0,
    this.battery = 0,
    this.macAddress,
    this.tagName,
  });

  factory TrackerData.fromMap(Map<String, dynamic> json) {
    return new TrackerData(
      createdAt: json['createdAt'].toDate() as DateTime,
      value: json['value'] as num,
      battery: json['battery'] as num,
      macAddress: json['macAddress'] as String,
      tagName: json['tagName'] as String,
    );
  }

    Map<String, dynamic> toJson() {
      return {
        'createdAt' : this.createdAt,
        'value' : this.value,
        'macAddress' : this.macAddress,
        'tagName' : this.tagName,
      };
    }


}

