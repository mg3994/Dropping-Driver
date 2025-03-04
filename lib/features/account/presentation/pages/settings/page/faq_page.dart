import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/features/account/application/acc_bloc.dart';
import 'package:restart_tagxi/features/account/presentation/widgets/top_bar.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';

import '../widget/faq_list_widget.dart';

class FaqPage extends StatelessWidget {
  static const String routeName = '/faqPage';

  const FaqPage({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()..add(GetFaqListEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {},
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Scaffold(
            body: TopBarDesign(
              onTap: () {
                Navigator.pop(context);
              },
              isHistoryPage: false,
              title: AppLocalizations.of(context)!.faq,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FaqDataListWidget(
                        faqDataList: context.read<AccBloc>().faqDataList,cont: context),
                    SizedBox(height: size.width * 0.05),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

}
