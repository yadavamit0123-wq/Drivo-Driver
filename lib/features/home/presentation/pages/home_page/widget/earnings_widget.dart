import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/model/user_detail_model.dart';
import '../../../../../../core/utils/custom_divider.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/home_bloc.dart';

class EarningsWidget extends StatelessWidget {
  final BuildContext cont;
  const EarningsWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        key: const Key('switcher'),
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Drag Indicator
          Container(
            width: size.width * 0.15,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Theme.of(context)
                  .disabledColor
                  .withAlpha((0.2 * 255).toInt()),
            ),
          ),

          SizedBox(height: size.width * 0.05),

          /// OUTSTATION SECTION (UNCHANGED LOGIC)
          if (context.read<HomeBloc>().outStationList.isNotEmpty) ...[
            InkWell(
              onTap: () {
                context
                    .read<HomeBloc>()
                    .add(ShowoutsationpageEvent(isVisible: true));
              },
              child: Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: AppColors.lightGreen.withAlpha((0.15 * 255).toInt()),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.route,
                            size: 18, color: AppColors.lightGreen),
                        const SizedBox(width: 8),
                        MyText(
                          text: AppLocalizations.of(context)!.outstationRides,
                          textStyle:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: AppColors.lightGreen,
                                  ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        MyText(
                          text: AppLocalizations.of(context)!.textView,
                          textStyle:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_ios, size: 14)
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: size.width * 0.03),
          ],

          /// TODAY'S EARNINGS
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    context.read<HomeBloc>().add(GetUserDetailsEvent());
                  },
                  child: MyText(
                    text: AppLocalizations.of(context)!.todaysEarnings,
                    textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ),
              MyText(
                text: '${userData!.currencySymbol} ${userData!.totalEarnings}',
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark,
                    ),
              )
            ],
          ),

          SizedBox(height: size.width * 0.04),

          const HorizontalDotDividerWidget(),

          SizedBox(height: size.width * 0.06),

          /// STATS SECTION (ICON + VALUE + LABEL)

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// ACTIVE TIME
              Container(
                width: size.width * 0.29,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Icon(Icons.access_time_filled,
                        color: Colors.orange.shade600, size: 22),
                    const SizedBox(height: 8),
                    MyText(
                      // text: userData!.totalMinutesOnline.toString(),
                      text:
                          '${(Duration(minutes: (double.tryParse(userData!.totalMinutesOnline!) ?? 0).toInt()).inHours.toString().padLeft(2, '0'))} : ${((Duration(minutes: (double.tryParse(userData!.totalMinutesOnline!) ?? 0).toInt()).inMinutes % 60).toString().padLeft(2, '0'))} ${(Duration(minutes: (double.tryParse(userData!.totalMinutesOnline!) ?? 0).toInt()).inHours == 0 ? 'min' : 'hr')}',
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    MyText(
                      text: AppLocalizations.of(context)!.active,
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: AppColors.darkGrey,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              /// DISTANCE
              Container(
                width: size.width * 0.29,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Icon(Icons.map_rounded,
                        color: Colors.blue.shade600, size: 22),
                    const SizedBox(height: 8),
                    MyText(
                      text: '${userData!.totalKms} ${userData!.distanceUnit}',
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    MyText(
                      text: AppLocalizations.of(context)!.distance,
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: AppColors.darkGrey,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              /// RIDES TAKEN
              Container(
                width: size.width * 0.29,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Icon(Icons.local_taxi,
                        color: Colors.green.shade600, size: 22),
                    const SizedBox(height: 8),
                    MyText(
                      text: userData!.totalRidesTaken!,
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    MyText(
                      text: AppLocalizations.of(context)!.ridesTaken,
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: AppColors.darkGrey,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
