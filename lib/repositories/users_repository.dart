import 'package:SwishLab/models/users_row.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Define connections to the Users row in Supabase
class UsersRepository {
  final SupabaseClient _client;

  UsersRepository(this._client);

  Future<List<UsersRow>> getUserById(String userId) async {
    final response = await _client.from('Users').select().eq('id', userId);

    return (response as List).map((json) => UsersRow.fromJson(json)).toList();
  }

  Future<UsersRow?> getUserRow(String userId) async {
    final response =
        await _client.from('Users').select().eq('id', userId).maybeSingle();

    if (response == null) return null;
    return UsersRow.fromJson(response);
  }

  Future<void> insertUser({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    await _client.from('Users').insert({
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<UsersRow?> updateProfilePicture({
    required String userId,
    required String profilePicUrl,
  }) {
    return update(
      userId: userId,
      data: {'profile_pic': profilePicUrl},
    );
  }

  Future<UsersRow?> updateShootingHand({
    required String userId,
    required String shootingHand,
  }) {
    return update(
      userId: userId,
      data: {'shooting_hand': shootingHand},
    );
  }

  Future<UsersRow?> update({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    if (data.isEmpty) return null;

    final response = await _client.from('Users').update(data).eq('id', userId).select().maybeSingle();

    if (response == null) return null;
    return UsersRow.fromJson(response);
  }
}
