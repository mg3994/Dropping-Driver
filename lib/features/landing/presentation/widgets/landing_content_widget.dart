import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/core/utils/custom_card.dart';

import '../../../../core/utils/custom_text.dart';
import '../../application/onboarding_bloc.dart';

class LandingContentWidget extends StatelessWidget {
  final BuildContext cont;
  const LandingContentWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<OnBoardingBloc>(),
      child: BlocBuilder<OnBoardingBloc, OnBoardingState>(
        builder: (context, state) {
          return Column(
            children: [
              
              CustomCard(
                padding: EdgeInsets.symmetric(horizontal: 6,vertical: 2),
                child: SizedBox(
                  height: size.height * 0.2,
                  width: size.width,
                  child: PageView.builder(
                    controller:
                        context.read<OnBoardingBloc>().contentPageController,
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount:
                        context.read<OnBoardingBloc>().onBoardingData.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MyText(
                            text: context
                                .read<OnBoardingBloc>()
                                .onBoardingData[index]
                                .title
                                .toUpperCase(),
                            textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                              DottedLine( // ADDED: BY MG: Dotted line
                         dashLength: 2,
                          dashGapLength: 2,
                          dashRadius: 1,
                          lineThickness: 1,
                          dashColor: Theme.of(context).dividerColor,
                        ),
                          SizedBox(height: size.height * 0.02),
                          MyText(
                            text: context
                                .read<OnBoardingBloc>()
                                .onBoardingData[index]
                                .description,
                            textStyle: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).textTheme.labelSmall?.color?.withAlpha(100)),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                          ),
                        ],
                      );
                    },
                    onPageChanged: (value) {
                      context
                          .read<OnBoardingBloc>()
                          .imagePageController
                          .jumpToPage(value);
                      context
                          .read<OnBoardingBloc>()
                          .add(OnBoardingDataChangeEvent(currentIndex: value));
                    },
                  ),
                ),
              ),
              SizedBox(height: 6,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  context.read<OnBoardingBloc>().onBoardingData.length,
                  (index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 5),
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context
                                      .read<OnBoardingBloc>()
                                      .onBoardChangeIndex ==
                                  index
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).splashColor),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
