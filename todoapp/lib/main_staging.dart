import 'package:todoapp/service/server_config.dart';

import 'main.dart' as app;

void main() {
  app.main(defaultServerConfig: TestServerConfig());
}
