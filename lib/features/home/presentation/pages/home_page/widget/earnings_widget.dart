import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/app_constants.dart';
import '../../../../../../common/common.dart';
import '../../../../../../core/model/user_detail_model.dart';
import '../../../../../../core/utils/custom_divider.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/home_bloc.dart';

class EarningsWidget extends StatelessWidget {
  final BuildContext cont;
  const EarningsWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<HomeBloc>(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Column(
            key: const Key('switcher'),
            children: [
              Container(
                width: size.width * 0.15,
                height: size.width * 0.01,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Theme.of(context).disabledColor.withOpacity(0.2),
                ),
              ),
              SizedBox(height: size.width * 0.05),
              if (context.read<HomeBloc>().outStationList.isNotEmpty) ...[
                InkWell(
                  onTap: () {
                    context
                        .read<HomeBloc>()
                        .add(ShowoutsationpageEvent(isVisible: true));
                  },
                  child: Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      color: AppColors.lightGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(
                              text:
                                  AppLocalizations.of(context)!.outstationRides,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.lightGreen)),
                          MyText(
                              text: AppLocalizations.of(context)!.textView,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: size.width * 0.02),
              Row(
                children: [
                  Expanded(
                    child: MyText(
                      text: AppLocalizations.of(context)!.todaysEarnings,
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontSize: AppConstants().subHeaderSize,
                                // fontWeight: FontWeight.w400),
                              ),
                    ),
                  ),
                  MyText(
                    text:
                        '${userData!.currencySymbol}${userData!.totalEarnings}',
                    textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: const Color(0xff09CE1D),
                        fontSize: AppConstants().buttonTextSize,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              SizedBox(height: size.width * 0.03),
              const HorizontalDotDividerWidget(),
              SizedBox(height: size.width * 0.05),
              Row(
                children: [
                  SizedBox(
                    width: size.width * 0.3,
                    child: Column(
                      children: [
                        MyText(
                          text:
                              '${(Duration(minutes: int.parse(userData!.totalMinutesOnline!)).inHours.toString().padLeft(2, '0'))} : ${((Duration(minutes: int.parse(userData!.totalMinutesOnline!)).inMinutes % 60).toString().padLeft(2, '0'))} ${(Duration(minutes: int.parse(userData!.totalMinutesOnline!)).inHours == 0 ? 'min' : 'hr')}',
                          textStyle:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        MyText(
                          text: AppLocalizations.of(context)!.active,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: AppColors.darkGrey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            right: BorderSide(color: AppColors.darkGrey),
                            left: BorderSide(color: AppColors.darkGrey))),
                    width: size.width * 0.3,
                    child: Column(
                      children: [
                        MyText(
                          text: '${userData!.totalKms} Km',
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context).primaryColorDark,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                        ),
                        MyText(
                          text: AppLocalizations.of(context)!.distance,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: AppColors.darkGrey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.3,
                    child: Column(
                      children: [
                        MyText(
                          text: userData!.totalRidesTaken!,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context).primaryColorDark,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                        ),
                        MyText(
                          text: AppLocalizations.of(context)!.ridesTaken,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: AppColors.darkGrey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
