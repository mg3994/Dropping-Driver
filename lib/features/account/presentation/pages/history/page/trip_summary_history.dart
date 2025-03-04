// ignore_for_file: deprecated_member_use

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:restart_tagxi/core/utils/custom_button.dart";
import "package:restart_tagxi/features/account/presentation/pages/complaint/page/complaint_list.dart";
import "../../../../../../common/app_arguments.dart";
import "../../../../../../common/app_colors.dart";
import "../../../../../../core/utils/custom_dialoges.dart";
import "../../../../../../core/utils/custom_loader.dart";
import "../../../../../../core/utils/custom_slider/custom_sliderbutton.dart";
import "../../../../../../core/utils/custom_text.dart";
import "../../../../../../l10n/app_localizations.dart";
import "../../../../../home/presentation/pages/home_page/page/home_page.dart";
import "../../../../application/acc_bloc.dart";

import "../widget/cancel_ride_widget.dart";
import "../widget/trip_earnings_widget.dart";
import "../widget/trip_farebreakup_widget.dart";
import "../widget/trip_map_widget.dart";
import "../widget/trip_user_details_widget.dart";
import "../widget/trip_vehicle_info_widget.dart";

class HistoryTripSummaryPage extends StatelessWidget {
  static const String routeName = '/historytripsummary';
  final HistoryPageArguments arg;

