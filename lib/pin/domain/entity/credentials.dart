class UserCredentials {
  final String username;
  final String password;

  const UserCredentials({required this.username, required this.password});

  const UserCredentials.empty()
      : username = '',
        password = '';

  UserCredentials copy({String? username, String? password}) => UserCredentials(
        username: username ?? this.username,
        password: password ?? this.password,
      );
}
