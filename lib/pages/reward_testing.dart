// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:waste_application/view_model/reward_option_view_model.dart';

// class RewardPage extends StatefulWidget {
//   const RewardPage({Key? key}) : super(key: key);

//   @override
//   State<RewardPage> createState() => _RewardPageState();
// }

// class _RewardPageState extends State<RewardPage> {
//   @override
//   void initState() {
//     super.initState();
//     Provider.of<RewardOptionListViewModel>(context, listen: false).getAll();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final vm = Provider.of<RewardOptionListViewModel>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Reward'),
//       ),
//       body: Column(
//         children: [
//           Expanded(child: RewardList(options: vm.options)),
//         ],
//       ),
//     );
//   }
// }

// class RewardList extends StatelessWidget {
//   const RewardList({required this.options, Key? key}) : super(key: key);
//   final List<RewardOptionViewModel> options;

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: options.length,
//       itemBuilder: (context, index) {
//         final reward = options[index];
//         return ListTile(
//           title: Text(reward.option!),
//           subtitle: Text(reward.description!),
//         );
//       },
//     );
//   }
// }
