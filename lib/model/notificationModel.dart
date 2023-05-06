// ignore_for_file: file_names

class NotificationModel {
  String? ductKey;
  String? updatedAt;
  String? type;

  NotificationModel({
    this.ductKey,
  });

  NotificationModel.fromJson(String ductId, this.updatedAt, this.type) {
    ductKey = ductId;
  }

  Map<String, dynamic> toJson() => {
        "ductKey": ductKey,
      };
}
