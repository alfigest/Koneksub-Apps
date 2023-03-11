// Melakukan import cloud_firestore untuk pengambilan data
import 'package:cloud_firestore/cloud_firestore.dart';

// Melakukan import firebase_auth untuk pengambilan data user
import 'package:firebase_auth/firebase_auth.dart';

// Melakukan import material untuk pengambilan widget
import 'package:flutter/material.dart';

// Melakukan import google font untuk penggunaan font
import 'package:google_fonts/google_fonts.dart';

// Melakukan import provider untuk variabel Provider dan ChangeNotifierProvider
import 'package:provider/provider.dart';

// Melakukan import model Reward Option di folder model
import 'package:waste_application/model/reward_option.dart';

// Melakukan import model Reward Sub Option di folder model
import 'package:waste_application/model/reward_sub_option.dart';

// Melakukan import view model reward
import 'package:waste_application/view_model/redeem_view_model.dart';

// Melakukan import untuk mengambil enum status
import '../data/response/status.dart';

// Class stateful widget RedeemPage
class RedeemPoint extends StatefulWidget {
  const RedeemPoint({Key? key}) : super(key: key);

  @override
  State<RedeemPoint> createState() => _RedeemPointState();
}

class _RedeemPointState extends State<RedeemPoint> {
  // Definisi variabel untuk view model
  RedeemViewViewModel redeemViewViewModel = RedeemViewViewModel();

  // Definisi variabel List reward sub options
  List<RewardSubOptions> rewardSubOptions = [];

  // Definisi variabel untuk mapping reward sub options
  Map<String, RewardSubOptions> rewardSubOptionsMap = {};

  // Definisi variabel bool untuk hanya sekali load
  bool firstLoad = true;

  // Definisi variabel untuk menampung data point user
  int point = 0;

  // Definisi variabel untuk menampung data input number
  String number = "0";

  // Definisi variabel untuk menampung data email user
  String email = "";

  //Definisi panjang tab
  int tabLength = 1;

  // Definisi variabel controller untuk input number
  final TextEditingController _controller = TextEditingController();

  // Fungsi init state untuk load data reward dan mengambil data user
  @override
  void initState() {
    redeemViewViewModel.fetchRewardOptionsApi();
    super.initState();
  }

