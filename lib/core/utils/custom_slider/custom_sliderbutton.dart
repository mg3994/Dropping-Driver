import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/common.dart';
import '../custom_loader.dart';
import 'custom_slider_bloc.dart';

class CustomSliderButton extends StatelessWidget {
  final String buttonName;
  final double? height;
  final double? width;
  final Color? buttonColor;
  final Color? textColor;
  final double? textSize;
  final Future<bool?> Function() onSlideSuccess;
  final bool? isLoader;
  final Widget? sliderIcon;

  const CustomSliderButton({
    super.key,
    required this.buttonName,
    this.height,
    this.width,
    this.buttonColor,
    this.textColor,
    this.textSize,
    required this.onSlideSuccess,
    this.isLoader = false,
    this.sliderIcon,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SliderButtonBloc(),
      child: Builder(
        builder: (context) {
          final size = MediaQuery.sizeOf(context);
          final buttonHeight = height ?? size.width * 0.13;
          final buttonWidth = width ?? size.width * 0.75;

          return GestureDetector(
            onHorizontalDragStart: (details) {
              // Save the initial position of the drag
              context.read<SliderButtonBloc>().add(
                    SliderDragStartEvent(0.0),
                  );
            },
            onHorizontalDragUpdate: (details) {
              // Update slider position while dragging
              context.read<SliderButtonBloc>().add(
                    SliderDragEvent(
                      (details.localPosition.dx)
                          .clamp(0.0, buttonWidth - (buttonHeight / 2)),
                    ),
                  );
            },
            onHorizontalDragEnd: (details) async {
              context.read<SliderButtonBloc>().add(
                    SliderDragEndEvent(
                      (details.localPosition.dx)
                          .clamp(0.0, buttonWidth - (buttonHeight / 2)),
                      onSlideSuccess,
                    ),
                  );
            },
            child: SizedBox(
              height: buttonHeight,
              width: buttonWidth,
              child: Stack(
                children: [
                  BlocBuilder<SliderButtonBloc, SliderButtonState>(
                    builder: (context, state) {
                      return AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0.1),
                            ],
                            stops: const [0.5, 0.5, 1.5],
                            begin: Alignment(-1.0, 0),
                            end: Alignment(1.0, 0),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            color: buttonColor ?? Theme.of(context).primaryColor,
                          ),
                        ),
                      );
                    },
                  ),
                  Center(
                    child: BlocBuilder<SliderButtonBloc, SliderButtonState>(
                      builder: (context, state) {
                        return Shimmer.fromColors(
                          baseColor:
                              textColor?.withOpacity(0.6) ?? AppColors.white,
                          highlightColor:
                              textColor ?? AppColors.grey.withOpacity(0.6),
                          child: Text(
                            state.isSliding ? '' : buttonName,
                            style: AppTextStyle.boldStyle().copyWith(
                              color: textColor ?? AppColors.white,
                              fontSize: textSize ?? 18,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  BlocBuilder<SliderButtonBloc, SliderButtonState>(
                    builder: (context, state) {
                      return Positioned(
                        left: (state.sliderPosition <= buttonWidth - buttonHeight)
                            ? state.sliderPosition
                            : buttonWidth - buttonHeight,
                        child: Container(
                          height: buttonHeight,
                          width: buttonHeight, // Square sliding button
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.white),
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.grey.withOpacity(0.5),
                                AppColors.grey,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              stops: const [0.0, 1.0],
                            ),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 4,
                                color: Colors.black26,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          child: state.isSliding
                              ? Center(
                                  child: SizedBox(
                                    height: size.width * 0.05,
                                    width: size.width * 0.05,
                                    child: const Loader(
                                      color: AppColors.white,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 400),
                                    child: sliderIcon ??
                                        Shimmer.fromColors(
                                          baseColor: AppColors.primary
                                              .withOpacity(0.6),
                                          highlightColor: AppColors.primary,
                                          child: Icon(
                                            Icons
                                                .keyboard_double_arrow_right_rounded,
                                            color: AppColors.white,
                                            size: size.width * 0.07,
                                          ),
                                        ),
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

