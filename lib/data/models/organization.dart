class Organization {
  final String id;
  final String name;
  final String slug;
  final String currency;
  final String currencySymbol;
  final String country;
  final String plan;

  const Organization({
    required this.id,
    required this.name,
    required this.slug,
    required this.currency,
    required this.currencySymbol,
    required this.country,
    required this.plan,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    final currency = json['currency'] ?? 'USD';
    return Organization(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      currency: currency,
      currencySymbol: currency == 'INR' ? '₹' : '\$',
      country: json['country'] ?? 'United States',
      plan: json['plan'] ?? 'Enterprise Suite',
    );
  }
}
