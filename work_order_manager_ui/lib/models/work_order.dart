class WorkOrder {
  int _id;
  String _client;
  String _serviceSummary;

  WorkOrder(this._id, this._client, this._serviceSummary);
  WorkOrder.fromObject(dynamic o)
      : _id = o["id"],
        _client = o["client"],
        _serviceSummary = o["serviceSummary"];

  int get id => _id;
  String get client => _client;
  String get serviceSummary => _serviceSummary;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["client"] = _client;
    map["id"] = _id;
    map["serviceSummary"] = _serviceSummary;
    return map;
  }
}
