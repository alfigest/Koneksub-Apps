// Definisi class RewardSubOption dalam bentuk List
class RewardSubOptions {
  // Definisi variabel List
  List<RewardSubOption>? rewardSubOptions;

  // Fungsi untuk melakukan convert dari JSON ke class
  RewardSubOptions.fromJson(List<dynamic> data) {
    rewardSubOptions = <RewardSubOption>[];
    for (var v in data) {
      rewardSubOptions!.add(v);
    }
  }

  // Fungsi untuk melakukan convert dari class ke JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (rewardSubOptions != null) {
      data[''] = rewardSubOptions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// Definisi class RewardSubOption
class RewardSubOption {
  // Definisi variabel id, option, dan description
  final String? id;
  final String? amount;
  final String? name;
  final int? points;

  // Constructor
  RewardSubOption({
    this.id,
    this.amount,
    this.name,
    this.points,
  });

  // Fungsi untuk melakukan convert dari JSON ke class
  factory RewardSubOption.fromJson(Map<String, dynamic> json) =>
      RewardSubOption(
        id: json["id"],
        amount: json["amount"],
        name: json["name"],
        points: json["points"],
      );

  // Fungsi untuk melakukan convert dari class ke JSON
  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "name": name,
        "points": points,
      };
}
