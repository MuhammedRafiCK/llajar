import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Image.network(
                'https://ext.same-assets.com/1648771861/3391501115.svg',
                height: 32,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: const Text(
                      'carrentals',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2c4c62),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          // Navigation
          Row(
            children: [
              _buildNavItem('Support'),
              const SizedBox(width: 24),
              _buildNavItem('Trips'),
              const SizedBox(width: 24),
              if (MediaQuery.of(context).size.width > 600) ...[
                _buildNavItem('Sign in'),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2c4c62),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text('Create account'),
                ),
              ] else ...[
                IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String text) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF2c4c62),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
