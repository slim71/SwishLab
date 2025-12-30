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

  Future<UsersRow?> getSingleUserById(String userId) async {
    final response =
        await _client.from('Users').select().eq('id', userId).maybeSingle();

    if (response == null) return null;
    return UsersRow.fromJson(response);
  }
}
