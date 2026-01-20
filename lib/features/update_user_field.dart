import 'package:SwishLab/models/users_row.dart';
import 'package:SwishLab/repositories/users_repository.dart';

class UpdateUser {
  final UsersRepository usersRepository;

  UpdateUser({
    required this.usersRepository,
  });

  Future<UsersRow> execute({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    if (data.isEmpty) {
      throw Exception('No update data provided');
    }

    final updatedUser = await usersRepository.update(
      userId: userId,
      data: data,
    );

    if (updatedUser == null) {
      throw Exception('Failed to update user');
    }

    return updatedUser;
  }
}
