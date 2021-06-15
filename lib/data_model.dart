class TrackerData {
  DateTime createdAt;
  num value;
  String macAddress;

  TrackerData({
    this.createdAt,
    this.value = 0,
    this.macAddress,
  });

  factory TrackerData.fromMap(Map<String, dynamic> json) {
    return new TrackerData(
      createdAt: json['createdAt'].toDate() as DateTime,
      value: json['value'] as num,
      macAddress: json['macAddress'] as String,
    );
  }

    Map<String, dynamic> toJson() {
      return {
        'createdAt' : this.createdAt,
        'value' : this.value,
        'macAddress' : this.macAddress,
      };
    }


}

