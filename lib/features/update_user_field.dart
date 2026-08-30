import '../logger.dart';
import '../models/users_row.dart';
import '../repositories/users_repository.dart';

class UpdateUser {
  final UsersRepository usersRepository;
  final _logger = AppLogger.scope('UpdateUser');

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

    _logger.i('Updating user $userId with data: $data');

    try {
      final updatedUser = await usersRepository.update(
        userId: userId,
        data: data,
      );

      if (updatedUser == null) {
        throw Exception('Failed to update user (not found)');
      }

      _logger.d('User $userId updated successfully');
      return updatedUser;
    } catch (e, st) {
      _logger.e('Error updating user $userId', error: e, stackTrace: st);
      rethrow;
    }
  }
}
