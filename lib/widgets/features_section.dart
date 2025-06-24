import 'package:flutter/material.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 1024;
    final bool isTablet = MediaQuery.of(context).size.width > 600;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : (isTablet ? 40 : 16),
        vertical: 60,
      ),
      child: isDesktop
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildFeatureItems(),
            )
          : Column(
              children: _buildFeatureItems()
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: item,
                    ),
                  )
                  .toList(),
            ),
    );
  }

  List<Widget> _buildFeatureItems() {
    return [
      _buildFeatureItem(
        'https://ext.same-assets.com/1648771861/519816770.svg',
        Icons.verified,
        'A trusted Expedia brand',
        'Book with confidence knowing you\'re backed by Expedia\'s trusted platform',
      ),
      _buildFeatureItem(
        'https://ext.same-assets.com/1648771861/72528149.svg',
        Icons.looks_3,
        'Book a car in 3 easy steps',
        'Simple and fast booking process that gets you on the road quickly',
      ),
      _buildFeatureItem(
        'https://ext.same-assets.com/1648771861/732525104.svg',
        Icons.local_offer,
        'Find great deals',
        'Compare prices from top rental companies to find the best rates',
      ),
    ];
  }

  Widget _buildFeatureItem(
    String iconUrl,
    IconData fallbackIcon,
    String title,
    String description,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF61b1bd).withOpacity(0.1),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Center(
                child: Image.network(
                  iconUrl,
                  width: 32,
                  height: 32,
                  color: const Color(0xFF61b1bd),
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      fallbackIcon,
                      size: 32,
                      color: const Color(0xFF61b1bd),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2c4c62),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF96a8ad),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
