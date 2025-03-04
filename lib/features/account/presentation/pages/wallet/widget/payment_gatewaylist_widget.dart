import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/model/user_detail_model.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';
import '../../../../domain/models/walletpage_model.dart';

class PaymentGatewaylistWidget extends StatelessWidget {
  final BuildContext cont;
  final List<PaymentGateway> walletPaymentGatways;
  const PaymentGatewaylistWidget({super.key, required this.cont, required this.walletPaymentGatways});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(value: cont.read<AccBloc>(),
    child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
      return walletPaymentGatways.isNotEmpty
          ? Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  SizedBox(
                    height: size.width * 0.05,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: walletPaymentGatways.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        return Column(
                          children: [
                            (walletPaymentGatways[index].enabled == true)
                                ? InkWell(
                                    onTap: () {
                                      context.read<AccBloc>().add(
                                          PaymentOnTapEvent(
                                              selectedPaymentIndex: index));
                                    },
                                    child: Container(
                                      width: size.width * 0.9,
                                      padding:
                                          EdgeInsets.all(size.width * 0.02),
                                      margin: EdgeInsets.only(
                                          bottom: size.width * 0.025),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              width: 0.5,
                                              color: Theme.of(context)
                                                  .disabledColor
                                                  .withOpacity(0.5))),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl:
                                                      walletPaymentGatways[
                                                              index]
                                                          .image,
                                                  width: 30,
                                                  height: 40,
                                                  fit: BoxFit.contain,
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const Center(
                                                    child: Text(
                                                      "",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(
                                                      size.width * 0.01),
                                                ),
                                                MyText(
                                                    text: walletPaymentGatways[
                                                            index]
                                                        .gateway
                                                        .toString(),
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 15)),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: size.width * 0.05,
                                            height: size.width * 0.05,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    width: 1.5,
                                                    color: Theme.of(context)
                                                        .primaryColorDark)),
                                            alignment: Alignment.center,
                                            child: Container(
                                              width: size.width * 0.03,
                                              height: size.width * 0.03,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: (context
                                                              .read<AccBloc>()
                                                              .choosenPaymentIndex ==
                                                          index)
                                                      ? Theme.of(context)
                                                          .primaryColorDark
                                                      : Colors.transparent),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        );
                      },
                    ),
                  ),
                  CustomButton(
                      buttonName: AppLocalizations.of(context)!.pay,
                      onTap: () async {
                        Navigator.pop(context);
                        context.read<AccBloc>().add(
                              WalletPageReUpdateEvent(
                                currencySymbol: context
                                    .read<AccBloc>()
                                    .walletResponse!
                                    .currencySymbol,
                                from: '',
                                requestId: '',
                                planId: '',
                                money:
                                    context.read<AccBloc>().addMoney.toString(),
                                url: walletPaymentGatways[context
                                        .read<AccBloc>()
                                        .choosenPaymentIndex!]
                                    .url,
                                userId: userData!.userId.toString(),
                              ),
                            );
                      }),
                  SizedBox(
                    height: size.width * 0.05
                  )
                ],
              ),
            )
          : const SizedBox();
    }),);
  }
}