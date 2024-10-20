import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  int aiTokenCounts = 100;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Color.fromRGBO(246, 247, 250, 1.0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.flash_on,
                color: Colors.greenAccent,
              ),
              Text(
                '${aiTokenCounts}',
                style: const TextStyle(
                    color: Color.fromRGBO(
                        161, 156, 156, 1.0)),
              )
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        const Text(
          'Upgrade',
          style: TextStyle(
            color: Color.fromRGBO(160, 125, 220, 1.0),
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        const Icon(
          Icons.wallet_giftcard,
        ),
        const SizedBox(
          width: 5,
        ),
        const Icon(
          Icons.heart_broken,
        ),
        const SizedBox(
          width: 5,
        ),
        const Icon(
          Icons.breakfast_dining,
        ),
        const SizedBox(
          width: 5,
        ),
        const Icon(
          Icons.dangerous,
        ),
      ],
    );
  }
}