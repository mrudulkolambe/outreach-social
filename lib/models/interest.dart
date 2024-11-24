
class InterestType {
  String interest;
  String icon;
  String category;
  String tag; // New property

  InterestType({
    required this.interest,
    required this.icon,
    required this.category,
    required this.tag, // Initialize the new property
  });
}

final List<InterestType> interestsOptions = [
  InterestType(
    interest: "Mindfulness and Meditation",
    category: "Mindfulness & Meditation",
    icon: "assets/interests/mindfulness-and-meditation.svg",
    tag: "MindfulnessAndMeditation",
  ),
  InterestType(
    interest: "Holistic Health",
    category: "Holistic Health",
    icon: "assets/interests/holistic-health.svg",
    tag: "HolisticHealth",
  ),
  InterestType(
    interest: "Sleep Health",
    category: "Sleep Health",
    icon: "assets/interests/sleep-health.svg",
    tag: "SleepHealth",
  ),
  InterestType(
    interest: "Stress Management",
    category: "Stress Management",
    icon: "assets/interests/stress-management.svg",
    tag: "StressManagement",
  ),
  InterestType(
    interest: "Men's Health",
    category: "Men's Health",
    icon: "assets/interests/mens-health.svg",
    tag: "MensHealth",
  ),
  InterestType(
    interest: "Heart Health",
    category: "Heart Health",
    icon: "assets/interests/heart-health.svg",
    tag: "HeartHealth",
  ),
  InterestType(
    interest: "Women's Health",
    category: "Women's Health",
    icon: "assets/interests/womens-health.svg",
    tag: "WomensHealth",
  ),
  InterestType(
    interest: "Hearing Health",
    category: "Hearing Health",
    icon: "assets/interests/hearing-health.svg",
    tag: "HearingHealth",
  ),
  InterestType(
    interest: "Vision Care",
    category: "Vision Care",
    icon: "assets/interests/vision-care.svg",
    tag: "VisionCare",
  ),
  InterestType(
    interest: "Chronic Disease Management",
    category: "Chronic Disease Management",
    icon: "assets/interests/chronic-disease.svg",
    tag: "ChronicDiseaseManagement",
  ),
  InterestType(
    interest: "Healthy Cooking and Recipes",
    category: "Healthy Cooking & Recipes",
    icon: "assets/interests/healthy-cooking.svg",
    tag: "HealthyCookingAndRecipes",
  ),
  InterestType(
    interest: "Alternative Medicine",
    category: "Alternative Medicine",
    icon: "assets/interests/alternative-medicine.svg",
    tag: "AlternativeMedicine",
  ),
  InterestType(
    interest: "Rehabilitation and Recovery",
    category: "Rehabilitation & Recovery",
    icon: "assets/interests/rehabilation.svg",
    tag: "RehabilitationAndRecovery",
  ),
  InterestType(
    interest: "Skin Care and Beauty",
    category: "Skin Care & Beauty",
    icon: "assets/interests/skin-care.svg",
    tag: "SkinCareAndBeauty",
  ),
  InterestType(
    interest: "Respiratory Health",
    category: "Respiratory Health",
    icon: "assets/interests/respiratory-health.svg",
    tag: "RespiratoryHealth",
  ),
  InterestType(
    interest: "Immune System Support",
    category: "Immune System Support",
    icon: "assets/interests/immune-system.svg",
    tag: "ImmuneSystemSupport",
  ),
  InterestType(
    interest: "Cognitive Health and Brain Fitness",
    category: "Cognitive Health & Brain Fitness",
    icon: "assets/interests/cognitive-health.svg",
    tag: "CognitiveHealthAndBrainFitness",
  ),
  InterestType(
    interest: "Sexual Health and Wellness",
    category: "Sexual Health & Wellness",
    icon: "assets/interests/sexual-health.svg",
    tag: "SexualHealthAndWellness",
  ),
  InterestType(
    interest: "Dental Health and Oral Hygiene",
    category: "Dental Health & Oral Hygiene",
    icon: "assets/interests/dental-health.svg",
    tag: "DentalHealthAndOralHygiene",
  ),
  InterestType(
    interest: "Addiction Recovery",
    category: "Addiction Recovery",
    icon: "assets/interests/addiction.svg",
    tag: "AddictionRecovery",
  ),
];


List<InterestType> handleInterests(List<String> interests) {
  return interestsOptions
      .where((interestType) => interests.contains(interestType.interest))
      .toList();
}
