import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../data/models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final userData = prefs.getString("userData");
      if (userData == null) {
        throw ("Error getting userData");
      }
      final currentUser = User.fromJson2(jsonDecode(userData));
      return currentUser;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text("Couldn't get user."),
          );
        }
        final user = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: const Text('InterCard Transfer'),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutEvent());
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: const Center(
            child: Text('HomeScreen'),
          ),
        );
      },
    );
  }
}
