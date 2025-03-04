import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/common/app_constants.dart';
import 'package:restart_tagxi/core/model/user_detail_model.dart';
import 'package:restart_tagxi/core/utils/custom_text.dart';
import 'package:restart_tagxi/features/account/application/acc_bloc.dart';
import 'package:restart_tagxi/features/account/presentation/pages/admin_chat/page/admin_chat.dart';
import 'package:restart_tagxi/features/account/presentation/pages/company_info/page/company_information_page.dart';
import 'package:restart_tagxi/features/account/presentation/pages/complaint/page/complaint_list.dart';
import 'package:restart_tagxi/features/account/presentation/pages/driver_report/pages/reports_page.dart';
import 'package:restart_tagxi/features/account/presentation/pages/levelup/page/driver_levels_page.dart';
import 'package:restart_tagxi/features/account/presentation/pages/rewards/page/rewards_page.dart';
import 'package:restart_tagxi/features/account/presentation/pages/fleet_driver/page/fleet_drivers_page.dart';
import 'package:restart_tagxi/features/account/presentation/pages/profile/page/profile_info_page.dart';
import 'package:restart_tagxi/features/account/presentation/pages/history/page/history_page.dart';
import 'package:restart_tagxi/features/account/presentation/pages/incentive/page/incentive_page.dart';
import 'package:restart_tagxi/features/account/presentation/pages/dashboard/page/owner_dashboard.dart';
import 'package:restart_tagxi/features/account/presentation/pages/refferal/page/referral_page.dart';
import 'package:restart_tagxi/features/account/presentation/pages/settings/page/settings_page.dart';
import 'package:restart_tagxi/features/account/presentation/pages/sos/page/sos_page.dart';
import 'package:restart_tagxi/features/account/presentation/pages/subscription/page/subscription_page.dart';
import 'package:restart_tagxi/features/account/presentation/pages/vehicle_info/page/vehicle_data_page.dart';
import 'package:restart_tagxi/features/account/presentation/pages/wallet/page/wallet_page.dart';
import 'package:restart_tagxi/features/account/presentation/widgets/page_options.dart';
import 'package:restart_tagxi/features/account/presentation/pages/profile/widget/profile_design.dart';
import 'package:restart_tagxi/features/driverprofile/presentation/pages/driver_profile_pages.dart';
import 'package:restart_tagxi/features/language/presentation/page/choose_language_page.dart';
import '../../../../common/app_arguments.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../l10n/app_localizations.dart';
import 'notification/page/notification_page.dart';

class AccountPage extends StatelessWidget {
  static const String routeName = '/accountPage';
  final AccountPageArguments arg;

