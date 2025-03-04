import 'dart:io';
import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../../../core/model/user_detail_model.dart';
import '../../../../../../../core/utils/custom_button.dart';
import '../../../../../../../core/utils/custom_snack_bar.dart';
import '../../../../../../../core/utils/custom_text.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../account/presentation/widgets/top_bar.dart';
import '../../../../../application/home_bloc.dart';
import 'signature_painter_widget.dart';

class SignatureGetWidget extends StatelessWidget {
  final BuildContext cont;
  const SignatureGetWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<HomeBloc>(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Container(
            height: size.height,
            width: size.width,
            color: Colors.transparent.withOpacity(0.4),
            child: TopBarDesign(
              isHistoryPage: false,
              isOngoingPage: false,
              title: AppLocalizations.of(context)!.getUserSignature,
              onTap: () {
                context.read<HomeBloc>().add(ShowSignatureEvent());
              },
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: size.width * 0.1),
                          SizedBox(
                            width: size.width * 0.8,
                            child: MyText(
                              text: AppLocalizations.of(context)!.drawSignature,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: size.width * 0.05),
                          Stack(
                            children: [
                              SizedBox(
                                width: size.width * 0.8,
                                height: size.width * 0.8,
                                child: DottedBorder(
                                    color: Theme.of(context).primaryColorDark,
                                    strokeWidth: 1,
                                    dashPattern: const [6, 3],
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(5),
                                    child: Container()),
                              ),
                              Positioned(
                                top: 0,
                                child: SizedBox(
                                  width: size.width * 0.8,
                                  height: size.width * 0.8,
                                  child: RepaintBoundary(
                                    key: context
                                              .read<HomeBloc>()
                                              .screenshotImage,
                                    child: CustomPaint(
                                      painter: SignaturePainterWidget(
                                          pointlist: context
                                              .read<HomeBloc>()
                                              .signaturePoints,
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                child: GestureDetector(
                                  onTapDown: (val) {
                                    final box =
                                        context.findRenderObject() as RenderBox;
                                    final point =
                                        box.globalToLocal(val.globalPosition);
                                    context
                                        .read<HomeBloc>()
                                        .add(UpdateSignEvent(points: {
                                          'point': Offset(
                                              point.dx - size.width * 0.15,
                                              point.dy -
                                                  (((size.height -
                                                          size.width * 1.65)) /
                                                      2) -
                                                  size.width * 0.425),
                                          'action': 'dot to'
                                        }));
                                  },
                                  onTapUp: (val) {
                                    final box =
                                        context.findRenderObject() as RenderBox;
                                    final point =
                                        box.globalToLocal(val.globalPosition);

                                    context
                                        .read<HomeBloc>()
                                        .add(UpdateSignEvent(points: {
                                          'point': Offset(
                                              point.dx - size.width * 0.15,
                                              point.dy -
                                                  (((size.height -
                                                          size.width * 1.65)) /
                                                      2) -
                                                  size.width * 0.425),
                                          'action': 'setstate'
                                        }));
                                  },
                                  onPanStart: (val) {
                                    final box =
                                        context.findRenderObject() as RenderBox;
                                    final point =
                                        box.globalToLocal(val.globalPosition);

                                    context
                                        .read<HomeBloc>()
                                        .add(UpdateSignEvent(points: {
                                          'point': Offset(
                                              point.dx - size.width * 0.15,
                                              point.dy -
                                                  (((size.height -
                                                          size.width * 1.65)) /
                                                      2) -
                                                  size.width * 0.425),
                                          'action': 'move to'
                                        }));
                                  },
                                  onPanUpdate: (val) {
                                    final box =
                                        context.findRenderObject() as RenderBox;
                                    final point =
                                        box.globalToLocal(val.globalPosition);
                                    if (point.dx < size.width * 0.85 &&
                                        point.dx > size.width * 0.15 &&
                                        point.dy >
                                            (((size.height -
                                                        size.width * 1.65)) /
                                                    2) +
                                                size.width * 0.425 &&
                                        point.dy <
                                            (((size.height -
                                                        size.width * 1.65)) /
                                                    2) +
                                                size.width * 1.125) {
                                      context
                                          .read<HomeBloc>()
                                          .add(UpdateSignEvent(points: {
                                            'point': Offset(
                                                point.dx - size.width * 0.15,
                                                point.dy -
                                                    (((size.height -
                                                            size.width *
                                                                1.65)) /
                                                        2) -
                                                    size.width * 0.425),
                                            'action': 'line to'
                                          }));
                                    }
                                  },
                                  onPanEnd: (val) {
                                    context.read<HomeBloc>().add(
                                            UpdateSignEvent(points: {
                                          'point': 'point',
                                          'action': 'setstate'
                                        }));
                                  },
                                  child: Container(
                                    width: size.width * 0.8,
                                    height: size.width * 0.8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      CustomButton(
                          width: size.width * 0.7,
                          buttonName:
                              AppLocalizations.of(context)!.confirmSignature,
                          onTap: () async {
                            if (context
                                .read<HomeBloc>()
                                .signaturePoints
                                .isNotEmpty) {
                              RenderRepaintBoundary boundary = context
                                              .read<HomeBloc>()
                                              .screenshotImage
                                  .currentContext!
                                  .findRenderObject() as RenderRepaintBoundary;
                              var image = await boundary.toImage(pixelRatio: 2);
                              var file = await image.toByteData(
                                  format: ImageByteFormat.png);
                              var uintImage = file!.buffer.asUint8List();
                              Directory paths = await getTemporaryDirectory();
                              var path = paths.path;
                              var name = DateTime.now();
                              var signatureImage = File('$path/$name.png');

                              signatureImage.writeAsBytesSync(uintImage);
                              if (!context.mounted) return;
                              context.read<HomeBloc>().signatureImage =
                                  signatureImage.path;
                              context.read<HomeBloc>().add(UploadProofEvent(
                                  image:
                                      context.read<HomeBloc>().signatureImage!,
                                  isBefore: false,
                                  id: userData!.onTripRequest!.id));
                            } else {
                              showToast(
                                  message: AppLocalizations.of(context)!
                                      .getSignatureError);
                            }
                          }),
                      SizedBox(
                        height: size.width * 0.05,
                      ),
                      CustomButton(
                          width: size.width * 0.7,
                          buttonName:
                              AppLocalizations.of(context)!.clearSignature,
                          onTap: () {
                            context
                                .read<HomeBloc>()
                                .add(UpdateSignEvent(points: null));
                          }),
                      SizedBox(
                        height: size.width * 0.05,
                      ),
                    ],
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
