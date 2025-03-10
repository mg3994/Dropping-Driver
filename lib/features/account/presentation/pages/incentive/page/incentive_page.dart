import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/common/app_arguments.dart';
import 'package:restart_tagxi/common/app_colors.dart';
import 'package:restart_tagxi/common/local_data.dart';
import 'package:restart_tagxi/core/model/user_detail_model.dart';
import 'package:restart_tagxi/core/utils/custom_loader.dart';
import 'package:restart_tagxi/core/utils/custom_snack_bar.dart';
import 'package:restart_tagxi/core/utils/custom_text.dart';
import 'package:restart_tagxi/features/account/application/acc_bloc.dart';
import 'package:restart_tagxi/features/auth/presentation/pages/auth_page.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';

import '../widget/incentive_date_widget.dart';
import '../widget/upcoming_incentives_widget.dart';

class IncentivePage extends StatelessWidget {
  static const String routeName = '/incentivePage';

  const IncentivePage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(GetIncentiveEvent(
            type: userData!.availableIncentive == '0' ||
                    userData?.availableIncentive == '2'
                ? 0
                : 1)),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) async {
          if (state is IncentiveLoadingStartState) {
            CustomLoader.loader(context);
          }

          if (state is ShowErrorState) {
            showToast(message: state.message);
          }

          if (state is IncentiveLoadingStopState) {
            CustomLoader.dismiss(context);
          }
          if (state is UserUnauthenticatedState) {
            final type = await AppSharedPreference.getUserType();
            if (!context.mounted) return;
            Navigator.pushNamedAndRemoveUntil(
                context, AuthPage.routeName, (route) => false,
                arguments: AuthPageArguments(type: type));
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            // backgroundColor: AppColors.commonColor,
            body: Stack(
              children: [
                SizedBox(
                  height: size.height,
                  child: Column(children: [
                    SizedBox(
                      height: size.width * 0.55,
                      child: Column(children: [
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
                            MyText(
                              text: AppLocalizations.of(context)!.incentives,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: AppColors.white),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            SizedBox(
                              width: size.width * 0.9,
                              child: userData?.availableIncentive == '2'
                                  ? Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (context
                                                    .read<AccBloc>()
                                                    .choosenIncentiveData !=
                                                0) {
                                              context.read<AccBloc>().add(
                                                  GetIncentiveEvent(type: 0));
                                            }
                                          },
                                          child: Container(
                                            width: size.width * 0.45,
                                            padding: EdgeInsets.all(
                                                size.width * 0.05),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: (context
                                                                .read<AccBloc>()
                                                                .choosenIncentiveData ==
                                                            0)
                                                        ? AppColors.white
                                                            .withOpacity(0.7)
                                                        : Colors.transparent,
                                                    width: 2),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: MyText(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .dailyCaps,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .headlineLarge!
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: AppColors.white,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (context
                                                    .read<AccBloc>()
                                                    .choosenIncentiveData !=
                                                1) {
                                              context.read<AccBloc>().add(
                                                  GetIncentiveEvent(type: 1));
                                            }
                                          },
                                          child: Container(
                                            width: size.width * 0.45,
                                            padding: EdgeInsets.all(
                                                size.width * 0.05),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: (context
                                                                .read<AccBloc>()
                                                                .choosenIncentiveData ==
                                                            1)
                                                        ? AppColors.white
                                                            .withOpacity(0.7)
                                                        : Colors.transparent,
                                                    width: 2),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: MyText(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .weeklyCaps,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .headlineLarge!
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: AppColors.white,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : userData?.availableIncentive == '0'
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(
                                                  size.width * 0.05),
                                              child: MyText(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .dailyCaps,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .headlineLarge!
                                                    .copyWith(
                                                        fontSize: 16,
                                                        color: Theme.of(context)
                                                            .scaffoldBackgroundColor,
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        )
                                      : userData?.availableIncentive == '1'
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(
                                                      size.width * 0.05),
                                                  child: MyText(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .weeklyCaps,
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge!
                                                        .copyWith(
                                                            fontSize: 16,
                                                            color: Theme.of(
                                                                    context)
                                                                .scaffoldBackgroundColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                            ),
                          ],
                        )
                      ]),
                    ),
                    (context.read<AccBloc>().incentiveHistory.isNotEmpty &&
                            context.read<AccBloc>().incentiveDates.isNotEmpty)
                        ? Expanded(
                            child: BlocBuilder<AccBloc, AccState>(
                              builder: (context, state) {
                                if (state is ShowUpcomingIncentivesState) {
                                  return ShowUpcomingIncentivesWidget(
                                      cont: context,
                                      upcomingIncentives:
                                          state.upcomingIncentives);
                                }
                                return Center(
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .selectDateForIncentives,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                );
                              },
                            ),
                          )
                        : Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .incentiveEmptyText,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                  ]),
                ),
                (context.read<AccBloc>().incentiveHistory.isNotEmpty &&
                        context.read<AccBloc>().incentiveDates.isNotEmpty)
                    ? Positioned(
                        top: size.width * 0.43,
                        left: size.width * 0.048,
                        right: size.width * 0.048,
                        child: Container(
                          height: size.width * 0.25,
                          padding: EdgeInsets.all(size.width * 0.02),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Theme.of(context).scaffoldBackgroundColor,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).shadowColor,
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: IncentiveDateWidget(cont: context),
                        ),
                      )
                    : SizedBox()
              ],
            ),
          );
        }),
      ),
    );
  }
}
