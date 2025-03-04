import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../../../common/common.dart';
import '../../../../../../../core/model/user_detail_model.dart';
import '../../../../../../../core/utils/custom_button.dart';
import '../../../../../../../core/utils/custom_snack_bar.dart';
import '../../../../../../../core/utils/custom_text.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../account/presentation/widgets/top_bar.dart';
import '../../../../../application/home_bloc.dart';

class RideOtpWidget extends StatelessWidget {
  final BuildContext cont;
  const RideOtpWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final homeBloc = cont.read<HomeBloc>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider.value(
        value: homeBloc,
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if(state is RideStartSuccessState){
              Navigator.pop(context,userData);
            }
            if(state is ShowSignatureState){
               Navigator.pop(context,userData);
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return Container(
                height: size.height,
                width: size.width,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: TopBarDesign(
                  isHistoryPage: false,
                  isOngoingPage: false,
                  title: (userData!.onTripRequest != null &&
                          userData!.onTripRequest!.transportType == 'delivery')
                      ? AppLocalizations.of(context)!.shipmentVerification
                      : AppLocalizations.of(context)!.rideVerification,
                  onTap: () {
                    if (homeBloc.showImagePick) {
                      homeBloc.add(ShowImagePickEvent());
                    } else {
                      homeBloc.add(ShowOtpEvent());
                    }
                    Navigator.pop(context, userData);
                  },
                  child: Column(
                    children: [
                      SizedBox(height: size.width * 0.2),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: size.width * 0.9,
                              height: size.width * 0.65,
                              padding: EdgeInsets.all(size.width * 0.05),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Theme.of(context)
                                    .disabledColor
                                    .withOpacity(0.3),
                                border: Border.all(
                                    color: Theme.of(context).disabledColor),
                              ),
                              child: (context.read<HomeBloc>().showImagePick)
                                  ? _productImagePickerView(size, context)
                                  : Column(
                                      children: [
                                        SizedBox(height: size.width * 0.05),
                                        SizedBox(
                                            width: size.width * 0.8,
                                            child: MyText(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .enterOtp,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color:
                                                          AppColors.blackText,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                              textAlign: TextAlign.center,
                                            )),
                                        SizedBox(height: size.width * 0.05),
                                        SizedBox(
                                            width: size.width * 0.8,
                                            child: MyText(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .enterRideOtpDesc,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color:
                                                          AppColors.blackText,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400),
                                              maxLines: 4,
                                            )),
                                        SizedBox(height: size.width * 0.05),
                                        _pinCodeView(context, size),
                                      ],
                                    ),
                            ),
                            if (userData!.onTripRequest != null &&
                                userData!.onTripRequest!.isTripStart == 0 &&
                                userData!.onTripRequest!.transportType ==
                                    'delivery' &&
                                userData!.onTripRequest!.enableShipmentLoad ==
                                    '1' &&
                                context.read<HomeBloc>().showOtp) ...[
                              _deliveryRideView(context, size),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: size.width * 0.05),
                      _bottomActionView(context, size),
                      SizedBox(height: 16)
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Column _productImagePickerView(
    Size size,
    BuildContext context,
  ) {
    return Column(
      children: [
        SizedBox(
            width: size.width * 0.8,
            child: MyText(
              text: AppLocalizations.of(context)!.uploadShipmentProof,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.blackText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            )),
        SizedBox(
          height: size.width * 0.05,
        ),

        // Loading & unloading Image
        InkWell(
          onTap: () {
            context.read<HomeBloc>().add(ImageCaptureEvent());
          },
          child: SizedBox(
            height: size.width * 0.35,
            width: size.width * 0.35,
            child: DottedBorder(
                color: AppColors.white.withOpacity(0.5),
                strokeWidth: 1,
                dashPattern: const [6, 3],
                borderType: BorderType.RRect,
                radius: const Radius.circular(5),
                child: (context.read<HomeBloc>().loadImage == null &&
                        context.read<HomeBloc>().unloadImage == null)
                    ? SizedBox(
                        height: size.width * 0.35,
                        width: size.width * 0.35,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.upload,
                              size: size.width * 0.05,
                              color: AppColors.black,
                            ),
                            SizedBox(
                              height: size.width * 0.025,
                            ),
                            MyText(
                              text: AppLocalizations.of(context)!.dropImageHere,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: AppColors.white.withOpacity(0.5),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: size.width * 0.025,
                            ),
                            MyText(
                              text: AppLocalizations.of(context)!
                                  .supportedImage
                                  .toString()
                                  .replaceAll('1111', 'jpg,png'),
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: AppColors.white.withOpacity(0.5),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      )
                    : Container(
                        height: size.width * 0.35,
                        width: size.width * 0.35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: (userData?.onTripRequest == null ||
                                  userData!.onTripRequest!.isTripStart == 0)
                              ? (context.read<HomeBloc>().loadImage != null
                                  ? DecorationImage(
                                      image: FileImage(File(
                                          context.read<HomeBloc>().loadImage!)),
                                      fit: BoxFit.cover)
                                  : null)
                              : (context.read<HomeBloc>().unloadImage != null
                                  ? DecorationImage(
                                      image: FileImage(File(context
                                          .read<HomeBloc>()
                                          .unloadImage!)),
                                      fit: BoxFit.cover)
                                  : null),
                        ),
                      )),
          ),
        ),
        SizedBox(
          height: size.width * 0.05,
        )
      ],
    );
  }
  
  Widget _bottomActionView(BuildContext context, Size size) {
  return Padding(
    padding: EdgeInsets.only(bottom: size.width * 0.1),
    child: CustomButton(
        width: size.width * 0.8,
        buttonName: AppLocalizations.of(context)!.continueText,
        onTap: () {
          // context.read<HomeBloc>().currentLatLng= currentLatLng;
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (currentFocus.hasFocus) {
            currentFocus.unfocus();
          }
          if (userData!.onTripRequest != null &&
              userData!.onTripRequest!.isTripStart == 0) {
            if (context.read<HomeBloc>().rideOtp.text.isNotEmpty ||
                context.read<HomeBloc>().showOtp == false) {
              if (userData!.onTripRequest!.transportType == 'delivery' &&
                  userData!.onTripRequest!.enableShipmentLoad == '1') {
                if (context.read<HomeBloc>().showImagePick == false) {
                  context.read<HomeBloc>().add(ShowImagePickEvent());
                } else {
                  if (userData!.onTripRequest == null ||
                      userData!.onTripRequest!.isTripStart == 0) {
                    if (context.read<HomeBloc>().loadImage != null) {
                      if (userData!.onTripRequest == null) {
                        context.read<HomeBloc>().add(CreateInstantRideEvent());
                      } else {
                        context.read<HomeBloc>().add(UploadProofEvent(
                            image: context.read<HomeBloc>().loadImage!,
                            isBefore: false,
                            id: userData!.onTripRequest!.id));
                      }
                    }
                  } else {
                    if (context.read<HomeBloc>().unloadImage != null) {
                      Navigator.pop(context);
                      context.read<HomeBloc>().add(UploadProofEvent(
                          image: context.read<HomeBloc>().unloadImage!,
                          isBefore: false,
                          id: userData!.onTripRequest!.id));
                    }
                  }
                }
              } else {
                context.read<HomeBloc>().add(RideStartEvent(
                    requestId: userData!.onTripRequest!.id,
                    otp: context.read<HomeBloc>().rideOtp.text,
                    pickLat: userData!.onTripRequest!.pickLat,
                    pickLng: userData!.onTripRequest!.pickLng));
                context.read<HomeBloc>().rideOtp.clear();    
              }
            } else {
              showToast(message: AppLocalizations.of(context)!.enterOTPText);
            }
          } else {
            if (context.read<HomeBloc>().unloadImage != null) {
              context.read<HomeBloc>().add(UploadProofEvent(
                  image: context.read<HomeBloc>().unloadImage!,
                  isBefore: false,
                  id: userData!.onTripRequest!.id));
            }
          }
        }),
  );
}

Widget _pinCodeView(BuildContext context, Size size) {
  return SizedBox(
    width: size.width * 0.7,
    child: PinCodeTextField(
      appContext: (context),
      length: 4,
      controller: context.read<HomeBloc>().rideOtp,
      textStyle: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).disabledColor),
      obscureText: false,
      blinkWhenObscuring: false,
      animationType: AnimationType.none,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(12),
        fieldHeight: size.width * 0.13,
        fieldWidth: size.width * 0.12,
        activeFillColor: Theme.of(context).scaffoldBackgroundColor,
        inactiveFillColor: Theme.of(context).scaffoldBackgroundColor,
        inactiveColor: Theme.of(context).disabledColor,
        selectedFillColor: Theme.of(context).scaffoldBackgroundColor,
        selectedColor: Theme.of(context).primaryColor,
        selectedBorderWidth: 1,
        inactiveBorderWidth: 1,
        activeBorderWidth: 1,
        activeColor: Theme.of(context).disabledColor,
      ),
      cursorColor: Theme.of(context).dividerColor,
      // animationDuration:
      //     const Duration(milliseconds: 300),
      enableActiveFill: true,
      enablePinAutofill: false,
      autoDisposeControllers: false,
      keyboardType: TextInputType.number,
      boxShadows: const [
        BoxShadow(
          offset: Offset(0, 1),
          color: Colors.black12,
          blurRadius: 10,
        )
      ],
      onChanged: (_) => context.read<HomeBloc>().add(UpdateEvent()),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    ),
  );
}

Widget _deliveryRideView(BuildContext context, Size size) {
  return Column(
    children: [
      SizedBox(
        height: size.width * 0.05,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (context.read<HomeBloc>().showImagePick == false)
                    ? AppColors.primary
                    : Theme.of(context).disabledColor),
          ),
          SizedBox(
            width: size.width * 0.015,
          ),
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (context.read<HomeBloc>().showImagePick)
                    ? AppColors.primary
                    : Theme.of(context).disabledColor),
          )
        ],
      )
    ],
  );
}

}


