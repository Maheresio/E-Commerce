class ApiConstants {
  static const String baseUrl = 'https://api.clarifai.com/v2';
  static const String appId = 'main';
  static const String userId = 'clarifai';
  static const String modelId = 'apparel-classification-v2';
  static const String modelVersionId = '651c5412d53c408fa3b4fe3dcc060be7';

  static const String apiKey = '8ee437b0e4f5435f9c78b7dea2b15e1c';

  static String getModelEndpoint() =>
      '$baseUrl/users/$userId/apps/$appId/models/$modelId/versions/$modelVersionId/outputs';

  static Map<String, String> get headers => {
    'Authorization': 'Key $apiKey',
    'Content-Type': 'application/json',
  };
}
