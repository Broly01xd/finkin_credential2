import 'package:finkin_credential/res/app_color/app_color.dart';
import 'package:finkin_credential/res/constants/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoanTrack extends StatelessWidget {
  final String imageAsset;
  final String userName;
  final String loanType;
  final DateTime date;
  final IconData icon;
  final LoanStatus status;
  final Function() onPressed;

  const LoanTrack(
      {super.key,
      required this.imageAsset,
      required this.userName,
      required this.loanType,
      required this.onPressed,
      required this.date,
      required this.icon,
      required this.status});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMd().format(date);

    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColor.textLight,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageAsset),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          loanType,
                          style: const TextStyle(fontSize: 10),
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  width: 18,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(
                          icon,
                          color: AppColor.icon,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  width: 2,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      formattedDate,
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      status.name,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
//agentform
