class AppConfig {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://full-stack-todo-app-lzyj.onrender.com/api/todos/',
  );
}
