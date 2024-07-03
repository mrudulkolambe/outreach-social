class InterestType {
  String interest;
  String icon;
  String category;

  InterestType({required this.interest, required this.icon, required this.category});
}


final List<InterestType> interestsOptions = [
    InterestType(
      interest: "Nutrition & Diabetes",
      category: "Nutrition",
      icon: "assets/interests/nutrition.svg",
    ),
    InterestType(
      interest: "Lifestyle",
      category: "Lifestyle",
      icon: "assets/interests/lifestyle.svg",
    ),
    InterestType(
      interest: "Mental Health",
      category: "Mental Health",
      icon: "assets/interests/mental-health.svg",
    ),
    InterestType(
      interest: "Physical Health",
      category: "Physical Health",
      icon: "assets/interests/physical-health.svg",
    ),
    InterestType(
      interest: "Fitness & Exercise",
      category: "Fitness",
      icon: "assets/interests/fitness.svg",
    ),
    InterestType(
      interest: "Well-being",
      category: "Well-being",
      icon: "assets/interests/well-being.svg",
    ),
    InterestType(
      interest: "Healthy Aging",
      category: "Healthy Aging",
      icon: "assets/interests/healthy-aging.svg",
    ),
  ];

List<InterestType> handleInterests(List<String> interests) {
  print(interestsOptions.where((interestType) => interests.contains(interestType.interest)).toList().length);
  return interestsOptions.where((interestType) => interests.contains(interestType.interest)).toList();
}