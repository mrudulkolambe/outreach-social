class InterestType {
  String interest;
  String icon;

  InterestType({required this.interest, required this.icon});
}


final List<InterestType> interestsOptions = [
    InterestType(
      interest: "Nutrition & Diabetes",
      icon: "assets/interests/nutrition.svg",
    ),
    InterestType(
      interest: "Lifestyle",
      icon: "assets/interests/lifestyle.svg",
    ),
    InterestType(
      interest: "Mental Health",
      icon: "assets/interests/mental-health.svg",
    ),
    InterestType(
      interest: "Physical Health",
      icon: "assets/interests/physical-health.svg",
    ),
    InterestType(
      interest: "Fitness & Exercise",
      icon: "assets/interests/fitness.svg",
    ),
    InterestType(
      interest: "Well-being",
      icon: "assets/interests/well-being.svg",
    ),
    InterestType(
      interest: "Healthy Aging",
      icon: "assets/interests/healthy-aging.svg",
    ),
  ];

List<InterestType> handleInterests(List<String> interests) {
  print(interestsOptions.where((interestType) => interests.contains(interestType.interest)).toList().length);
  return interestsOptions.where((interestType) => interests.contains(interestType.interest)).toList();
}