  const AccountPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()..add(AccGetDirectionEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is AccInitialState) {
            CustomLoader.loader(context);
          }
          if (state is UserDetailState) {
            Navigator.pushNamed(
              context,
              ProfileInfoPage.routeName,
            ).then(
              (value) {
                if (!context.mounted) return;
                context.read<AccBloc>().add(AccGetUserDetailsEvent());
              },
            );
          }
        },
        child: BlocBuilder<AccBloc, AccState>(buildWhen: (previous, current) {
          // Avoid rebuild if the state has not changed meaningfully
          return previous.runtimeType != current.runtimeType;
        }, builder: (context, state) {
          return (userData != null)
              ? Scaffold(
                  body: ProfileWidget(
                    isEditPage: false,
                    ratings: userData!.rating,
                    trips: userData!.totalRidesTaken!,
                    profileUrl: userData!.profilePicture,
                    userName: userData!.name,
                    todaysEarnings:
                        '${userData!.currencySymbol}${userData!.totalEarnings!}',
                    wallet: userData!.showWalletFeatureOnMobileApp == '1'
                        ? '${userData!.currencySymbol}${userData!.wallet?.data.amountBalance ?? 0.0}'
                        : '',
                    showWallet: userData!.showWalletFeatureOnMobileApp == '1',
                    child: SizedBox(
                      // height: size.height * 0.7 - size.width * 0.2,
                      height: size.height * 0.65,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              userData!.role == 'driver'
                                  ? SizedBox(height: size.width * 0.2)
                                  : SizedBox(
                                      height: size.width * 0.15,
                                    ),
                              MyText(
                                  text: AppLocalizations.of(context)!.myAccount,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontSize:
                                              AppConstants().subHeaderSize)),
                              PageOptions(
                                  list: AppLocalizations.of(context)!
                                      .personalInformation,
                                  icon: Icons.person,
                                  onTap: () {
                                    Navigator.pushNamed(
                                            context, ProfileInfoPage.routeName,
                                            arguments: arg)
                                        .then((value) {
                                      if (!context.mounted) return;
                                      context
                                          .read<AccBloc>()
                                          .add(UpdateEvent());
                                    });
                                  }),
                              if (userData!.role == 'owner')
                                PageOptions(
                                    list: AppLocalizations.of(context)!
                                        .companyInfo,
                                    icon: Icons.info,
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          CompanyInformationPage.routeName,
                                          arguments: arg);
                                    }),
                              if (userData!.role != 'owner')
                                PageOptions(
                                  list: AppLocalizations.of(context)!
                                      .notifications,
                                  icon: Icons.notifications,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, NotificationPage.routeName);
                                  },
                                ),
                              PageOptions(
                                list: AppLocalizations.of(context)!.history,
                                icon: Icons.history,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, HistoryPage.routeName,
                                      arguments: HistoryAccountPageArguments(
                                          isFrom: 'account'));
                                },
                              ),
                              PageOptions(
                                icon: Icons.taxi_alert_outlined,
                                list: userData!.role != 'owner'
                                    ? AppLocalizations.of(context)!.vehicleInfo
                                    : AppLocalizations.of(context)!.manageFleet,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    VehicleDataPage.routeName,
                                    arguments: VehicleDataArguments(from: 0),
                                  );
                                },
                              ),
                              if (userData!.role == 'owner')
                                PageOptions(
                                  icon: Icons.drive_eta,
                                  list: AppLocalizations.of(context)!.drivers,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, FleetDriversPage.routeName);
                                  },
                                ),
                              PageOptions(
                                icon: Icons.folder,
                                list: AppLocalizations.of(context)!.documents,
                                onTap: () {
                                  Navigator.pushNamed(
                                          context, DriverProfilePage.routeName,
                                          arguments: VehicleUpdateArguments(
                                              from: 'docs'))
                                      .then(
                                    (value) {
                                      if (!context.mounted) return;
                                      context
                                          .read<AccBloc>()
                                          .add(UpdateEvent());
                                    },
                                  );
                                },
                              ),
                              if (userData!.role == 'owner')
                                PageOptions(
                                  icon: Icons.dashboard,
                                  list: AppLocalizations.of(context)!.dashboard,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      OwnerDashboard.routeName,
                                      arguments:
                                          OwnerDashboardArguments(from: ''),
                                    );
                                  },
                                ),
                              if (userData!.showWalletFeatureOnMobileApp == '1')
                                PageOptions(
                                  icon: Icons.payment,
                                  list: AppLocalizations.of(context)!.payment,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, WalletHistoryPage.routeName);
                                  },
                                ),
                              if (userData!.role == 'driver')
                                PageOptions(
                                  icon: Icons.share,
                                  list: AppLocalizations.of(context)!
                                      .referAndEarn,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      ReferralPage.routeName,
                                      arguments: ReferralArguments(
                                          title: AppLocalizations.of(context)!
                                              .referAndEarn,
                                          userData: arg.userData),
                                    );
                                  },
                                ),
                              PageOptions(
                                icon: Icons.language,
                                list: AppLocalizations.of(context)!
                                    .changeLanguage,
                                onTap: () {
                                  Navigator.pushNamed(
                                          context, ChooseLanguagePage.routeName,
                                          arguments:
                                              ChangeLanguageArguments(from: 1))
                                      .then(
                                    (value) {
                                      if (!context.mounted) return;
                                      context
                                          .read<AccBloc>()
                                          .add(AccGetDirectionEvent());
                                    },
                                  );
                                },
                              ),
                              if (userData!.role == 'driver')
                                PageOptions(
                                  icon: Icons.sos,
                                  list: AppLocalizations.of(context)!.sosText,
                                  onTap: () {
                                    Navigator.pushNamed(
                                            context, SosPage.routeName,
                                            arguments: SOSPageArguments(
                                                sosData: userData!.sos!.data))
                                        .then(
                                      (value) {
                                        if (!context.mounted) return;
                                        if (value != null) {
                                          final sos = value as List<SOSDatum>;
                                          context.read<AccBloc>().sosdata = sos;
                                          userData!.sos!.data =
                                              context.read<AccBloc>().sosdata;
                                          context
                                              .read<AccBloc>()
                                              .add(UpdateEvent());
                                        }
                                      },
                                    );
                                  },
                                ),
                              if (userData!.role == 'driver' &&
                                  userData!.hasSubscription! &&
                                  (userData!.driverMode == 'subscription' ||
                                      userData!.driverMode == 'both'))
                                PageOptions(
                                  icon: Icons.subscriptions,
                                  list: AppLocalizations.of(context)!
                                      .subscription,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      SubscriptionPage.routeName,
                                      arguments: SubscriptionPageArguments(
                                          isFromAccPage: true),
                                    ).then((value) {
                                      if (!context.mounted) return;
                                      context
                                          .read<AccBloc>()
                                          .add(UpdateEvent());
                                    });
                                  },
                                ),
                              if (userData!.role == 'driver' &&
                                  userData!.showIncentiveFeatureForDriver ==
                                      "1" &&
                                  userData!.availableIncentive != null)
                                PageOptions(
                                  icon: Icons.celebration,
                                  list:
                                      AppLocalizations.of(context)!.incentives,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      IncentivePage.routeName,
                                    );
                                  },
                                ),
                              if (userData!.role == 'driver' &&
                                  userData!.showDriverLevel == true)
                                PageOptions(
                                  icon: Icons.leaderboard,
                                  list:
                                      AppLocalizations.of(context)!.levelupText,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      DriverLevelsPage.routeName,
                                    );
                                  },
                                ),
                              if (userData!.role == 'driver' &&
                                  userData!.showDriverLevel == true)
                                PageOptions(
                                  icon: Icons.receipt_long,
                                  list:
                                      AppLocalizations.of(context)!.rewardsText,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      RewardsPage.routeName,
                                    );
                                  },
                                ),
                              PageOptions(
                                icon: Icons.report,
                                list: AppLocalizations.of(context)!.reportsText,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, ReportsPage.routeName);
                                },
                              ),
                              const SizedBox(height: 20),
                              MyText(
                                text: AppLocalizations.of(context)!.general,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        fontSize: AppConstants().subHeaderSize),
                              ),
                              PageOptions(
                                icon: Icons.chat,
                                list: AppLocalizations.of(context)!.chatWithUs,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AdminChat.routeName);
                                },
                              ),
                              PageOptions(
                                icon: Icons.help,
                                list:
                                    AppLocalizations.of(context)!.makeComplaint,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, ComplaintListPage.routeName,
                                      arguments: ComplaintListPageArguments(
                                          choosenHistoryId: ''));
                                },
                              ),
                              PageOptions(
                                icon: Icons.settings,
                                list: AppLocalizations.of(context)!.settings,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, SettingsPage.routeName);
                                },
                              ),
                              SizedBox(height: size.width * 0.25)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const Scaffold(
                  body: Loader(),
                );
        }),
      ),
    );
  }
}
