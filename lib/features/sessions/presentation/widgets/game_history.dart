import 'package:flutter/material.dart';

import '../../domain/entities/session.dart';

class GameHistory extends StatelessWidget {
  final Session session;

  const GameHistory({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    // Round history should ideally be a separate stream or collection
    // For now, we'll keep it simple or show a placeholder if we haven't implemented round list fetching
    return Center(
      child: Text('Round details appearing soon...', style: TextStyle(color: Colors.grey[600])),
    );
  }
}
