// Definisi class dalam bentuk List
class RewardOptions {
  // Definisi variabel List
  List<RewardOption>? rewardOptions;

  // Fungsi untuk melakukan convert dari JSON ke class
  RewardOptions.fromJson(List<dynamic> data) {
    rewardOptions = <RewardOption>[];
    for (var v in data) {
      rewardOptions!.add(v);
    }
  }

  // Fungsi untuk melakukan convert dari class ke JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (rewardOptions != null) {
      data[''] = rewardOptions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// Definisi class RewardOption
class RewardOption {
  // Definisi variabel id, option, dan description
  final String? id;
  final String? option;
  final String? description;

  // Constructor
  RewardOption({
    this.id,
    this.option,
    this.description,
  });

  // Fungsi untuk melakukan convert dari JSON ke class
  factory RewardOption.fromJson(Map<String, dynamic> json) => RewardOption(
        id: json["id"],
        option: json["option"],
        description: json["description"],
      );

  // Fungsi untuk melakukan convert dari class ke JSON
  Map<String, dynamic> toJson() => {
        "id": id,
        "option": option,
        "description": description,
      };
}
