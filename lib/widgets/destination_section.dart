import 'package:flutter/material.dart';

class DestinationsSection extends StatelessWidget {
  const DestinationsSection({super.key});

  final List<Map<String, String>> destinations = const [
    {
      'name': 'Orlando',
      'image': 'https://ext.same-assets.com/1648771861/1730512194.jpeg',
    },
    {
      'name': 'Los Angeles',
      'image': 'https://ext.same-assets.com/1648771861/943010748.jpeg',
    },
    {
      'name': 'Las Vegas',
      'image': 'https://ext.same-assets.com/1648771861/2733336422.jpeg',
    },
    {
      'name': 'Tampa',
      'image': 'https://ext.same-assets.com/1648771861/2324223279.jpeg',
    },
    {
      'name': 'San Francisco',
      'image': 'https://ext.same-assets.com/1648771861/146148381.jpeg',
    },
    {
      'name': 'Phoenix',
      'image': 'https://ext.same-assets.com/1648771861/2946076261.jpeg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 1024;
    final bool isTablet = MediaQuery.of(context).size.width > 600;

    return Container(
      color: const Color(0xFFFBFBFB),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : (isTablet ? 40 : 16),
        vertical: 60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Destinations',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2c4c62),
            ),
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 3 : (isTablet ? 2 : 1),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: isDesktop ? 2.5 : (isTablet ? 2.2 : 3),
            ),
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              return _buildDestinationCard(destinations[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationCard(Map<String, String> destination) {
    return InkWell(
      onTap: () {
        // Handle destination selection
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.network(
                  destination['image']!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF96a8ad),
                      child: const Icon(
                        Icons.image,
                        color: Colors.white,
                        size: 48,
                      ),
                    );
                  },
                ),
              ),
              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ),
              // City name
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Text(
                  destination['name']!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
