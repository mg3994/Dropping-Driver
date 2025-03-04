import 'package:flutter/cupertino.dart';
import 'package:restart_tagxi/common/app_colors.dart';
import 'package:restart_tagxi/common/app_text_styles.dart';
import 'package:restart_tagxi/core/utils/custom_text.dart';



class FareBreakdownWidget extends StatelessWidget {
  final BuildContext cont;
  final String name;
  final String price;
  const FareBreakdownWidget({super.key, required this.cont, required this.name, required this.price});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
    width: size.width * 0.8,
    padding:
        EdgeInsets.only(top: size.width * 0.025, bottom: size.width * 0.025),
    decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.grey))),
    child: Row(
      children: [
        Expanded(
            child: MyText(
          text: name,
          textStyle: AppTextStyle.normalStyle().copyWith(
              fontSize: 15,
              color: AppColors.darkGrey,
              fontWeight: FontWeight.w500),
        )),
        MyText(
          text: price,
          textStyle: AppTextStyle.normalStyle().copyWith(
              fontSize: 15,
              color: AppColors.darkGrey,
              fontWeight: FontWeight.w500),
        )
      ],
    ),
  );
  }
}