import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/app_constants.dart';
import '../../../../../../common/common.dart';
import '../../../../../../core/model/user_detail_model.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../account/presentation/pages/admin_chat/page/admin_chat.dart';
import '../../../../application/home_bloc.dart';

class QuickActionsWidget extends StatelessWidget {
  final BuildContext cont;
  const QuickActionsWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<HomeBloc>(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Padding(
            padding:  EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor),
              child: Column(
                key: const Key('switcher1'),
                children: [
                  Container(
                    width: size.width,
                    padding: EdgeInsets.fromLTRB(
                        size.width * 0.05,
                        size.width * 0.05,
                        size.width * 0.05,
                        size.width * 0.05),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).padding.top),
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  context.read<HomeBloc>().bottomSize =  -(size.height*0.7);
                                  context.read<HomeBloc>().animatedWidget = null;
                                  context.read<HomeBloc>().add(UpdateEvent());
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: size.width * 0.05,
                                  color: Theme.of(context).disabledColor,
                                )),
                            SizedBox(width: size.width * 0.05),
                            MyText(
                              text:
                                  AppLocalizations.of(context)!.instantActivity,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (userData!.showInstantRideFeatureForMobileApp == '1') ...[
                    SizedBox(height: size.width * 0.05),
                    InkWell(
                      onTap: () {
                        context.read<HomeBloc>().bottomSize = -(size.height*0.7);
                        context.read<HomeBloc>().animatedWidget = null;
                        context.read<HomeBloc>().add(UpdateEvent());
                        context.read<HomeBloc>().add(ShowGetDropAddressEvent());
                      },
                      child: Container(
                        width: size.width * 0.9,
                        padding: EdgeInsets.all(size.width * 0.025),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context)
                                    .disabledColor
                                    .withOpacity(0.5),
                                width: 0.5),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .disabledColor
                                    .withOpacity(0.5),
                                offset: const Offset(
                                  5.0,
                                  5.0,
                                ),
                                blurRadius: 10.0,
                                spreadRadius: 2.0,
                              ), //BoxShadow
                              const BoxShadow(
                                color: Colors.white,
                                offset: Offset(0.0, 0.0),
                                blurRadius: 0.0,
                                spreadRadius: 0.0,
                              ), //BoxShadow
                            ],
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).scaffoldBackgroundColor),
                        child: Row(
                          children: [
                            Container(
                              height: size.width * 0.1,
                              width: size.width * 0.1,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).dividerColor),
                              alignment: Alignment.center,
                              child: Image.asset(
                                AppImages.instantCar,
                                width: size.width * 0.05,
                              ),
                            ),
                            SizedBox(width: size.width * 0.05),
                            Expanded(
                                child: MyText(
                              text: AppLocalizations.of(context)!.instantRide,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                            )),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: size.width * 0.05,
                              color: Theme.of(context).primaryColorDark,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: size.width * 0.05),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AdminChat.routeName);
                    },
                    child: Container(
                      width: size.width * 0.9,
                      padding: EdgeInsets.all(size.width * 0.025),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.5),
                              width: 0.5),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.5),
                              offset: const Offset(
                                5.0,
                                5.0,
                              ),
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                            const BoxShadow(
                              color: Colors.white,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ), //BoxShadow
                          ],
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).scaffoldBackgroundColor),
                      child: Row(
                        children: [
                          Container(
                            height: size.width * 0.1,
                            width: size.width * 0.1,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).dividerColor),
                            alignment: Alignment.center,
                            child: Image.asset(
                              AppImages.helpCenter,
                              width: size.width * 0.05,
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.05,
                          ),
                          Expanded(
                              child: MyText(
                            text: AppLocalizations.of(context)!.helpCenter,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                          )),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: size.width * 0.05,
                            color: Theme.of(context).primaryColorDark,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.width * 0.05),
                  if (Platform.isAndroid) ...[
                    Container(
                      width: size.width * 0.9,
                      padding: EdgeInsets.all(size.width * 0.015),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.5),
                              width: 0.5),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.5),
                              offset: const Offset(
                                5.0,
                                5.0,
                              ),
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                            const BoxShadow(
                              color: Colors.white,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ), //BoxShadow
                          ],
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).scaffoldBackgroundColor),
                      child: Row(
                        children: [
                          Container(
                            height: size.width * 0.1,
                            width: size.width * 0.1,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).dividerColor),
                            alignment: Alignment.center,
                            child: Image.asset(
                              AppImages.icon,
                              width: size.width * 0.1,
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.05,
                          ),
                          Expanded(
                              child: MyText(
                            text: AppLocalizations.of(context)!.showBubbleIcon,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                          )),
                          Switch(
                              activeColor: AppColors.green,
                              inactiveTrackColor: AppColors.darkGrey,
                              value: showBubbleIcon,
                              onChanged: (v) {
                                context
                                    .read<HomeBloc>()
                                    .add(EnableBubbleEvent(isEnabled: v));
                              })
                        ],
                      ),
                    ),
                    SizedBox(height: size.width * 0.05),
                  ],
                  if (userData!.enableSubVehicleFeature == "1")
                    InkWell(
                      onTap: () {
                        context.read<HomeBloc>().add(GetSubVehicleTypesEvent(
                            serviceLocationId: userData!.serviceLocationId!,
                            vehicleType: userData!.vehicleTypes![0]));
                      },
                      child: Container(
                        width: size.width * 0.9,
                        padding: EdgeInsets.all(size.width * 0.025),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context)
                                    .disabledColor
                                    .withOpacity(0.5),
                                width: 0.5),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .disabledColor
                                    .withOpacity(0.5),
                                offset: const Offset(
                                  5.0,
                                  5.0,
                                ),
                                blurRadius: 10.0,
                                spreadRadius: 2.0,
                              ), //BoxShadow
                              const BoxShadow(
                                color: Colors.white,
                                offset: Offset(0.0, 0.0),
                                blurRadius: 0.0,
                                spreadRadius: 0.0,
                              ), //BoxShadow
                            ],
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).scaffoldBackgroundColor),
                        child: Row(
                          children: [
                            Container(
                              height: size.width * 0.1,
                              width: size.width * 0.1,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).dividerColor),
                              alignment: Alignment.center,
                              child: Image.asset(
                                AppImages.myServices,
                                width: size.width * 0.05,
                              ),
                            ),
                            SizedBox(width: size.width * 0.05),
                            Expanded(
                                child: MyText(
                              text: AppLocalizations.of(context)!.myServices,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                            )),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: size.width * 0.05,
                              color: Theme.of(context).primaryColorDark,
                            )
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