  // Fungsi helper untuk mengubah state jika terjadi perubahan data
  void _onTapCard() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    email = ModalRoute.of(context)!.settings.arguments as String;
    if (email == "") {
      email = FirebaseAuth.instance.currentUser!.email.toString();
    }
    getPoint(email);
    // Definisi variabel lebar card
    double cardWidth = (MediaQuery.of(context).size.width - 2 * 24 - 40) / 3;
    // ignore: avoid_unnecessary_containers
    return Container(
      // Proses pengambilan data reward options
      child: ChangeNotifierProvider<RedeemViewViewModel>(
        create: (context) => redeemViewViewModel,
        child: Consumer<RedeemViewViewModel>(
          builder: (BuildContext context, value, __) {
            // Pengecekan status data reward options
            switch (value.rewardOptions.status) {
              // Jika status data reward options adalah loading maka akan menampilkan animasi loading
              case Status.LOADING:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case Status.COMPLETED:
                // Pengecekan jika hanya sekali load
                if (firstLoad) {
                  firstLoad = false;
                  tabLength = value.rewardOptions.data!.rewardOptions!.length;
                  // Pengambilan data sub reward option dari id reward option
                  for (var i = 0;
                      i < value.rewardOptions.data!.rewardOptions!.length;
                      i++) {
                    value
                        .fetchRewardSubOptionsApi(
                            value.rewardOptions.data!.rewardOptions![i].id!)
                        .then((result) {
                      setState(() {
                        rewardSubOptionsMap[value
                            .rewardOptions
                            .data!
                            .rewardOptions![i]
                            .id!] = value.rewardSubOptions.data!;
                      });
                    });
                  }
                }
                // Menampilkan list tab reward option
                return DefaultTabController(
                  length: tabLength,
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    backgroundColor: const Color(0xff030E22),
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      toolbarHeight: 200,
                      backgroundColor: const Color(0xFFFFFFFF),
                      flexibleSpace: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 50.0,
                              left: 10,
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      left: 30,
                                      right: 30,
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF00880C),
                                      border: Border.all(
                                        color: const Color(0xff030E22),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // GestureDetector(
                                        //   child: Image.asset(
                                        //     'assets/box_left.png',
                                        //     width: 40,
                                        //     color: const Color(0xff030E22),
                                        //   ),
                                        //   onTap: () {
                                        //     Navigator.pop(context);
                                        //   },
                                        // ),
                                        // const SizedBox(width: 20),
                                        Text(
                                          point.toString(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Text(
                                          'Poin Kamu',
                                          style: GoogleFonts.montserrat(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 200,
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                        ),
                                        child: TextField(
                                          decoration: const InputDecoration(
                                            hintText: '0',
                                            border: InputBorder.none,
                                          ),
                                          style: GoogleFonts.montserrat(
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0),
                                            fontSize: 24,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          controller: _controller,
                                        ),
                                      ),
                                      Text(
                                        'No. Telp',
                                        style: GoogleFonts.montserrat(
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TabBar(
                            isScrollable: true,
                            indicatorColor: const Color(0xFF00880C),
                            // Fungsi untuk loop dan render tab reward option
                            tabs: tabMaker(value),
                            onTap: (index) {},
                          )
                        ],
                      ),
                    ),
                    body: TabBarView(
                      // Menampilkan list reward sub option. Jika masih loading, tampilkan animasi loading. Jika sudah selesai fetch data, panggil fungsi getTabBarView untuk render list reward sub option
                      children: rewardSubOptionsMap.length ==
                              value.rewardOptions.data!.rewardOptions!.length
                          ? getTabBarView(
                              value, rewardSubOptionsMap, cardWidth, _onTapCard)
                          : getTabBarLoading(tabLength),
                    ),
                  ),
                );
              // Jika status data reward options adalah error maka akan menampilkan pesan error
              case Status.ERROR:
                return const Center(
                  child:
                      Text('Error Fetch', style: TextStyle(color: Colors.red)),
                );
              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      ),
    );
  }

  getTabBarLoading(int length) {
    List<Widget> list = [];
    for (int i = 0; i < length; i++) {
      list.add(
        const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return list;
  }

  // Fungsi untuk loop dan render list sub reward option
  getTabBarView(
      RedeemViewViewModel value,
      Map<dynamic, RewardSubOptions> rewardSubOptionsMap,
      double cardWidth,
      Function onTapCard) {
    List<Widget> list = [];
    for (int i = 0; i < value.rewardOptions.data!.rewardOptions!.length; i++) {
      list.add(
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFFFFFFFF),
          body: Container(
            padding: const EdgeInsets.all(30),
            child: Wrap(
              spacing: 20,
              runSpacing: 14,
              children: getTabBarRow(
                  value: value,
                  rewardSubOptionsRow: rewardSubOptionsMap[
                          value.rewardOptions.data!.rewardOptions![i].id!]!
                      .rewardSubOptions!,
                  optionId: value.rewardOptions.data!.rewardOptions![i].id!,
                  cardWidth: cardWidth,
                  onTapCard: onTapCard),
            ),
          ),
        ),
      );
    }
    return list;
  }

  // Fungsi untuk loop dan render list sub reward option
  getTabBarRow(
      {required RedeemViewViewModel value,
      required List<RewardSubOption> rewardSubOptionsRow,
      String optionId = "",
      double cardWidth = 24,
      required Function onTapCard}) {
    List<Widget> list = [];
    for (var j = 0; j < rewardSubOptionsRow.length; j++) {
      RewardSubOption data = rewardSubOptionsRow[j];
      list.add(
        makeMoneyCard(
            point: data.points!,
            amount: data.amount!,
            optionId: optionId,
            subOptionId: data.id!,
            userId: email,
            width: cardWidth,
            value: value,
            userPoint: point),
      );
    }
    return list;
  }

  Future<void> getPoint(String paramEmail) async {
    final DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection('UserDetail')
        .doc(paramEmail)
        .get();
    final int tempPoint = doc.data()!['point'];
    final String tempNumber = doc.data()!['phone_number'];
    if (mounted) {
      setState(() {
        point = tempPoint;
        number = '0$tempNumber';
        _controller.text = number;
      });
    }
    // });
  }

  // Fungsi untuk mengambil data user berupa point dan nomor telepon
  Future<void> getUserDetail() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    email = user!.email!;
    final DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection('UserDetail')
        .doc(email)
        .get();
    final int tempPoint = doc.data()!['point'];
    final String tempNumber = doc.data()!['phone_number'];
    setState(() {
      point = tempPoint;
      number = '0$tempNumber';
      _controller.text = number;
    });
  }

  // Fungsi untuk melakukan render card sub reward
  makeMoneyCard(
      {required int point,
      required int userPoint,
      required double width,
      required String amount,
      required String optionId,
      required String subOptionId,
      required String userId,
      required RedeemViewViewModel value}) {
    bool isSelected = false;
    return MoneyCard(
      amount: amount,
      width: width,
      point: point,
      isSelected: isSelected,
      onTap: () {
        setState(() {
          isSelected = true;
        });
        if (userPoint - point >= 0) {
          return showDialog(
            context: context,
            builder: (BuildContext Dialogcontext) => AlertDialog(
              title: const Text('Apakah anda yakin ingin menukar poin?'),
              content: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Poin Sebelumnya"),
                        Text('${userPoint.toString()}  ')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Poin Akan Ditukar"),
                        Text('${point.toString()} -')
                      ],
                    ),
                    const Divider(color: Colors.black),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Sisa Poin"),
                        Text('${(userPoint - point).toString()}  ')
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(Dialogcontext, false),
                  child: const Text("Tidak"),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(Dialogcontext, true);
                    await value
                        .addRewardTransactionApi(optionId, subOptionId, userId,
                            point, (userPoint - point))
                        .then((value) =>
                            Navigator.of(context).pushNamed('/redeem-success'));
                  },
                  child: const Text("Ya"),
                ),
              ],
            ),
          );
        } else {
          return showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Poin anda tidak mencukupi'),
              content: const Text(
                  "Maaf, poin anda belum mencukupi untuk menukar dengan reward ini"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  // Fungsi untuk redirect ke halaman home
  void confirmReward(BuildContext localContext) {
    Navigator.of(localContext).pushNamed('/home');
  }
}

// Class widget untuk render card sub reward
class MoneyCard extends StatelessWidget {
  final double width;
  final bool isSelected;
  final int point;
  final Function onTap;
  final String amount;

  MoneyCard(
      {this.isSelected = false,
      this.point = 0,
      required this.onTap,
      this.width = 100,
      this.amount = '0 GB'});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
        print(isSelected);
      },
      child: Container(
        width: width,
        height: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
                color: isSelected ? Colors.transparent : Color(0xFFE4E4E4)),
            color: isSelected ? Colors.grey : Colors.transparent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              point.toString(),
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF00880C),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              amount,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Fungsi untuk loop dan render tab reward option
tabMaker(RedeemViewViewModel value) {
  List<Tab> tabs = [];
  for (var i = 0; i < value.rewardOptions.data!.rewardOptions!.length; i++) {
    tabs.add(
      Tab(
        child: Text(
          value.rewardOptions.data!.rewardOptions![i].option!,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            color: const Color(0xFF00880C),
          ),
        ),
      ),
    );
  }
  return tabs;
}

// Class widget untuk menampung reward
class OptionItem extends StatelessWidget {
  final RewardOption item;

  const OptionItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        item.option ?? '',
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w500,
          color: const Color(0xFF00880C),
        ),
      ),
    );
  }
}

// Class widget untuk menampung sub reward
class OptionDetail extends StatelessWidget {
  final RewardSubOption item;

  const OptionDetail({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFFFFFFF),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Center(
            child: InkWell(
              onTap: () {},
              child: Container(
                width: 342,
                height: 176,
                decoration: BoxDecoration(
                  color: const Color(0xFFBBBBBB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [Text(item.name ?? '')],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
