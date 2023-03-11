// Melakukan import material untuk penggunaan widget
import 'package:flutter/material.dart';

class RedeemSuccess extends StatelessWidget {
  const RedeemSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Menampilkan gambar
          Container(
              padding: const EdgeInsets.only(left: 20),
              child: Image.asset("assets/redeem_success.png")),
          const SizedBox(height: 20),
          // Menampilkan button untuk redirect ke halaman home
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text("Kembali ke Home"))
        ],
      ),
    );
  }
}
