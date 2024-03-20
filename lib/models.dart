class TrafficInfo {
  Channel channel;
  List<Feed> feeds;

  TrafficInfo({
    required this.channel,
    required this.feeds,
  });

  factory TrafficInfo.fromJson(Map<String, dynamic> json) => TrafficInfo(
        channel: Channel.fromJson(json["channel"]),
        feeds: List<Feed>.from(json["feeds"].map((x) => Feed.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "channel": channel.toJson(),
        "feeds": List<dynamic>.from(feeds.map((x) => x.toJson())),
      };
}

class Channel {
  int id;
  String name;
  String latitude;
  String longitude;
  String field1;
  DateTime createdAt;
  DateTime updatedAt;
  int lastEntryId;

  Channel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.field1,
    required this.createdAt,
    required this.updatedAt,
    required this.lastEntryId,
  });

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
        id: json["id"],
        name: json["name"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        field1: json["field1"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        lastEntryId: json["last_entry_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "field1": field1,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "last_entry_id": lastEntryId,
      };
}

class Feed {
  DateTime createdAt;
  int entryId;
  String field1;

  Feed({
    required this.createdAt,
    required this.entryId,
    required this.field1,
  });

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
        createdAt: DateTime.parse(json["created_at"]),
        entryId: json["entry_id"],
        field1: json["field1"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt.toIso8601String(),
        "entry_id": entryId,
        "field1": field1,
      };
}
