class InterestType {
  String interest;
  String icon;
  String category;

  InterestType(
      {required this.interest, required this.icon, required this.category});
}

final List<InterestType> interestsOptions = [
  InterestType(
    interest: "Mindfulness and Meditation",
    category: "Mindfulness & Meditation",
    icon: "assets/interests/mindfulness-and-meditation.svg",
  ),
  InterestType(
    interest: "Holistic Health",
    category: "Holistic Health",
    icon: "assets/interests/holistic-health.svg",
  ),
  InterestType(
    interest: "Sleep Health",
    category: "Sleep Health",
    icon: "assets/interests/sleep-health.svg",
  ),
  InterestType(
    interest: "Stress Management",
    category: "Stress Management",
    icon: "assets/interests/stress-management.svg",
  ),
  InterestType(
    interest: "Men's Health",
    category: "Men's Health",
    icon: "assets/interests/mens-health.svg",
  ),
  InterestType(
    interest: "Heart Health",
    category: "Heart Health",
    icon: "assets/interests/heart-health.svg",
  ),
  InterestType(
    interest: "Women's Health",
    category: "Women's Health",
    icon: "assets/interests/womens-health.svg",
  ),
  InterestType(
    interest: "Hearing Health",
    category: "Hearing Health",
    icon: "assets/interests/hearing-health.svg",
  ),
  InterestType(
    interest: "Vision Care",
    category: "Vision Care",
    icon: "assets/interests/vision-care.svg",
  ),
  InterestType(
    interest: "Chronic Disease Management",
    category: "Chronic Disease Management",
    icon: "assets/interests/chronic-disease.svg",
  ),
  InterestType(
    interest: "Healthy Cooking and Recipes",
    category: "Healthy Cooking & Recipes",
    icon: "assets/interests/healthy-cooking.svg",
  ),
  InterestType(
    interest: "Alternative Medicine",
    category: "Alternative Medicine",
    icon: "assets/interests/alternative-medicine.svg",
  ),
  InterestType(
    interest: "Rehabilitation and Recovery",
    category: "Rehabilitation & Recovery",
    icon: "assets/interests/rehabilation.svg",
  ),
  InterestType(
    interest: "Skin Care and Beauty",
    category: "Skin Care & Beauty",
    icon: "assets/interests/skin-care.svg",
  ),
  InterestType(
    interest: "Respiratory Health",
    category: "Respiratory Health",
    icon: "assets/interests/respiratory-health.svg",
  ),
  InterestType(
    interest: "Immune System Support",
    category: "Immune System Support",
    icon: "assets/interests/immune-system.svg",
  ),
  InterestType(
    interest: "Cognitive Health and Brain Fitness",
    category: "Cognitive Health & Brain Fitness",
    icon: "assets/interests/cognitive-health.svg",
  ),
  InterestType(
    interest: "Sexual Health and Wellness",
    category: "Sexual Health & Wellness",
    icon: "assets/interests/sexual-health.svg",
  ),
  InterestType(
    interest: "Dental Health and Oral Hygiene",
    category: "Dental Health & Oral Hygiene",
    icon: "assets/interests/dental-health.svg",
  ),
  InterestType(
    interest: "Addiction Recovery",
    category: "Addiction Recovery",
    icon: "assets/interests/addiction.svg",
  ),
];

List<InterestType> handleInterests(List<String> interests) {
  print(interestsOptions
      .where((interestType) => interests.contains(interestType.interest))
      .toList()
      .length);
  return interestsOptions
      .where((interestType) => interests.contains(interestType.interest))
      .toList();
}
