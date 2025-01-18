import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'WEATHER_API_KEY', obfuscate: true)
  static final String weatherApiKey = _Env.weatherApiKey;

  @EnviedField(varName: 'WEATHER_API_BASE_URL', obfuscate: true)
  static final String weatherApiBaseUrl = _Env.weatherApiBaseUrl;

  @EnviedField(varName: 'CLOUDFLARE_WORKER_URL', obfuscate: true)
  static final String cloudflareWorkerUrl = _Env.cloudflareWorkerUrl;

  @EnviedField(varName: 'SENTRY_DSN', obfuscate: true)
  static final String sentryDsn = _Env.sentryDsn;
}
