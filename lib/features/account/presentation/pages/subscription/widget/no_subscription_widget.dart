import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_header.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';

class NoSubscriptionWidget extends StatelessWidget {
  final BuildContext cont;
  final bool isFromAccPage;
  const NoSubscriptionWidget(
      {super.key, required this.cont, required this.isFromAccPage});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<AccBloc>(),
      child: BlocBuilder<AccBloc, AccState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(size.width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomHeader(
                  title: AppLocalizations.of(context)!.subscription,
                  automaticallyImplyLeading: true,
                  titleFontSize: 18,
                ),
                SizedBox(
                  height: size.width * 0.1,
                ),
                Image.asset(
                  AppImages.subcriptionPlan,
                  width: size.width * 0.7,
                ),
                SizedBox(height: size.height * 0.04),
                MyText(
                  text: AppLocalizations.of(context)!.noSubscription,
                  textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).primaryColorDark, fontSize: 20),
                  maxLines: 3,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * 0.03),
                MyText(
                  text: AppLocalizations.of(context)!.noSubscriptionContent,
                  textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 16,
                      ),
                  maxLines: 5,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: size.width * 0.1,
                ),
                CustomButton(
                  width: size.width,
                  buttonName: AppLocalizations.of(context)!.choosePlan,
                  // borderRadius: 20,
                  textSize: 18,
                  onTap: () {
                    context.read<AccBloc>().add(
                          ChoosePlanEvent(isPlansChoosed: true),
                        );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
