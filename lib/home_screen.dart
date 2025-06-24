import 'package:flutter/material.dart';
import 'package:llajar/widgets/destination_section.dart';
import '../widgets/app_header.dart';
import '../widgets/search_form.dart';
import '../widgets/features_section.dart';
import '../widgets/faq_section.dart';
import '../widgets/app_footer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            AppHeader(),
            SearchForm(),
            FeaturesSection(),
            DestinationsSection(),
            FAQSection(),
            AppFooter(),
          ],
        ),
      ),
    );
  }
}
