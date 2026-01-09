// todo:
// using giphy directly is a temporary solution
// the backend should take search query and provide gif url
// hence keeping the api key only in the backend

class ClientConf {
  final String? giphyApiKey;
  const ClientConf({this.giphyApiKey});
  factory ClientConf.fromJson(Map<String, dynamic> json) {
    return ClientConf(giphyApiKey: json['GIPHY_KEY'] as String?);
  }
}
