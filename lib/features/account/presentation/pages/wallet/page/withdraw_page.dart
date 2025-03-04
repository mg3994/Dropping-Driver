import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/common/common.dart';
import 'package:restart_tagxi/core/model/user_detail_model.dart';
import 'package:restart_tagxi/core/utils/custom_button.dart';
import 'package:restart_tagxi/core/utils/custom_snack_bar.dart';
import 'package:restart_tagxi/core/utils/custom_text.dart';
import 'package:restart_tagxi/core/utils/custom_textfield.dart';
import 'package:restart_tagxi/core/utils/extensions.dart';
import 'package:restart_tagxi/features/account/application/acc_bloc.dart';
import 'package:restart_tagxi/features/account/presentation/pages/wallet/widget/wallet_shimmer.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../widget/withdraw_history_data_widget.dart';
import '../widget/withdraw_money_wallet_widget.dart';

class WithdrawPage extends StatelessWidget {
  static const String routeName = '/withdrawPage';

  const WithdrawPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()..add(GetWithdrawInitEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is WithdrawDataLoadingStartState) {
            CustomLoader.loader(context);
          } else if (state is WithdrawDataLoadingStopState) {
            CustomLoader.dismiss(context);
          } else if (state is ShowErrorState) {
            context.showSnackBar(color: AppColors.red, message: state.message);
          } else if (state is BankUpdateSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text(AppLocalizations.of(context)!.paymentMethodSuccess)));
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: Stack(
              children: [
                SizedBox(
                  height: size.height,
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.width * 0.5,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).padding.top,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: size.height * 0.08,
                                    width: size.width * 0.08,
                                    margin: EdgeInsets.only(
                                        left: size.width * 0.05,
                                        right: size.width * 0.05),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(5.0, 5.0),
                                          blurRadius: 10.0,
                                          spreadRadius: 2.0,
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(
                                        CupertinoIcons.back,
                                        size: 20,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.width * 0.25,
                                width: size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    MyText(
                                        text: AppLocalizations.of(context)!
                                            .walletBalance,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: Colors.white)),
                                    if (context
                                            .read<AccBloc>()
                                            .isWithdrawLoading &&
                                        !context
                                            .read<AccBloc>()
                                            .loadWithdrawMore)
                                      SizedBox(
                                        height: size.width * 0.06,
                                        width: size.width * 0.06,
                                        child: const Loader(
                                          color: AppColors.white,
                                        ),
                                      ),
                                    if (context
                                            .read<AccBloc>()
                                            .withdrawResponse !=
                                        null)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          MyText(
                                              text:
                                                  '${context.read<AccBloc>().withdrawResponse!.walletBalance.toString()} ${userData!.currencySymbol.toString()}',
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge!
                                                  .copyWith(
                                                      color: Colors.white)),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: size.width,
                          padding: EdgeInsets.all(size.width * 0.05),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: size.width * 0.075),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyText(
                                    text: AppLocalizations.of(context)!
                                        .recentWithdrawal,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .primaryColorDark),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.width * 0.025),
                              if (context.read<AccBloc>().isWithdrawLoading &&
                                  context.read<AccBloc>().firstWithdrawLoad)
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: 8,
                                    itemBuilder: (context, index) {
                                      return ShimmerWalletHistory(size: size);
                                    },
                                  ),
                                ),
                              if (context.read<AccBloc>().isWithdrawLoading ==
                                  false) ...[
                                Expanded(
                                  child: SingleChildScrollView(
                                    controller: context
                                        .read<AccBloc>()
                                        .scrollController,
                                    child: Column(
                                      children: [
                                        WithdrawHistoryDataWidget(
                                         withdrawHistoryList: context.read<AccBloc>().withdrawData,
                                         cont: context,
                                        ),
                                        if (context
                                            .read<AccBloc>()
                                            .loadWithdrawMore)
                                          Center(
                                            child: SizedBox(
                                                height: size.width * 0.08,
                                                width: size.width * 0.08,
                                                child:
                                                    const CircularProgressIndicator()),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                CustomButton(
                                    width: size.width * 0.7,
                                    buttonName: AppLocalizations.of(context)!
                                        .requestWithdraw,
                                    onTap: () {
                                      if (context
                                          .read<AccBloc>()
                                          .bankDetails
                                          .where((e) =>
                                              e['driver_bank_info']['data']
                                                  .toString() !=
                                              '[]')
                                          .isNotEmpty) {
                                        context
                                            .read<AccBloc>()
                                            .withdrawAmountController
                                            .clear();
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (builder) {
                                              return WithdrawMoneyWalletWidget(
                                                  cont :context);
                                            });
                                      } else {
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (builder) {
                                              return Container(
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                width: size.width,
                                                padding: EdgeInsets.all(
                                                    size.width * 0.05),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      width: size.width * 0.9,
                                                      child: MyText(
                                                        text:
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .paymentMethods,
                                                        textStyle: Theme.of(
                                                                context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColorDark),
                                                      ),
                                                    ),
                                                    SizedBox(height: size.width * 0.05),
                                                    if(context.read<AccBloc>().bankDetails.isNotEmpty)
                                                    ListView.builder(
                                                      itemCount: context.read<AccBloc>().bankDetails.length,
                                                      shrinkWrap: true,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      padding: EdgeInsets.zero,
                                                      itemBuilder: (_, i) {
                                                        final bank = context.read<AccBloc>().bankDetails.elementAt(i);
                                                        return InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                          context
                                                              .read<AccBloc>()
                                                              .add(AddBankEvent(
                                                                  choosen: i));
                                                        },
                                                        child: Container(
                                                          width:
                                                              size.width * 0.9,
                                                          margin: EdgeInsets.only(
                                                              bottom:
                                                                  size.width *
                                                                      0.025),
                                                          padding:
                                                              EdgeInsets.all(
                                                            size.width * 0.05,
                                                          ),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: Theme.of(
                                                                      context)
                                                                  .disabledColor
                                                                  .withOpacity(
                                                                      0.3)),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: MyText(
                                                                    text: bank['method_name'],
                                                                    textStyle: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyLarge!
                                                                        .copyWith(
                                                                            color:
                                                                                Theme.of(context).primaryColorDark)),
                                                              ),
                                                              MyText(
                                                                  text: (bank['driver_bank_info'][
                                                                                  'data']
                                                                              .toString() ==
                                                                          '[]')
                                                                      ? AppLocalizations.of(
                                                                              context)!
                                                                          .textAdd
                                                                      : AppLocalizations.of(
                                                                              context)!
                                                                          .textView,
                                                                  textStyle: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium!
                                                                      .copyWith(
                                                                          color:
                                                                              Theme.of(context).primaryColorDark)),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                      },)
                                                      ],
                                                ),
                                              );
                                            });
                                      }
                                    })
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: size.width * 0.45,
                    left: size.width * 0.05,
                    right: size.width * 0.05,
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (builder) {
                              return Container(
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(0.8),
                                width: size.width,
                                padding: EdgeInsets.all(size.width * 0.05),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.9,
                                      child: MyText(
                                        text: AppLocalizations.of(context)!
                                            .paymentMethods,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColorDark),
                                      ),
                                    ),
                                    SizedBox(height: size.width * 0.05),
                                  if(context.read<AccBloc>().bankDetails.isNotEmpty)
                                  ListView.builder(
                                    itemCount: context.read<AccBloc>().bankDetails.length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, i) {
                                    return InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      (context
                                                  .read<AccBloc>()
                                                  .bankDetails[i]
                                                      ['driver_bank_info']
                                                      ['data']
                                                  .toString() ==
                                              '[]')
                                          ? context
                                              .read<AccBloc>()
                                              .add(AddBankEvent(choosen: i))
                                          : context.read<AccBloc>().add(
                                              EditBankEvent(choosen: i));
                                    },
                                    child: Container(
                                      width: size.width * 0.9,
                                      margin: EdgeInsets.only(
                                          bottom: size.width * 0.025),
                                      padding: EdgeInsets.all(
                                        size.width * 0.05,
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Theme.of(context)
                                              .disabledColor
                                              .withOpacity(0.5)),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: MyText(
                                                text: context
                                                        .read<AccBloc>()
                                                        .bankDetails[i]
                                                    ['method_name'],
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                        color: Theme.of(
                                                                context)
                                                            .primaryColorDark)),
                                          ),
                                          MyText(
                                              text: (context
                                                          .read<AccBloc>()
                                                          .bankDetails[i][
                                                              'driver_bank_info']
                                                              ['data']
                                                          .toString() ==
                                                      '[]')
                                                  ? AppLocalizations.of(
                                                          context)!
                                                      .textAdd
                                                  : AppLocalizations.of(
                                                          context)!
                                                      .textView,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color: Theme.of(
                                                              context)
                                                          .primaryColorDark)),
                                        ],
                                      ),
                                    ),
                                  );
                                  },)
                                  ],
                                ),
                              );
                            });
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                            size.width * 0.05,
                            size.width * 0.025,
                            size.width * 0.05,
                            size.width * 0.025),
                        width: size.width * 0.5,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                offset: const Offset(0, 4),
                                spreadRadius: 0,
                                blurRadius: 5)
                          ],
                        ),
                        alignment: Alignment.center,
                        child: MyText(
                          text:
                              AppLocalizations.of(context)!.updatePaymentMethod,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Theme.of(context).primaryColorDark),
                        ),
                      ),
                    )),
                if (context.read<AccBloc>().addBankInfo ||
                    context.read<AccBloc>().editBank)
                  Positioned(
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(size.width * 0.05),
                      height: size.height,
                      width: size.width,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).padding.top,
                          ),
                          SizedBox(
                            width: size.width * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (context.read<AccBloc>().editBank) {
                                      context
                                          .read<AccBloc>()
                                          .add(EditBankEvent(choosen: null));
                                    } else {
                                      context
                                          .read<AccBloc>()
                                          .add(AddBankEvent(choosen: null));
                                    }
                                  },
                                  child: Container(
                                    height: size.height * 0.08,
                                    width: size.width * 0.08,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      shape: BoxShape.circle,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(5.0, 5.0),
                                          blurRadius: 10.0,
                                          spreadRadius: 2.0,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      CupertinoIcons.back,
                                      size: 20,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                  ),
                                ),
                                MyText(
                                  text: context.read<AccBloc>().editBank
                                      ? AppLocalizations.of(context)!
                                          .editBankDetails
                                      : AppLocalizations.of(context)!
                                          .bankDetails,
                                  textStyle: TextStyle(
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox( width: size.width * 0.08)
                              ],
                            ),
                          ),
                          SizedBox(height: size.width * 0.05),
                          SizedBox(
                            height: size.height * 0.6,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                    if(context.read<AccBloc>().choosenBankList.isNotEmpty)
                                    ListView.builder(
                                      itemCount: context.read<AccBloc>().choosenBankList.length,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                      return Column(
                                            children: [
                                              SizedBox(height: size.width * 0.05),
                                              SizedBox(
                                                width: size.width * 0.9,
                                                child: MyText(
                                                  text: context
                                                          .read<AccBloc>()
                                                          .choosenBankList[index]
                                                      ['placeholder'],
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(fontSize: 16),
                                                ),
                                              ),
                                              SizedBox(height: size.width * 0.025),
                                              SizedBox(
                                                width: size.width * 0.9,
                                                child: CustomTextField(
                                                  keyboardType: context
                                                                  .read<AccBloc>()
                                                                  .choosenBankList[index]
                                                              [
                                                              'input_field_type'] ==
                                                          "text"
                                                      ? TextInputType.text
                                                      : TextInputType.number,
                                                  readOnly: context
                                                      .read<AccBloc>()
                                                      .editBank,
                                                  controller: context
                                                      .read<AccBloc>()
                                                      .bankDetailsText[index],
                                                  hintText: context
                                                          .read<AccBloc>()
                                                          .choosenBankList[index]
                                                      ['placeholder'],
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColorDark)),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColorDark)),
                                                  disabledBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColorDark)),
                                                ),
                                              ),
                                            ],
                                          );
                                    },)]
                              ),
                            ),
                          ),
                          SizedBox(height: size.width * 0.05),
                          CustomButton(
                              buttonName: AppLocalizations.of(context)!.confirm,
                              onTap: () {
                                Map body = {
                                  "method_id": context
                                      .read<AccBloc>()
                                      .choosenBankList[0]['method_id'],
                                };

                                for (var i = 0;
                                    i <
                                        context
                                            .read<AccBloc>()
                                            .choosenBankList
                                            .length;
                                    i++) {
                                  if ((context
                                                  .read<AccBloc>()
                                                  .choosenBankList[i]
                                                      ['is_required']
                                                  .toString() ==
                                              '1' &&
                                          context
                                              .read<AccBloc>()
                                              .bankDetailsText[i]
                                              .text
                                              .isNotEmpty) ||
                                      context
                                          .read<AccBloc>()
                                          .bankDetailsText[i]
                                          .text
                                          .isNotEmpty) {
                                    body["${context.read<AccBloc>().choosenBankList[i]['input_field_name']}"] =
                                        context
                                            .read<AccBloc>()
                                            .bankDetailsText[i]
                                            .text;
                                  } else if (context
                                          .read<AccBloc>()
                                          .choosenBankList[i]['is_required']
                                          .toString() ==
                                      '1') {
                                    showToast(
                                        message: AppLocalizations.of(context)!
                                            .enterRequiredField);
                                    return;
                                  }
                                }
                                context
                                    .read<AccBloc>()
                                    .add(UpdateBankDetailsEvent(body: body));
                              }),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          );
        }),
      ),
    );
  }
}
