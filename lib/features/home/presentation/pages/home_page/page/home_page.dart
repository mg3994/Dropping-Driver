// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:restart_tagxi/common/app_constants.dart';
import 'package:restart_tagxi/core/model/user_detail_model.dart';
import 'package:restart_tagxi/core/utils/custom_button.dart';
import 'package:restart_tagxi/core/utils/custom_loader.dart';
import 'package:restart_tagxi/core/utils/custom_text.dart';
import 'package:restart_tagxi/core/utils/extensions.dart';
import 'package:restart_tagxi/features/auth/presentation/pages/auth_page.dart';
import 'package:restart_tagxi/features/driverprofile/presentation/pages/driver_profile_pages.dart';
import 'package:restart_tagxi/features/home/presentation/pages/invoice_page/page/invoice_page.dart';
import 'package:restart_tagxi/features/home/presentation/pages/home_page/widget/map_widget.dart';
import 'package:restart_tagxi/features/home/presentation/pages/review_page/page/review_page.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../../../core/services/bubble_service.dart';
import '../../../../../account/presentation/pages/account_page.dart';
import '../../../../../account/presentation/pages/earnings/page/earnings_page.dart';
import '../../../../../account/presentation/pages/leaderboard/page/leaderboard_page.dart';
import '../../../../../account/presentation/pages/dashboard/page/owner_dashboard.dart';
import '../../../../application/home_bloc.dart';
import '../../../../../../common/common.dart';
import '../widget/bidding_ride/bidding_timer_widget.dart';
import '../widget/bottom_navigationbar_widget.dart';
import '../widget/on_ride/cancel_reason_widget.dart';
import '../widget/on_ride/chat_page_widget.dart';
import '../widget/instand_ride/instant_ride_details.dart';
import '../widget/my_service_types.dart';
import '../widget/outstation_ride_list_widget.dart';
import '../widget/on_ride/ride_otp_widget.dart';
import '../widget/instand_ride/select_goods_type.dart';
import '../widget/on_ride/show_stops_widget.dart';
import '../widget/show_subscription_widget.dart';
import '../widget/on_ride/signature_get_widget.dart';
import '../widget/on_ride/upload_shipment_proof.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/homePage';
  final HomePageArguments? args;
  const HomePage({super.key, this.args});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (showBubbleIcon && Platform.isAndroid) {
        if (userData != null && userData!.active) {
          HomeBloc().startBubbleHead();
        }
      }
      if (HomeBloc().rideStream != null) {
        HomeBloc().rideStream?.pause();
      }
      if (HomeBloc().rideAddStream != null) {
        HomeBloc().rideAddStream?.pause();
      }
    }
    if (state == AppLifecycleState.resumed) {
      if (showBubbleIcon && Platform.isAndroid) {
        HomeBloc().stopBubbleHead();
      }
      if (HomeBloc().rideStream != null) {
        HomeBloc().rideStream?.resume();
      }
      if (HomeBloc().rideAddStream != null) {
        HomeBloc().rideAddStream?.resume();
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    HomeBloc().rideStream?.cancel();
    HomeBloc().requestStream?.cancel();
    HomeBloc().rideAddStream?.cancel();
    HomeBloc().bidRequestStream?.cancel();
    HomeBloc().googleMapController?.dispose();
    HomeBloc().animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return builderWidget(size);
  }

  Widget builderWidget(Size size) {
    return BlocProvider(
      create: (context) => HomeBloc()
        ..add(GetDirectionEvent(vsync: this))
        ..add(GetUserDetailsEvent()),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) async {
          if (state is HomeDataLoadingStartState) {
            CustomLoader.loader(context);
          } else if (state is HomeDataLoadingStopState) {
            CustomLoader.dismiss(context);
          } else if (state is UserUnauthenticatedState) {
            final type = await AppSharedPreference.getUserType();
            if (!context.mounted) return;
            Navigator.pushNamedAndRemoveUntil(
                context, AuthPage.routeName, (route) => false,
                arguments: AuthPageArguments(type: type));
          } else if (state is GetLocationPermissionState) {
            showDialog(
              context: context,
              builder: (_) {
                return showGetLocationPermissionDialog(context);
              },
            );
          } else if (state is GetOverlayPermissionState) {
            context.read<HomeBloc>().isOverlayAllowClicked = false;
            showDialog(
              context: context,
              builder: (_) {
                return showGetOverlayPermissionDialog(context);
              },
            ).then(
              (value) async {
                final perm1 = await NativeService().checkPermission();
                if (perm1) {
                  AppSharedPreference.setBubbleSettingStatus(true);
                  showBubbleIcon = true;
                  WakelockPlus.enable();
                }
              },
            );
          } else if (state is ShowChooseStopsState) {
            showModalBottomSheet(
                isDismissible: false,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                isScrollControlled: true,
                context: context,
                builder: (builder) {
                  return BlocProvider.value(
                    value: BlocProvider.of<HomeBloc>(context),
                    child: ShowStopsWidgets(),
                  );
                });
          } else if (state is InstantEtaSuccessState) {
            await showModalBottomSheet(
                isDismissible: false,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                isScrollControlled: true,
                context: context,
                builder: (_) {
                  return BlocProvider.value(
                    value: BlocProvider.of<HomeBloc>(context),
                    child: InstantRideDetailsWidget(),
                  );
                });
            if (userData!.onTripRequest == null) {
              if (!context.mounted) return;
              context.read<HomeBloc>().polyline.clear();
              context.read<HomeBloc>().markers.removeWhere(
                  (element) => element.markerId != const MarkerId('my_loc'));
              context.read<HomeBloc>().add(UpdateEvent());
            }
          } else if (state is OutstationSuccessState) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (builder) {
                  return AlertDialog(
                    title: MyText(
                      text: AppLocalizations.of(context)!.success,
                      textStyle: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(fontSize: 16),
                    ),
                    content: MyText(
                      text: AppLocalizations.of(context)!.outStationSuccess,
                      maxLines: 5,
                      textStyle: Theme.of(context).textTheme.bodyMedium!,
                    ),
                    actions: [
                      CustomButton(
                          width: size.width * 0.8,
                          buttonName: AppLocalizations.of(context)!.ok,
                          onTap: () {
                            Navigator.pop(context);
                            context.read<HomeBloc>().add(UpdateEvent());
                          })
                    ],
                  );
                });
          } else if (state is ShowImagePickState &&
              userData!.onTripRequest == null) {
            showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                context: context,
                builder: (builder) {
                  return BlocProvider.value(
                    value: BlocProvider.of<HomeBloc>(context),
                    child: UploadShipmentProofWidget(),
                  );
                });
          } else if (state is GetGoodsSuccessState) {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                isDismissible: false,
                enableDrag: false,
                barrierColor: Theme.of(context).shadowColor,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                builder: (_) {
                  return BlocProvider.value(
                    value: BlocProvider.of<HomeBloc>(context),
                    child: SelectGoodsTypeWidget(),
                  );
                });
          } else if (state is InstantRideSuccessState) {
            if (userData!.onTripRequest!.transportType == 'taxi') {
              Navigator.pop(context);
            } else {
              int count = 0;
              Navigator.popUntil(context, (route) {
                return count++ == 2;
              });
            }
          } else if (state is ShowErrorState) {
            context.showSnackBar(color: AppColors.red, message: state.message);
          } else if (state is ShowSubVehicleTypesState) {
            if (userData!.subVehicleType != null) {
              showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  context: context,
                  builder: (_) {
                    return BlocProvider.value(
                        value: context.read<HomeBloc>(),
                        child: MyServiceTypeWidget());
                  });
            }
          } else if (state is ImageCaptureSuccessState) {
            context.read<HomeBloc>().add(UpdateEvent());
          } else if (state is EnableBiddingSettingsState ||
              state is EnableBubbleSettingsState) {
            context.read<HomeBloc>().add(UpdateEvent());
          } else if (state is RideStartSuccessState) {
            final homeBloc = context.read<HomeBloc>();
            if (homeBloc.showImagePick || homeBloc.showOtp) {
              Navigator.pop(context);
            }
          }

          if (!context.mounted) return;
          if (state is SearchTimerUpdateStatus &&
              context.read<HomeBloc>().timer < 1 &&
              context.read<HomeBloc>().waitingList.isEmpty) {
            context.read<HomeBloc>().searchTimer?.cancel();
            context.read<HomeBloc>().searchTimer = null;
            context.read<HomeBloc>().add(AcceptRejectEvent(
                requestId: userData!.metaRequest!.id, status: 0));
          }

          if (state is VehicleNotUpdatedState) {
            if (context.read<HomeBloc>().vehicleNotUpdated == true &&
                (userData!.role == 'driver' || userData!.role == 'owner') &&
                userData!.approve == false) {
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  DriverProfilePage.routeName,
                  arguments: VehicleUpdateArguments(
                    from: 'rejected',
                  ),
                  (route) => false);
            }
          } else if (state is ShowChatState &&
              context.read<HomeBloc>().showChat) {
            final homeBloc = context.read<HomeBloc>();
            //   context: context,
            //   isDismissible: false,
            //   enableDrag: false,
            //   isScrollControlled: true,
            //   showDragHandle: false,
            //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            //   elevation: 0,
            //   barrierColor: Colors.transparent,
            //   shape: const RoundedRectangleBorder(
            //     borderRadius: BorderRadius.vertical(
            //       top: Radius.circular(20.0),
            //     ),
            //   ),
            //   builder: (_) {
            //     return BlocProvider.value(
            //       value: homeBloc,
            //       child: const ChatPageWidget(),
            //     );
            //   },
            // );
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                          value: homeBloc,
                          child: const ChatPageWidget(),
                        )));
          } else if ((state is ShowOtpState) ||
              ((state is ShowImagePickState) &&
                  userData!.onTripRequest != null) ||
              (state is ShowImagePickState &&
                  userData!.onTripRequest == null)) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => RideOtpWidget(cont: context))).then(
              (value) {
                if (value != null) {
                  userData = value as UserDetail;
                }
                if (!context.mounted) return;
                context.read<HomeBloc>().add(UpdateEvent());
              },
            );
          }

          if (widget.args == null &&
              context.read<HomeBloc>().isSubscriptionShown == false &&
              subscriptionSkip == false &&
              userData != null &&
              userData!.hasSubscription == true &&
              userData!.approve == true &&
              userData!.isSubscribed == false &&
              (userData!.driverMode == 'subscription' ||
                  userData!.driverMode == 'both')) {
            context.read<HomeBloc>().isSubscriptionShown = true;
            showModalBottomSheet(
                constraints: BoxConstraints(
                  maxHeight: size.width * 0.8,
                ),
                isDismissible: false,
                isScrollControlled: false,
                enableDrag: false,
                context: context,
                builder: (_) {
                  return ShowSubscriptionWidget();
                });
          }

          if (context.read<HomeBloc>().isUserCancelled) {
            context.read<HomeBloc>().isUserCancelled = false;
            final homeBloc = context.read<HomeBloc>();
            if (homeBloc.showImagePick || homeBloc.showOtp) {
              Navigator.pop(context);
            }
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (builder) {
                  return showUserCancelledDialog(context, size);
                });
          }

          if (context.read<HomeBloc>().bidDeclined) {
            context.read<HomeBloc>().bidDeclined = false;
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_) {
                  return showUserBidDeclinedDialog(context, size);
                });
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (mapType == 'google_map' &&
                context.read<HomeBloc>().choosenMenu == 0 &&
                (userData != null &&
                    (userData!.onTripRequest == null ||
                        userData!.onTripRequest!.isCompleted == 0))) {
              context.read<HomeBloc>().add(SetMapStyleEvent(context: context));
            }
            return PopScope(
              canPop: true,
              onPopInvoked: (didPop) {
                if (context.read<HomeBloc>().addReview) {
                  context.read<HomeBloc>().add(AddReviewEvent());
                }
              },
              child: SafeArea(
                bottom: true,
                top: false,
                maintainBottomViewPadding: true,
                child: Material(
                  child: Directionality(
                    textDirection:
                        context.read<HomeBloc>().textDirection == 'ltr'
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                    child: Scaffold(
                      body: ((userData == null ||
                              userData!.onTripRequest == null ||
                              userData!.onTripRequest!.isCompleted == 0))
                          ? Stack(
                              children: [
                                (context.read<HomeBloc>().choosenMenu == 0)
                                    ? MapWidget(cont: context)
                                    : (context.read<HomeBloc>().choosenMenu ==
                                            1)
                                        ? (userData!.role == 'driver')
                                            ? const LeaderboardPage()
                                            : OwnerDashboard(
                                                args: OwnerDashboardArguments(
                                                    from: 'home'),
                                              )
                                        : (context
                                                    .read<HomeBloc>()
                                                    .choosenMenu ==
                                                2)
                                            ? const EarningsPage()
                                            : AccountPage(
                                                arg: AccountPageArguments(
                                                    userData: userData!),
                                              ),
                                if (context
                                        .read<HomeBloc>()
                                        .visibleOutStation &&
                                    userData!.active)
                                  Positioned(
                                      child: BiddingOutStationListWidget(
                                          cont: context)),
                                // bidding timer widget
                                if (context
                                        .read<HomeBloc>()
                                        .waitingList
                                        .isNotEmpty &&
                                    !context
                                        .read<HomeBloc>()
                                        .showOutstationWidget)
                                  Positioned(
                                      top: 0,
                                      child: BiddingTimerWidget(cont: context)),
                                if (context.read<HomeBloc>().showCancelReason ==
                                    true)
                                  Positioned(
                                      top: 0,
                                      child: CancelReasonWidget(cont: context)),
                                // Showing signature field
                                if (context.read<HomeBloc>().showSignature ==
                                    true)
                                  Positioned(
                                      top: 0,
                                      child: SignatureGetWidget(cont: context)),
                                // Bottom Bar
                                if (context.read<HomeBloc>().choosenRide ==
                                        null &&
                                    (userData == null ||
                                        userData!.onTripRequest == null &&
                                            userData!.metaRequest == null) &&
                                    context
                                            .read<HomeBloc>()
                                            .showGetDropAddress ==
                                        false)
                                  Positioned(
                                      bottom: 0,
                                      child: BottomNavigationbarWidget(
                                          cont: context)),
                              ],
                            )
                          : (context.read<HomeBloc>().addReview == false &&
                                  userData!.onTripRequest != null &&
                                  userData!.onTripRequest!.requestBill != null)
                              ? InvoicePage(cont: context)
                              : ReviewPage(cont: context),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget showUserBidDeclinedDialog(BuildContext context, Size size) {
  return AlertDialog(
    title: MyText(
      text: AppLocalizations.of(context)!.userDeclinedBid,
      textStyle:
          Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 16),
    ),
    content: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: AppColors.secondary),
      padding: const EdgeInsets.all(10),
      child: MyText(
        text: AppLocalizations.of(context)!.userDeclinedBidDesc,
        maxLines: 5,
        textStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
            ),
      ),
    ),
    actions: [
      CustomButton(
          width: size.width * 0.8,
          buttonName: AppLocalizations.of(context)!.ok,
          onTap: () {
            context.read<HomeBloc>().isUserCancelled = false;
            Navigator.pop(context);
          })
    ],
  );
}

Widget showUserCancelledDialog(BuildContext context, Size size) {
  return AlertDialog(
    title: MyText(
      text: AppLocalizations.of(context)!.userCancelledRide,
      textStyle:
          Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 16),
    ),
    content: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: AppColors.secondary),
      padding: const EdgeInsets.all(10),
      child: MyText(
        text: AppLocalizations.of(context)!.userCancelledDesc,
        maxLines: 5,
        textStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
            ),
      ),
    ),
    actions: [
      CustomButton(
          width: size.width * 0.8,
          buttonName: AppLocalizations.of(context)!.ok,
          onTap: () {
            context.read<HomeBloc>().add(GetUserDetailsEvent());
            context.read<HomeBloc>().isUserCancelled = false;
            Navigator.pop(context);
          })
    ],
  );
}

