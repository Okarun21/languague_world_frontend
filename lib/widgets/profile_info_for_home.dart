import 'package:flutter/material.dart';

class ProfileInfoForHome extends StatelessWidget {
  final String? profileImageUrl;
  final String username;
  final int nivel;

  const ProfileInfoForHome({
    super.key,
    this.profileImageUrl,
    required this.username,
    required this.nivel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (profileImageUrl != null && profileImageUrl!.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              profileImageUrl!,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, size: 56);
              },
            ),
          ),
        if (profileImageUrl != null && profileImageUrl!.isNotEmpty)
          const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Nivel $nivel',
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
