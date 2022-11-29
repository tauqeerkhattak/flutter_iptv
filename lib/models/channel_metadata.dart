class ChannelMetadata {
  String? tvgId;
  String? tvgLogo;
  String? groupTitle;

  ChannelMetadata.fromJson(Map<String, dynamic> json) {
    tvgId = json['tvg-id'];
    tvgLogo = json['tvg-logo'];
    groupTitle = json['group-title'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['tvg-id'] = tvgId;
    data['tvg-logo'] = tvgLogo;
    data['group-title'] = groupTitle;
    return data;
  }
}
