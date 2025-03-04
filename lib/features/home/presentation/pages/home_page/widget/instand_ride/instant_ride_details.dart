

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../common/common.dart';
import '../../../../../../../common/pickup_icon.dart';
import '../../../../../../../core/model/user_detail_model.dart';
import '../../../../../../../core/utils/custom_button.dart';
import '../../../../../../../core/utils/custom_snack_bar.dart';
import '../../../../../../../core/utils/custom_text.dart';
import '../../../../../../../core/utils/custom_textfield.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../application/home_bloc.dart';

class InstantRideDetailsWidget extends StatelessWidget {
  const InstantRideDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<HomeBloc,HomeState>(
      builder: (context, state) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: (context.read<HomeBloc>().choosenGoods == null &&
                  context.read<HomeBloc>().instantRideType == null)
              ? size.width * 1.15
              : (context.read<HomeBloc>().choosenGoods != null &&
                      context.read<HomeBloc>().instantRideType != null)
                  ? size.width * 1.55
                  : (context.read<HomeBloc>().choosenGoods != null ||
                          context.read<HomeBloc>().instantRideType != null)
                      ? size.width * 1.35
                      : size.width * 1.2,
          width: size.width,
          padding: EdgeInsets.only(
              bottom: size.width * 0.04,
              left: size.width * 0.03,
              right: size.width * 0.03,
              top: size.width * 0.04),
          child: Column(
            children: [
              SizedBox(
                width: size.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.cancel,
                            size: size.width * 0.06,
                            color: Theme.of(context).primaryColorDark))
                  ],
                ),
              ),
              SizedBox(
                height: size.width * 0.05,
              ),
              if (context.read<HomeBloc>().instantRideType != null)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                              context.read<HomeBloc>().instantRideType = 'taxi';
                              context.read<HomeBloc>().add(UpdateEvent());
                          },
                          child: Row(
                            children: [
                              Container(
                                width: size.width * 0.05,
                                height: size.width * 0.05,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: (context
                                                    .read<HomeBloc>()
                                                    .instantRideType ==
                                                'taxi')
                                            ? Theme.of(context).primaryColorDark
                                            : AppColors.black)),
                                alignment: Alignment.center,
                                child: Container(
                                  width: size.width * 0.03,
                                  height: size.width * 0.03,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (context
                                                  .read<HomeBloc>()
                                                  .instantRideType ==
                                              'taxi')
                                          ? Theme.of(context).primaryColorDark
                                          : Colors.transparent),
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.025,
                              ),
                              MyText(
                                text: AppLocalizations.of(context)!.taxi,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: (context
                                                  .read<HomeBloc>()
                                                  .instantRideType ==
                                              'taxi')
                                          ? Theme.of(context).primaryColorDark
                                          : AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: size.width * 0.05),
                        InkWell(
                          onTap: () {
                              context.read<HomeBloc>().instantRideType =
                                  'delivery';
                            context.read<HomeBloc>().add(UpdateEvent());
                          },
                          child: Row(
                            children: [
                              Container(
                                width: size.width * 0.05,
                                height: size.width * 0.05,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: (context
                                                    .read<HomeBloc>()
                                                    .instantRideType ==
                                                'delivery')
                                            ? Theme.of(context).primaryColorDark
                                            : AppColors.black)),
                                alignment: Alignment.center,
                                child: Container(
                                  width: size.width * 0.03,
                                  height: size.width * 0.03,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (context
                                                  .read<HomeBloc>()
                                                  .instantRideType ==
                                              'delivery')
                                          ? AppColors.primary
                                          : Colors.transparent),
                                ),
                              ),
                              SizedBox(width: size.width * 0.025),
                              MyText(
                                text: AppLocalizations.of(context)!.delivery,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: (context
                                                  .read<HomeBloc>()
                                                  .instantRideType ==
                                              'delivery')
                                          ? Theme.of(context).primaryColorDark
                                          : AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.width * 0.05)
                  ],
                ),
              SizedBox(
                width: size.width * 0.9,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PickupIcon(),
                    SizedBox(width: size.width * 0.029),
                    Expanded(
                        child: MyText(
                      text: context.read<HomeBloc>().pickAddress,
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                      maxLines: 2,
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: size.width * 0.03,
              ),
              SizedBox(
                width: size.width * 0.9,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DropIcon(),
                    SizedBox(
                      width: size.width * 0.025,
                    ),
                    Expanded(
                        child: MyText(
                      text: context.read<HomeBloc>().dropAddress,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                      maxLines: 2,
                    )),
                  ],
                ),
              ),
              SizedBox(
                height: size.width * 0.05,
              ),
              SizedBox(
                  width: size.width * 0.9,
                  child: CustomTextField(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: Theme.of(context).primaryColorDark)),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    controller: context.read<HomeBloc>().instantUserName,
                    hintText: AppLocalizations.of(context)!.userName,
                  )),
              SizedBox(
                height: size.width * 0.05,
              ),
              SizedBox(
                  width: size.width * 0.9,
                  child: CustomTextField(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: Theme.of(context).primaryColorDark)),
                    keyboardType: TextInputType.number,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    controller: context.read<HomeBloc>().instantUserMobile,
                    hintText: AppLocalizations.of(context)!.userMobile,
                  )),
              SizedBox(height: size.width * 0.05),
              SizedBox(
                width: size.width * 0.8,
                child: MyText(
                  text:
                      '${AppLocalizations.of(context)!.cash}  ${context.read<HomeBloc>().instantRideCurrency!}${context.read<HomeBloc>().instantRidePrice!}',
                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: size.width * 0.03),
              CustomButton(
                  buttonName: (userData!.transportType == 'taxi' ||
                          context.read<HomeBloc>().instantRideType == 'taxi' ||
                          context.read<HomeBloc>().choosenGoods != null)
                      ? AppLocalizations.of(context)!.createRequest
                      : AppLocalizations.of(context)!.chooseGoods,
                  onTap: () {
                    if (context
                            .read<HomeBloc>()
                            .instantUserName
                            .text
                            .isNotEmpty &&
                        context
                            .read<HomeBloc>()
                            .instantUserMobile
                            .text
                            .isNotEmpty) {
                      if (userData!.transportType == 'taxi' ||
                          context.read<HomeBloc>().instantRideType == 'taxi' ||
                          context.read<HomeBloc>().choosenGoods != null) {
                        context.read<HomeBloc>().add(CreateInstantRideEvent());
                      } else {
                        context.read<HomeBloc>().add(GetGoodsTypeEvent());
                      }
                    } else {
                      showToast(
                          message:
                              AppLocalizations.of(context)!.enterRequiredField);
                    }
                  }),
            ],
          ),
        ),
      );
    },);
  }
}