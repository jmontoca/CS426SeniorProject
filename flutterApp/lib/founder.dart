//class for templating Founders as maps for Json and database use.
class Founder {
  String key;
  String foundry;

  Founder({this.foundry, this.key});

//factory parses a json for you
  factory Founder.fromJson(Map<String, dynamic> json) {
    return Founder(
      foundry: json["foundry"],
    );
  }
  toJson() {
    return {
      "foundry": foundry,
    };
  }
}
