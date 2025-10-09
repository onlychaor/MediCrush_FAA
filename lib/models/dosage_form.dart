class DosageForm {
  final String form;
  final String alteration;
  final String reference;

  const DosageForm({
    required this.form,
    required this.alteration,
    required this.reference,
  });

  // Factory constructor từ Map (cho SQLite/JSON)
  factory DosageForm.fromMap(Map<String, dynamic> map) {
    return DosageForm(
      form: map['form'] ?? '',
      alteration: map['alteration'] ?? '',
      reference: map['reference'] ?? '',
    );
  }

  // Chuyển đổi thành Map
  Map<String, dynamic> toMap() {
    return {
      'form': form,
      'alteration': alteration,
      'reference': reference,
    };
  }

  // Factory constructor từ JSON
  factory DosageForm.fromJson(Map<String, dynamic> json) {
    return DosageForm(
      form: json['form'] ?? '',
      alteration: json['alteration'] ?? '',
      reference: json['reference'] ?? '',
    );
  }

  // Chuyển đổi thành JSON
  Map<String, dynamic> toJson() {
    return {
      'form': form,
      'alteration': alteration,
      'reference': reference,
    };
  }
}

