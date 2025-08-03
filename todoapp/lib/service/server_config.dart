abstract class ServerConfig {
  final String url = '';

  final int connectionTimeOut = 0;
  final int receivedTimeout = 0;
}

class TestServerConfig implements ServerConfig {
  @override
  final String url = "https://cat-fact.herokuapp.com";

  @override
  final int connectionTimeOut = 1200;

  @override
  final int receivedTimeout = 1500;
}

class PrePodServerConfig implements ServerConfig {
  @override
  final String url = "";

  @override
  final int connectionTimeOut = 1200;

  @override
  final int receivedTimeout = 1500;
}

class LiveServerConfig implements ServerConfig {
  @override
  final String url = "";

  @override
  final int connectionTimeOut = 1200;

  @override
  final int receivedTimeout = 1500;
}
