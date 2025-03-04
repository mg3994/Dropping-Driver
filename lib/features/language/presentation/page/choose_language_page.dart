import 'package:flutter/material.dart';
import 'package:restart_tagxi/app/localization.dart';
import '../../../../common/app_constants.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_text.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../loading/presentation/loader.dart';
import '../../application/language_bloc.dart';
import '../widget/language_list_widget.dart';

class ChooseLanguagePage extends StatelessWidget {
  static const String routeName = '/chooseLanguage';
  final ChangeLanguageArguments? args;

  const ChooseLanguagePage({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return builderList(size);
  }

  Widget builderList(Size size) {
    return BlocProvider(
      create: (context) => LanguageBloc()
        ..add(LanguageInitialEvent())
        ..add(LanguageGetEvent(from: args != null ? args!.from : 0)),
      child: BlocListener<LanguageBloc, LanguageState>(
        listener: (context, state) {
          if (state is LanguageInitialState) {
            CustomLoader.loader(context);
          } else if (state is LanguageLoadingState) {
            CustomLoader.loader(context);
          } else if (state is LanguageSuccessState) {
            CustomLoader.dismiss(context);
          } else if (state is LanguageFailureState) {
            CustomLoader.dismiss(context);
          } else if (state is LanguageAlreadySelectedState) {
            context.read<LocalizationBloc>().add(LocalizationInitialEvent(
                isDark: Theme.of(context).brightness == Brightness.dark,
                locale: Locale(context.read<LanguageBloc>().choosedLanguage)));
            if (args == null || args!.from == 0) {
              Navigator.pushNamedAndRemoveUntil(
                  context, LoaderPage.routeName, (route) => false);
            }
          } else if (state is LanguageUpdateState) {
            if (args == null || args!.from == 0) {
              Navigator.pushNamedAndRemoveUntil(
                  context, LoaderPage.routeName, (route) => false);
            } else {
              Navigator.pop(context);
            }
          }
        },
        child: BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            return PopScope(
              canPop: (args != null && args!.from == 1) ? true : false,
              child: Scaffold(
                body: (context
                            .read<LanguageBloc>()
                            .choosedLanguage
                            .isNotEmpty &&
                        (args == null))
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppImages.loader,
                              width: size.width * 0.51,
                              height: size.height * 0.51,
                            )
                          ],
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(AppImages.bg),
                            // Path to your image
                            fit: BoxFit.cover, // Adjust the image fit as needed
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: size.width * 0.05 +
                                      MediaQuery.of(context).padding.top),
                              Row(
                                children: [
                                  if (args != null && args!.from == 1)
                                    Row(
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                              context
                                                  .read<LocalizationBloc>()
                                                  .add(LocalizationInitialEvent(
                                                      isDark: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark,
                                                      locale: Locale(context
                                                          .read<LanguageBloc>()
                                                          .choosedLanguage)));
                                            },
                                            child: Icon(
                                              Icons.arrow_back,
                                              size: size.width * 0.07,
                                              color: AppColors.black,
                                            )),
                                        SizedBox(width: size.width * 0.05)
                                      ],
                                    ),
                                  MyText(
                                      text: (args != null && args!.from == 1)
                                          ? AppLocalizations.of(context)!
                                              .changeLanguage
                                          : AppLocalizations.of(context)!
                                              .chooseLanguage,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              color: AppColors.blackText,
                                              fontSize: 18)),
                                ],
                              ),
                              SizedBox(height: size.width * 0.02),
                              LanguageListWidget(
                                  languageList: AppConstants.languageList,
                                  cont: context),
                              SizedBox(height: size.width * 0.05),
                              Center(
                                child: CustomButton(
                                  buttonName:
                                      AppLocalizations.of(context)!.select,
                                  height: size.width * 0.15,
                                  width: size.width * 0.85,
                                  onTap: () async {
                                    final selectedIndex = context
                                        .read<LanguageBloc>()
                                        .selectedIndex;
                                    context.read<LanguageBloc>().add(
                                        LanguageSelectUpdateEvent(
                                            selectedLanguage: AppConstants
                                                .languageList
                                                .elementAt(selectedIndex)
                                                .lang));
                                  },
                                ),
                              ),
                              // ],
                            ],
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
