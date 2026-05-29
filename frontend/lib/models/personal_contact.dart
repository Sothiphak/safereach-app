class PersonalContact {
  const PersonalContact({
    required this.id,
    required this.name,
    required this.relationship,
    required this.phone,
  });

  final String id;
  final String name;
  final String relationship;
  final String phone;

  factory PersonalContact.fromJson(Map<String, dynamic> json) {
    return PersonalContact(
      id: json['id'] as String,
      name: json['name'] as String,
      relationship: json['relationship'] as String,
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'relationship': relationship,
      'phone': phone,
    };
  }

  PersonalContact copyWith({
    String? id,
    String? name,
    String? relationship,
    String? phone,
  }) {
    return PersonalContact(
      id: id ?? this.id,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      phone: phone ?? this.phone,
    );
  }
}
