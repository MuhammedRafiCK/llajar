import 'package:flutter/material.dart';

class FAQSection extends StatefulWidget {
  const FAQSection({super.key});

  @override
  State<FAQSection> createState() => _FAQSectionState();
}

class _FAQSectionState extends State<FAQSection> {
  int _expandedIndex = -1;

  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How should I find a cheap rental car?',
      'answer': '''Here are some tips on how to save money when renting a car:

• Compare lots of cheap rental car rates to get the best price
• Prepay for your car instead of paying at pickup to lock in cheaper rates and get the most savings.
• Set a price drop alert and get an email when the base rate is low.
• Many times renting a car at the airport can be more expensive. Consider looking for cars in nearby locations for big savings. Off-airport rental companies may also offer shuttle service from the terminal to your rental location.
• Know what you need, including the fuel and mileage you'll use and the size car you want before making a reservation.
• Check and compare any other costs associated with the rental car, such as fees for young or senior drivers, or fees for including additional drivers.
• Book in advance to take advantage of available coupons and deals.''',
    },
    {
      'question': 'Do car rental locations accept debit cards?',
      'answer':
          '''Yes, some rental companies accept debit cards for reservations, though they may ask for additional identification and proof of insurance when you book. Even if you can pay with a debit card, some car rental locations require a credit card for the deposit. Be sure to check the terms and conditions. If you don't own a credit card, you may not be permitted to rent a car. Cash, prepaid cards, and gift cards are never accepted for reservations.''',
    },
    {
      'question': 'Do I need insurance to rent a vehicle?',
      'answer':
          '''Yes, you must be an insured driver in order to drive a rental car. If you have personal car insurance, you should check to see whether it covers rental vehicles (and be sure to ask if there are any restrictions, such as vehicle size or international pickups). If you don't have personal insurance coverage, consider checking your credit card – it may offer a rental car policy if you use it to pay for the rental.

As a U.S. citizen, you can purchase insurance with CarRentals.com at checkout since it's not included in the base rental car rate. When reserving a car rental in some international locations, such as Mexico, you must buy additional local insurance.''',
    },
    {
      'question': 'Do all rental car companies require a deposit?',
      'answer':
          '''Many car rental companies do ask for a deposit, and deposit amounts will differ by company and car class. Luxury rentals will require a higher deposit than minivans or economy car rentals. Be sure to have a credit card available if you think you'll need to cover a deposit.''',
    },
    {
      'question': 'How old do I have to be to get a rental car?',
      'answer':
          '''In most countries, you must be between 25 and 65 years old to rent cars. You might be able to get cheap car rentals or discounts if you're outside of this age range, but you may need to pay an additional fee or purchase additional insurance.''',
    },
    {
      'question': 'What kind of car is best for me?',
      'answer': '''Economy Car
• Best for: Lower costs and smaller groups
• Category includes: Toyota Yaris, Ford Fiesta or similar

SUV
• Best for: Longer day trips with more people
• Category includes: Audi Q7, Ford Escape, or similar

Luxury Car
• Best for: Romantic couples seeking a memorable getaway
• Category includes: Chrysler 300, Buick Lacrosse, or similar

Convertible
• Best for: Sightseers wanting to soak up the weather and scenery
• Category includes: Chevy Camaro, VW Beetle Convertible, or similar

Hybrid
• Best for: Visitors who want to keep fuel costs and emissions down
• Category includes: Honda Civic, Kia Optima, or similar

Full-size SUV
• Best for: Larger groups needing comfort and luggage space
• Category includes: Ford Edge, KIA Sorento, or similar''',
    },
    {
      'question': 'Why rent with CarRentals.com?',
      'answer':
          '''You can check each rental car company's website to find the best savings, or you can compare cheap rates in one location with CarRentals.com. Here's why you should consider booking with us:

• Compare great rates easily
It's easy. Just put in your pickup and drop-off dates and locations to find the cheapest price on a car rental for your trip. Choose from a wide variety of transportation options, rental sites, and drop-off locations, including off-airport and airport locations. Decide whether you want to rent round-trip or one-way. You'll be offered cheap prices to save big dollars with internationally renowned rental companies like Alamo Rent A Car, Enterprise, Sixt, Budget, Hertz, Avis, and Thrifty.

• Big savings for smart customers
Prepay for your car rental and get exclusive rates or book in advance with no credit card needed. You simply pay at the counter and enjoy the option of free cancellation. You can also sign up for our newsletter with your email address to save even more. Look for coupon codes online and pick up the daily discounts on travel.

• Best rental deals in the United States and worldwide
Whether you want to cruise in an economy car, SUV, luxury vehicle, or minivan, there's nothing keeping you from finding the perfect car for your travel needs. With no booking or credit card fees, you'll save on rentals with us.''',
    },
  ];

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                'https://ext.same-assets.com/1648771861/774259768.svg',
                width: 48,
                height: 48,
                color: const Color(0xFF61b1bd),
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.help_outline,
                    size: 48,
                    color: Color(0xFF61b1bd),
                  );
                },
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What you need to know about renting a car',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2c4c62),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Need to rent a car for your next vacation? Before booking, take a look at the following answers to questions commonly asked by our customers.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF96a8ad),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _faqs.length,
            itemBuilder: (context, index) {
              return _buildFAQItem(index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(int index) {
    final bool isExpanded = _expandedIndex == index;
    final faq = _faqs[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFC8D1D5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedIndex = isExpanded ? -1 : index;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      faq['question'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2c4c62),
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF2c4c62),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                faq['answer'],
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF96a8ad),
                  height: 1.6,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