Widget showGetLocationPermissionDialog(BuildContext context) {
  return AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
            alignment: context.read<HomeBloc>().textDirection == 'rtl'
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.cancel_outlined,
                    color: Theme.of(context).primaryColorDark))),
        MyText(text: AppLocalizations.of(context)!.locationAccess, maxLines: 4),
      ],
    ),
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () async {
              await openAppSettings();
            },
            child: MyText(
                text: AppLocalizations.of(context)!.openSetting,
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w600)),
          ),
          InkWell(
            onTap: () async {
              PermissionStatus status = await Permission.location.status;
              if (status.isGranted || status.isLimited) {
                if (!context.mounted) return;
                Navigator.pop(context);
                context.read<HomeBloc>().add(GetCurrentLocationEvent());
              } else {
                if (!context.mounted) return;
                Navigator.pop(context);
              }
            },
            child: MyText(
                text: AppLocalizations.of(context)!.done,
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      )
    ],
  );
}

Widget showGetOverlayPermissionDialog(BuildContext context) {
  return BlocBuilder<HomeBloc, HomeState>(
    builder: (context, state) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
                alignment: context.read<HomeBloc>().textDirection == 'rtl'
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.cancel_outlined,
                        color: Theme.of(context).primaryColorDark))),
            MyText(
                text: AppLocalizations.of(context)!.overlayPermission,
                maxLines: 4),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () async {
                  Navigator.pop(context);
                },
                child: MyText(
                    text: AppLocalizations.of(context)!.decline,
                    textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.w600)),
              ),
              InkWell(
                onTap: () async {
                  context.read<HomeBloc>().isOverlayAllowClicked = true;
                  context.read<HomeBloc>().add(UpdateEvent());
                  final status = await NativeService().checkPermission();
                  if (!status) {
                    await NativeService().askPermission();
                  } else {
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  }
                },
                child: MyText(
                    text: context.read<HomeBloc>().isOverlayAllowClicked
                        ? AppLocalizations.of(context)!.continueText
                        : AppLocalizations.of(context)!.allow,
                    textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          )
        ],
      );
    },
  );
}
