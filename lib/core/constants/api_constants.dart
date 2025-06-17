import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => dotenv.env['CLARIFAI_BASE_URL']!;
  static String get appId => dotenv.env['CLARIFAI_APP_ID']!;
  static String get userId => dotenv.env['CLARIFAI_USER_ID']!;
  static String get modelId => dotenv.env['CLARIFAI_MODEL_ID']!;
  static String get modelVersionId => dotenv.env['CLARIFAI_MODEL_VERSION_ID']!;

  static String get apiKey => dotenv.env['CLARIFAI_API_KEY']!;

  static String getModelEndpoint() =>
      '$baseUrl/users/$userId/apps/$appId/models/$modelId/versions/$modelVersionId/outputs';

  static Map<String, String> get headers => {
    'Authorization': 'Key $apiKey',
    'Content-Type': 'application/json',
  };
}
