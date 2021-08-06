class TrackerData {
  DateTime createdAt;
  num value;
  num battery;
  String macAddress;
  String name;

  TrackerData({
    this.createdAt,
    this.value = 0,
    this.battery = 0,
    this.macAddress,
    this.name,
  });

  factory TrackerData.fromMap(Map<String, dynamic> json) {
    return new TrackerData(
      createdAt: json['createdAt'].toDate() as DateTime,
      value: json['value'] as num,
      battery: json['battery'] as num,
      macAddress: json['macAddress'] as String,
      name: json['name'] as String,
    );
  }

    Map<String, dynamic> toJson() {
      return {
        'createdAt' : this.createdAt,
        'battery' : this.battery,
        'value' : this.value,
        'macAddress' : this.macAddress,
        'name' : this.name,
      };
    }


}

