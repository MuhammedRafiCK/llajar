import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 1024;
    final bool isTablet = MediaQuery.of(context).size.width > 600;

    return Container(
      color: const Color(0xFF2c4c62),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : (isTablet ? 40 : 16),
        vertical: 40,
      ),
      child: Column(
        children: [
          if (isDesktop) _buildDesktopFooter() else _buildMobileFooter(),
          const SizedBox(height: 32),
          const Divider(color: Color(0xFF96a8ad)),
          const SizedBox(height: 24),
          _buildBottomSection(),
        ],
      ),
    );
  }

  Widget _buildDesktopFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _buildFooterLinks(),
    );
  }

  Widget _buildMobileFooter() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: _buildFooterLinks(),
    );
  }

  List<Widget> _buildFooterLinks() {
    final List<String> links = [
      'Support',
      'Terms Of Use',
      'Privacy Policy',
      'Cookies',
      'Your Privacy Choices',
      'Careers',
      'Advertising',
    ];

    return links.map((link) {
      return InkWell(
        onTap: () {
          // Handle link tap
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            link,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildBottomSection() {
    return Column(
      children: [
        const Text(
          '2025 Expedia, Inc., an Expedia Group company. All rights reserved. Carrentals, Carrentals.com and Carrentals logo are registered trademarks of Expedia, Inc. CST# 2029030-50.',
          style: TextStyle(color: Color(0xFF96a8ad), fontSize: 12, height: 1.5),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () {
            // Handle Expedia Group link
          },
          child: Image.network(
            'https://ext.same-assets.com/1648771861/4084955012.svg',
            height: 24,
            color: Colors.white,
            errorBuilder: (context, error, stackTrace) {
              return const Text(
                'Expedia Group',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
