import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/common/app_arguments.dart';
import 'package:restart_tagxi/common/app_colors.dart';
import 'package:restart_tagxi/common/app_images.dart';
import 'package:restart_tagxi/core/utils/custom_background.dart';
import 'package:restart_tagxi/core/utils/custom_button.dart';
import 'package:restart_tagxi/core/utils/custom_snack_bar.dart';
import 'package:restart_tagxi/core/utils/custom_text.dart';
import 'package:restart_tagxi/features/auth/application/auth_bloc.dart';
import 'package:restart_tagxi/features/landing/presentation/page/landing_page.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';

class SelectUserPage extends StatelessWidget {
  static const String routeName = '/selectUserpage';

  const SelectUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => AuthBloc()..add(GetDirectionEvent()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UpdateLoginAsState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              LandingPage.routeName,
              (route) => false,
              arguments: LandingPageArguments(
                type: context.read<AuthBloc>().choosenLoginAs,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return SafeArea(
              top: false,
              bottom: true,
              child: Scaffold(
                body:
                //  CustomBackground(child: 
                Column(
                    children: [
                      Image.asset(
                        AppImages.loginAs,
                        width: size.width,
                        height: size.width,
                        fit: BoxFit.fitWidth,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: size.width * 0.9,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing:4,
                          children: [
                            MyText(
                              text:
                                  '${AppLocalizations.of(context)!.selectAccountType} :',
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                     
                                      fontWeight: FontWeight.bold),
                            ),
                              DottedLine( // ADDED: BY MG: Dotted line
                         dashLength: 2,
                          dashGapLength: 2,
                          dashRadius: 1,
                          lineThickness: 1,
                          dashColor: Theme.of(context).dividerColor,
                        ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Material(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: AppColors.black.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                  onTap: () {
                                    context.read<AuthBloc>().add(
                                        ChooseLoginAsEvent(loginAs: 'driver'));
                                  },
                                  child: Ink(
                                    padding: EdgeInsets.all(size.width * 0.03),
                                    width: size.width * 0.9,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          width: 2,
                                            color: 
                                              (context
                                                    .read<AuthBloc>()
                                                    .choosenLoginAs ==
                                                'driver')?Theme.of(context).primaryColor :Theme.of(context).dividerColor.withOpacity(0.5)),
                                        color: (context
                                                    .read<AuthBloc>()
                                                    .choosenLoginAs ==
                                                'driver')
                                            ? Theme.of(context).primaryColor.withOpacity(0.2)
                                            : Colors.transparent),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            MyText(
                                              text: AppLocalizations.of(context)!
                                                  .driver,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      // color: AppColors.blackText,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                                 DottedLine( // ADDED: BY MG: Dotted line
                         dashLength: 2,
                          dashGapLength: 2,
                          dashRadius: 1,
                          lineThickness: 1,
                          dashColor: Theme.of(context).dividerColor,
                        ),
                                            MyText(
                                              text: AppLocalizations.of(context)!
                                                  .driverSubHeading,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!
                                                  .copyWith(
                                                      // color: AppColors.blackText,
                                                      color: Theme.of(context).textTheme.labelSmall?.color?.withOpacity(0.6),
                                                      fontWeight:
                                                          FontWeight.normal),
                                            ),
                                          ],
                                        )),
                                        const SizedBox(width: 20),
                                        Container(
                                          height: size.width * 0.09,
                                          width: size.width * 0.09,
                                          decoration: BoxDecoration(
                                            border: (context
                                                      .read<AuthBloc>()
                                                      .choosenLoginAs ==
                                                  'driver') ? Border.all(color: Theme.of(context).primaryColor, width: 2) : null,
                                               color: Theme.of(context).cardColor,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  offset: const Offset(0, 1),
                                                  spreadRadius: 2,
                                                  blurRadius: 2,
                                                  color: Theme.of(context)
                                                      .shadowColor,
                                                )
                                              ]),
                                          child: (context
                                                      .read<AuthBloc>()
                                                      .choosenLoginAs ==
                                                  'driver')
                                              ? Icon(
                                                  Icons.done,
                                                  color: Theme.of(context).primaryColor,
                                                  size: size.width * 0.06,
                                                )
                                              : Container(),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Material(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: AppColors.black.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                  onTap: () {
                                    context.read<AuthBloc>().add(
                                        ChooseLoginAsEvent(loginAs: 'owner'));
                                  },
                                  child: Ink(
                                    padding: EdgeInsets.all(size.width * 0.03),
                                    width: size.width * 0.9,
                                    decoration: BoxDecoration(
                                      
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          width: 2,
                                            color:
                                                (context
                                                    .read<AuthBloc>()
                                                    .choosenLoginAs ==
                                                'owner')?Theme.of(context).primaryColor :Theme.of(context).dividerColor.withOpacity(0.5)),
                                        color: (context
                                                    .read<AuthBloc>()
                                                    .choosenLoginAs ==
                                                'owner')
                                            ? Theme.of(context).primaryColor.withOpacity(0.2)
                                            : Colors.transparent),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            MyText(
                                              text: AppLocalizations.of(context)!
                                                  .owner,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: AppColors.blackText,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                              DottedLine( // ADDED: BY MG: Dotted line
                         dashLength: 2,
                          dashGapLength: 2,
                          dashRadius: 1,
                          lineThickness: 1,
                          dashColor: Theme.of(context).dividerColor,
                        ),
                                            MyText(
                                              text: AppLocalizations.of(context)!
                                                  .ownerSubHeading,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!
                                                  .copyWith(
                                                      color: Theme.of(context).textTheme.labelSmall?.color?.withOpacity(0.6),
                                                      fontWeight:
                                                          FontWeight.normal),
                                            ),
                                          ],
                                        )),
                                        const SizedBox(width: 20),
                                        Container(
                                          height: size.width * 0.09,
                                          width: size.width * 0.09,
                                          
                                          decoration: BoxDecoration(
                                             border: (context
                                                    .read<AuthBloc>()
                                                    .choosenLoginAs ==
                                                'owner') ? Border.all(color: Theme.of(context).primaryColor, width: 2) : null,
                                              color: Theme.of(context).cardColor,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  offset: const Offset(0, 1),
                                                  spreadRadius: 2,
                                                  blurRadius: 2,
                                                  color: Theme.of(context)
                                                      .shadowColor,
                                                )
                                              ]),
                                          child: (context
                                                      .read<AuthBloc>()
                                                      .choosenLoginAs ==
                                                  'owner')
                                              ? Icon(
                                                  Icons.done,
                                                  color: Theme.of(context).primaryColor,
                                                  size: size.width * 0.06,
                                                )
                                              : Container(),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                          buttonName:
                              "${AppLocalizations.of(context)!.continueText} ${(context.read<AuthBloc>().choosenLoginAs.isNotEmpty) ? context.read<AuthBloc>().choosenLoginAs == 'driver' ? AppLocalizations.of(context)!.driver : AppLocalizations.of(context)!.owner : ''}",
                          onTap: () {
                            if (context
                                .read<AuthBloc>()
                                .choosenLoginAs
                                .isNotEmpty) {
                              context.read<AuthBloc>().add(UpdateLoginAsEvent(
                                  loginAs:
                                      context.read<AuthBloc>().choosenLoginAs));
                            } else {
                              showToast(
                                  message: AppLocalizations.of(context)!
                                      .pleaseSelectUserTypeText);
                            }
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                // ),
              ),
            );
          },
        ),
      ),
    );
  }
}
