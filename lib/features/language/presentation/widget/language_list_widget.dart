import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_text.dart';
import '../../application/language_bloc.dart';
import '../../domain/models/language_listing_model.dart';

class LanguageListWidget extends StatelessWidget {
  final BuildContext cont;
  final List<LocaleLanguageList> languageList;
  const LanguageListWidget({super.key, required this.cont, required this.languageList});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(value: cont.read<LanguageBloc>(),
    child: BlocBuilder<LanguageBloc,LanguageState>(builder: (context, state) {
      return SizedBox(
            height: size.height * 0.7,
            child: RawScrollbar(
              radius: const Radius.circular(20),
              child: ListView.builder(
                itemCount: languageList.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8),
                    child: InkWell(
                      onTap: () {
                        context.read<LanguageBloc>().add(
                            LanguageSelectEvent(selectedLanguageIndex: index));
                        context.read<LocalizationBloc>().add(
                            LocalizationInitialEvent(
                              isDark: Theme.of(context).brightness ==
                                    Brightness.dark,
                                locale: Locale(languageList[index].lang)));
                      },
                      child: Container(
                        height: 50,
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color:
                                  (context.read<LanguageBloc>().selectedIndex ==
                                          index)
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).dialogBackgroundColor,
                              width:
                                  (context.read<LanguageBloc>().selectedIndex ==
                                          index)
                                      ? 2.0
                                      : 1.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              spacing: 4,
                              children: [
                                CachedNetworkImage(imageUrl: 
                            languageList[index].flag,
                                height: 22,
                                width:35,
                                // placeholder: (context, url) {
                                //   return const Icon(Icons.error);
                                // },
                                errorWidget: (context, url, error) {
                                  return const Icon(Icons.error);
                                },
                                progressIndicatorBuilder: (context, url, progress) {
                                    return Center(
                                    child: SizedBox(
                                      height: 12,
                                      width: 12,
                                      child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                      value: progress.progress,
                                      ),
                                    ),
                                    );
                                },
                              ),
                                MyText(
                                  text: languageList[index].name,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: AppColors.blackText,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ;
    },),);
  }
}