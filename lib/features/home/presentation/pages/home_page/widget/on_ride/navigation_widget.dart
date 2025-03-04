import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../../common/common.dart';
import '../../../../../../../core/model/user_detail_model.dart';
import '../../../../../../../core/network/network.dart';
import '../../../../../application/home_bloc.dart';

class NavigationWidget extends StatelessWidget {
  final BuildContext cont;
  const NavigationWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<HomeBloc>(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Row(
            children: [
              if (userData != null &&
                  context.read<HomeBloc>().navigationType == true)
                Container(
                  padding: EdgeInsets.all(size.width * 0.02),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).shadowColor,
                            spreadRadius: 1,
                            blurRadius: 1)
                      ]),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (userData!.onTripRequest!.isTripStart == 0) {
                            context.read<HomeBloc>().add(OpenAnotherFeatureEvent(
                                value:
                                    '${ApiEndpoints.openMap}${userData!.onTripRequest!.pickLat},${userData!.onTripRequest!.pickLng}'));
                          } else {
                            context.read<HomeBloc>().add(OpenAnotherFeatureEvent(
                                value:
                                    '${ApiEndpoints.openMap}${userData!.onTripRequest!.dropLat},${userData!.onTripRequest!.dropLng}'));
                          }
                        },
                        child: SizedBox(
                          width: size.width * 0.07,
                          child: Image.asset(
                            AppImages.googleMaps,
                            height: size.width * 0.07,
                            width: 200,
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.02),
                      InkWell(
                        onTap: () async {
                          var browseUrl = (userData!
                                      .onTripRequest!.isTripStart ==
                                  0)
                              ? 'https://waze.com/ul?ll=${userData!.onTripRequest!.pickLat},${userData!.onTripRequest!.pickLng}&navigate=yes'
                              : 'https://waze.com/ul?ll=${userData!.onTripRequest!.dropLat},${userData!.onTripRequest!.dropLng}&navigate=yes';
                          if (browseUrl.isNotEmpty) {
                            await launchUrl(Uri.parse(browseUrl));
                          } else {
                            throw 'Could not launch $browseUrl';
                          }
                        },
                        child: SizedBox(
                          width: size.width * 0.07,
                          child: Image.asset(
                            AppImages.wazeMap,
                            height: size.width * 0.07,
                            width: 200,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(width: size.width * 0.01),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).shadowColor,
                          spreadRadius: 1,
                          blurRadius: 1)
                    ]),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    if (userData!.enableWazeMap == '1') {
                      context.read<HomeBloc>().add(NavigationTypeEvent());
                    } else {
                      if (userData!.onTripRequest!.isTripStart == 0) {
                        context.read<HomeBloc>().add(OpenAnotherFeatureEvent(
                            value:
                                '${ApiEndpoints.openMap}${userData!.onTripRequest!.pickLat},${userData!.onTripRequest!.pickLng}'));
                      } else {
                        context.read<HomeBloc>().add(OpenAnotherFeatureEvent(
                            value:
                                '${ApiEndpoints.openMap}${userData!.onTripRequest!.dropLat},${userData!.onTripRequest!.dropLng}'));
                      }
                    }
                  },
                  child: Container(
                    height: size.width * 0.1,
                    width: size.width * 0.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: Icon(
                      Icons.near_me_rounded,
                      size: size.width * 0.07,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