  const HistoryTripSummaryPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(AddHistoryMarkerEvent(
            stops: arg.historyData.requestStops,
            pickLat: arg.historyData.pickLat,
            pickLng: arg.historyData.pickLng,
            dropLat: arg.historyData.dropLat,
            dropLng: arg.historyData.dropLng,
            polyline: arg.historyData.polyLine))
        ..add(ComplaintEvent(complaintType: 'request')),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is AccInitialState) {
            CustomLoader.loader(context);
          } else if (state is AccDataLoadingStartState) {
            CustomLoader.loader(context);
          } else if (state is AccDataLoadingStopState) {
            CustomLoader.dismiss(context);
          } else if (state is HistoryTypeChangeState) {
            String filter;
            switch (state.selectedHistoryType) {
              case 0:
                filter = 'is_completed=1';
                break;
              case 1:
                filter = 'is_later=1';
                break;
              case 2:
                filter = 'is_cancelled=1';
                break;
              default:
                filter = '';
            }
            context.read<AccBloc>().add(HistoryGetEvent(historyFilter: filter));
          } else if (state is RequestCancelState) {
            Navigator.pop(context);
            Navigator.pop(context);
          } else if (state is OutstationReadyToPickupState) {
            Navigator.pushNamed(context, HomePage.routeName,
                arguments: HomePageArguments(isFromHistory: true));
          } else if (state is ShowErrorState) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext ctx) {
                return CustomSingleButtonDialoge(
                  title: AppLocalizations.of(context)!.cancel,
                  content: AppLocalizations.of(context)!.userCancelledRide,
                  btnName: AppLocalizations.of(context)!.ok,
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  },
                );
              },
            );
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          if (Theme.of(context).brightness == Brightness.dark) {
            if (context.read<AccBloc>().googleMapController != null) {
              context
                  .read<AccBloc>()
                  .googleMapController!
                  .setMapStyle(context.read<AccBloc>().darkMapString);
            }
          } else {
            if (context.read<AccBloc>().googleMapController != null) {
              context
                  .read<AccBloc>()
                  .googleMapController!
                  .setMapStyle(context.read<AccBloc>().lightMapString);
            }
          }
          return Scaffold(
            backgroundColor: const Color(0xffDEDCDC),
            body: Stack(
              children: [
                SizedBox(
                  height: size.height,
                  width: size.width,
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                          stretch: false,
                          expandedHeight: size.width * 0.7,
                          pinned: true,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          leading: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: AppColors.black,
                              )),
                          flexibleSpace: LayoutBuilder(builder:
                              (BuildContext context,
                                  BoxConstraints constraints) {
                            var top = constraints.biggest.height;
                            return FlexibleSpaceBar(
                              title: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 300),
                                  opacity: top > 71 && top < 91 ? 1.0 : 0.0,
                                  child: Text(
                                    top > 71 && top < 91
                                        ? AppLocalizations.of(context)!
                                            .tripDetails
                                        : "",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                              background: TripMapWidget(cont:context,arg:arg));
                          })),
                      SliverList(
                          delegate: SliverChildBuilderDelegate(childCount: 1,
                              (context, index) {
                        return Container(
                          padding: EdgeInsets.all(size.width * 0.03),
                          width: size.width,
                          color: const Color(0xffDEDCDC),
                          child: Column(
                            children: [
                              TripFarebreakupWidget(cont:context,arg:arg),
                              SizedBox(height: size.width * 0.02),

                              if (arg.historyData.requestBill != null)
                                TripEarningsWidget(cont: context,arg: arg),
                              SizedBox(height: size.width * 0.02),

                              TripUserDetailsWidget(cont: context,arg: arg),
                              SizedBox(height: size.height * 0.01),
                              
                              TripVehicleInfoWidget(cont: context,arg: arg),
                              SizedBox(height: size.width * 0.02),
                              Container(
                                  padding: EdgeInsets.all(size.width * 0.05),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MyText(
                                            text: AppLocalizations.of(context)!
                                                .tripId,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .disabledColor,
                                                    fontSize: 14),
                                          ),
                                          MyText(
                                            text: arg.historyData.requestNumber,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              SizedBox(height: size.width * 0.4),
                            ],
                          ),
                        );
                      })),
                    ],
                  ),
                ),
                if (arg.historyData.isCancelled != 1)
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: (arg.historyData.isCompleted == 1)
                          ? Column(
                              children: [
                                const SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                        offset: Offset(0, -2),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                                Icons.report_gmailerrorred,
                                                size: 20,
                                                color: AppColors.red),
                                            SizedBox(width: size.width * 0.01),
                                            MyText(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .reportIssue,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: AppColors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13)),
                                          ],
                                        ),
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              ComplaintListPage.routeName,
                                              arguments:
                                                  ComplaintListPageArguments(
                                                      choosenHistoryId: arg
                                                          .historyData.id
                                                          .toString()));
                                        }),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      if (arg.historyData.isLater == true &&
                                          arg.historyData.isCancelled == 0 &&
                                          arg.historyData.isOutStation == 0)
                                        CustomButton(
                                            width: size.width * 0.9,
                                            height: size.width * 0.12,
                                            buttonName:
                                                AppLocalizations.of(context)!
                                                    .cancel,
                                            borderRadius: 20,
                                            onTap: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: false,
                                                  enableDrag: false,
                                                  isDismissible: true,
                                                  builder: (_) {
                                                    return CancelRideWidget(
                                                        cont: context,
                                                        requestId:
                                                            arg.historyData.id);
                                                  });
                                            }),
                                      SizedBox(height: size.width * 0.02),
                                      if (arg.historyData.isLater == true &&
                                          arg.historyData.isCancelled == 0)
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: CustomSliderButton(
                                            sliderIcon: Icon(
                                              Icons
                                                  .keyboard_double_arrow_right_rounded,
                                              color: AppColors.white,
                                              size: size.width * 0.07,
                                            ),
                                            width: size.width * 0.8,
                                            buttonName:
                                                AppLocalizations.of(context)!
                                                    .readyToPickup,
                                            onSlideSuccess: () async {
                                              context.read<AccBloc>().add(
                                                  OutstationReadyToPickupEvent(
                                                      requestId:
                                                          arg.historyData.id));
                                              return true;
                                            },
                                          ),
                                        )
                                    ],
                                  )),
                            ))
              ],
            ),
          );
        }),
      ),
    );
  }
}
