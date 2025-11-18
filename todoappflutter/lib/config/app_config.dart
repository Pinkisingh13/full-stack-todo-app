class AppConfig {
  // For production, you can use different URLs based on the platform
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://full-stack-todo-app-lzyj.onrender.com/api/todos/',
  );
}
