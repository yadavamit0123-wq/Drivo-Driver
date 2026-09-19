import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/common/app_colors.dart';
import 'package:restart_tagxi/common/app_images.dart';
import 'package:restart_tagxi/common/local_data.dart';
import 'package:restart_tagxi/core/model/user_detail_model.dart';
import 'package:restart_tagxi/core/utils/custom_dialoges.dart';
import 'package:restart_tagxi/core/utils/custom_text.dart';
import 'package:restart_tagxi/features/account/application/acc_bloc.dart';
import 'package:restart_tagxi/features/account/presentation/pages/help/page/help_page.dart';
import 'package:restart_tagxi/features/account/presentation/pages/history/page/history_page.dart';
import 'package:restart_tagxi/features/account/presentation/widgets/menu_options.dart';
import 'package:restart_tagxi/features/auth/presentation/pages/login_page.dart';
import '../../../../common/app_arguments.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../driverprofile/presentation/pages/driver_profile_pages.dart';
import '../../../language/presentation/page/choose_language_page.dart';
import 'dashboard/page/owner_dashboard.dart';
import 'driver_report/pages/reports_page.dart';
import 'earnings/page/earnings_page.dart';
import 'fleet_driver/page/fleet_drivers_page.dart';
import 'incentive/page/incentive_page.dart';
import 'levelup/page/driver_levels_page.dart';
import 'myroute_booking/page/myroute_booking.dart';
import 'notification/page/notification_page.dart';
import 'profile/page/profile_info_page.dart';
import 'refferal/page/referral_page.dart';
import 'rewards/page/rewards_page.dart';
import 'settings/page/settings_page.dart';
import 'sos/page/sos_page.dart';
import 'subscription/page/subscription_page.dart';
import 'vehicle_info/page/vehicle_data_page.dart';
import 'wallet/page/wallet_page.dart';

class AccountPage extends StatelessWidget {
  static const String routeName = '/accountPage';
  final AccountPageArguments arg;

  const AccountPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(AccGetUserDetailsEvent())
        ..add(UserDataInitEvent(userDetails: arg.userData)),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) async {
          if (state is AccInitialState) {
            CustomLoader.loader(context);
          }
          if (state is UserDetailState) {
            Navigator.pushNamed(
              context,
              ProfileInfoPage.routeName,
            ).then((value) {
              if (!context.mounted) return;
              context.read<AccBloc>().add(AccGetUserDetailsEvent());
            });
          }
          if (state is LogoutSuccess || state is LogoutFailureState) {
            await AppSharedPreference.getUserTypeStatus();
            await AppSharedPreference.setLoginStatus(false);
            await AppSharedPreference.setToken('');
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                LoginPage.routeName,
                (route) => false,
              );
            }
            await AppSharedPreference.logoutRemove();
          } else if (state is DeleteAccountSuccess) {
            Navigator.pushNamedAndRemoveUntil(
                context, ChooseLanguagePage.routeName, (route) => false,
                arguments: ChangeLanguageArguments(from: 0));
            await AppSharedPreference.setLoginStatus(false);
            await AppSharedPreference.setToken('');
          } else if (state is DeleteAccountFailureState) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          final accBloc = context.read<AccBloc>();

          return SafeArea(
            child: Directionality(
              textDirection: context.read<AccBloc>().textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                // Use CustomScrollView for Sliver performance
                body: CustomScrollView(
                  slivers: [
                    /// 1. TOP HEADER (Static part converted to Sliver)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                        child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .scaffoldBackgroundColor, // important for shadow visibility
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 16,
                                offset:
                                    const Offset(0, 4), // natural drop shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(size.width * 0.05),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      SizedBox(width: size.width * 0.020),
                                      circleProfile(size, context),
                                      SizedBox(width: size.width * 0.04),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            /// NAME
                                            MyText(
                                              text: userData!.name,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w100,
                                                    decorationThickness: 9,
                                                    color: Theme.of(context)
                                                        .primaryColorDark,
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),

                                            const SizedBox(height: 6),

                                            /// RATING CAPSULE (Only for Driver)
                                            if (userData!.role == "driver")
                                              if (userData!.role == "driver")
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10,
                                                    vertical: 5,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    gradient:
                                                        const LinearGradient(
                                                      colors: [
                                                        Color(
                                                            0xFFFFF8E1), // very soft warm cream
                                                        Color(
                                                            0xFFFFECB3), // soft light gold
                                                      ],
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Icon(
                                                        Icons.star_rounded,
                                                        size: 14,
                                                        color: Color(
                                                            0xFFFFB300), // gold star
                                                      ),
                                                      const SizedBox(width: 4),
                                                      MyText(
                                                        text: userData!.rating,
                                                        textStyle:
                                                            const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              AppColors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, HelpPage.routeName);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.info_outline,
                                          size: size.width * 0.05,
                                          color: AppColors.green),
                                      SizedBox(width: size.width * 0.01),
                                      MyText(
                                        text:
                                            AppLocalizations.of(context)!.help,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontSize: 14,
                                              color: AppColors.green,
                                            ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// 2. SCROLLABLE CONTENT
                    SliverPadding(
                      padding: EdgeInsets.all(size.width * 0.04),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          MyText(
                            text: AppLocalizations.of(context)!.yourAccount,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                          ),
                          SizedBox(height: size.width * 0.03),

                          // --- ACCOUNT SECTION ---
                          MenuSectionCard(children: [
                            MenuOptions(
                              icon: Icons.person_outline,
                              iconColor: Colors.blue.shade500,
                              iconbackground: Colors.blue.shade50,
                              label: AppLocalizations.of(context)!
                                  .personalInformation,
                              subtitle: userData!.mobile,
                              imagePath: AppImages.user,
                              onTap: () {
                                Navigator.pushNamed(
                                        context, ProfileInfoPage.routeName,
                                        arguments: arg)
                                    .then((value) {
                                  if (!context.mounted) return;
                                  context.read<AccBloc>().add(UpdateEvent());
                                });
                              },
                            ),
                            customDivider(context),
                            MenuOptions(
                              icon: Icons.directions_car_outlined,
                              iconColor: Colors.indigo.shade500,
                              iconbackground: Colors.indigo.shade50,
                              label: userData!.role != 'owner'
                                  ? AppLocalizations.of(context)!.myVehicle
                                  : AppLocalizations.of(context)!.manageFleet,
                              imagePath: AppImages.vehicleMakeImage,
                              onTap: () => Navigator.pushNamed(
                                  context, VehicleDataPage.routeName,
                                  arguments: VehicleDataArguments(from: 0)),
                            ),
                            customDivider(context),
                            MenuOptions(
                              //icon: Icons.folder,
                              icon: Icons.description_outlined,
                              iconColor: Colors.teal.shade600,
                              iconbackground: Colors.teal.shade50,
                              label: AppLocalizations.of(context)!.documents,
                              onTap: () {
                                Navigator.pushNamed(
                                        context, DriverProfilePage.routeName,
                                        arguments: VehicleUpdateArguments(
                                            from: 'docs'))
                                    .then((value) {
                                  if (!context.mounted) return;
                                  context.read<AccBloc>().add(UpdateEvent());
                                });
                              },
                            ),
                            customDivider(context),
                            if (userData!.showWalletFeatureOnMobileApp == '1')
                              MenuOptions(
                                icon: Icons.account_balance_wallet_outlined,
                                iconColor: Colors.purple.shade500,
                                iconbackground: Colors.purple.shade50,
                                label: AppLocalizations.of(context)!.wallet,
                                imagePath: AppImages.creditCard,
                                onTap: () => Navigator.pushNamed(
                                    context, WalletHistoryPage.routeName),
                              ),
                            if (userData!.role == 'owner') ...[
                              customDivider(context),
                              MenuOptions(
                                icon: Icons.local_shipping_outlined,
                                iconColor: Colors.deepOrange.shade600,
                                iconbackground: Colors.deepOrange.shade50,
                                label: AppLocalizations.of(context)!.drivers,
                                onTap: () => Navigator.pushNamed(
                                    context, FleetDriversPage.routeName),
                              ),
                              customDivider(context),
                              MenuOptions(
                                // 2. Dashboard
                                icon: Icons.dashboard_outlined,
                                iconColor: Colors.green.shade600,
                                iconbackground: Colors.green.shade50,
                                label: AppLocalizations.of(context)!.dashboard,
                                onTap: () => Navigator.pushNamed(
                                    context, OwnerDashboard.routeName,
                                    arguments:
                                        OwnerDashboardArguments(from: '')),
                              ),
                            ],
                          ]),

                          // --- BENEFITS SECTION ---
                          SizedBox(height: size.width * 0.05),
                          if (userData!.role == 'driver')
                            MyText(
                              text: AppLocalizations.of(context)!.benefits,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                            ),
                          SizedBox(height: size.width * 0.05),
                          if (userData!.role == 'driver')
                            MenuSectionCard(children: [
                              MenuOptions(
                                icon: Icons.attach_money,
                                iconColor: Colors.green.shade600,
                                iconbackground: Colors.green.shade50,
                                label: AppLocalizations.of(context)!.myEarnings,
                                imagePath: AppImages.wallet,
                                onTap: () => Navigator.pushNamed(
                                    context, EarningsPage.routeName,
                                    arguments:
                                        EarningArguments(from: 'dashboard')),
                              ),
                              customDivider(context),
                              MenuOptions(
                                icon: Icons.history,
                                iconColor: Colors.grey.shade600,
                                iconbackground: Colors.grey.shade100,
                                label: AppLocalizations.of(context)!.history,
                                // icon: Icons.history,
                                onTap: () => Navigator.pushNamed(
                                    context, HistoryPage.routeName,
                                    arguments: HistoryAccountPageArguments(
                                      isFrom: 'account',
                                      isSupportTicketEnabled:
                                          userData!.enableSupportTicketFeature,
                                    )),
                              ),
                              customDivider(context),
                              MenuOptions(
                                icon: Icons.bar_chart_outlined,
                                iconColor: Colors.orange.shade600,
                                iconbackground: Colors.orange.shade50,
                                label:
                                    AppLocalizations.of(context)!.reportsText,
                                imagePath: AppImages.fileText,
                                onTap: () => Navigator.pushNamed(
                                    context, ReportsPage.routeName),
                              ),
                              customDivider(context),
                              if (userData!.showDriverLevel == true)
                                MenuOptions(
                                  icon: Icons.card_giftcard,
                                  iconColor: Colors.pink.shade500,
                                  iconbackground: Colors.pink.shade50,
                                  label:
                                      AppLocalizations.of(context)!.rewardsText,
                                  imagePath: AppImages.award,
                                  onTap: () => Navigator.pushNamed(
                                      context, RewardsPage.routeName),
                                ),
                              customDivider(context),
                              if (userData!.showIncentiveFeatureForDriver ==
                                      "1" &&
                                  userData!.availableIncentive != null)
                                MenuOptions(
                                  icon: Icons.workspace_premium_outlined,
                                  iconColor: Colors.deepOrange.shade600,
                                  iconbackground: Colors.deepOrange.shade50,
                                  label:
                                      AppLocalizations.of(context)!.incentives,
                                  imagePath: AppImages.dollarSign,
                                  onTap: () => Navigator.pushNamed(
                                      context, IncentivePage.routeName),
                                ),
                              customDivider(context),
                              if (userData!.showDriverLevel == true)
                                MenuOptions(
                                  icon: Icons.trending_up,
                                  iconColor: Colors.blue.shade600,
                                  iconbackground: Colors.blue.shade50,
                                  label:
                                      AppLocalizations.of(context)!.levelupText,
                                  onTap: () => Navigator.pushNamed(
                                      context, DriverLevelsPage.routeName),
                                ),
                              customDivider(context),
                              MenuOptions(
                                icon: Icons.group_outlined,
                                iconColor: Colors.amber.shade700,
                                iconbackground: Colors.amber.shade50,
                                label:
                                    AppLocalizations.of(context)!.referAndEarn,
                                imagePath: AppImages.share,
                                onTap: () => Navigator.pushNamed(
                                    context, ReferralPage.routeName,
                                    arguments: ReferralArguments(
                                        title: AppLocalizations.of(context)!
                                            .referAndEarn,
                                        userData: arg.userData)),
                              ),
                            ]),

                          // --- PREFERENCES SECTION ---
                          SizedBox(height: size.width * 0.05),
                          MyText(
                            text: AppLocalizations.of(context)!.preferences,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                          ),
                          SizedBox(height: size.width * 0.05),
                          MenuSectionCard(children: [
                            if (userData!.role == 'driver' &&
                                userData!.hasSubscription! &&
                                (userData!.driverMode == 'subscription' ||
                                    userData!.driverMode == 'both'))
                              MenuOptions(
                                icon: Icons.credit_card_outlined,
                                iconColor: Colors.indigo.shade500,
                                iconbackground: Colors.indigo.shade50,
                                label: AppLocalizations.of(context)!
                                    .mySubscription,
                                imagePath: AppImages.giftIcon,
                                onTap: () {
                                  Navigator.pushNamed(
                                          context, SubscriptionPage.routeName,
                                          arguments: SubscriptionPageArguments(
                                              isFromAccPage: true))
                                      .then((value) {
                                    if (!context.mounted) return;
                                    context.read<AccBloc>().add(UpdateEvent());
                                  });
                                },
                              ),
                            customDivider(context),
                            if (userData!.role != 'owner')
                              MenuOptions(
                                icon: Icons.notifications_none,
                                iconColor: Colors.red.shade400,
                                iconbackground: Colors.red.shade50,
                                label:
                                    AppLocalizations.of(context)!.notifications,
                                imagePath: AppImages.bell,
                                onTap: () => Navigator.pushNamed(
                                    context, NotificationPage.routeName),
                              ),
                            customDivider(context),
                            MenuOptions(
                              icon: Icons.language,
                              iconColor: Colors.blue.shade600,
                              iconbackground: Colors.blue.shade50,
                              label: AppLocalizations.of(context)!.languages,
                              imagePath: AppImages.globe,
                              onTap: () {
                                Navigator.pushNamed(
                                        context, ChooseLanguagePage.routeName,
                                        arguments:
                                            ChangeLanguageArguments(from: 1))
                                    .then((value) {
                                  if (!context.mounted) return;
                                  context
                                      .read<AccBloc>()
                                      .add(AccGetDirectionEvent());
                                });
                              },
                            ),
                            if (userData!.role != 'owner' &&
                                userData!.enableMyRouteFeature == '1')
                              customDivider(context),
                            MenuOptions(
                              icon: Icons.location_on_outlined,
                              iconColor: Colors.teal.shade600,
                              iconbackground: Colors.teal.shade50,
                              label:
                                  AppLocalizations.of(context)!.myRouteBooking,
                              showroute: true,
                              showrouteValue:
                                  userData!.enableMyRouteBooking == '1',
                              onTap: () {
                                Navigator.pushNamed(
                                        context, RouteBooking.routeName)
                                    .then((value) {
                                  accBloc.add(AccGetUserDetailsEvent());
                                });
                              },
                            ),
                            customDivider(context),
                            MenuOptions(
                              icon: Icons.support_agent,
                              iconColor: Colors.red.shade600,
                              iconbackground: Colors.red.shade50,
                              label: AppLocalizations.of(context)!.sosText,
                              onTap: () {
                                Navigator.pushNamed(context, SosPage.routeName,
                                        arguments: SOSPageArguments(
                                            sosData: userData!.sos!.data))
                                    .then((value) {
                                  if (!context.mounted || value == null) return;
                                  final sos = value as List<SOSDatum>;
                                  context.read<AccBloc>().sosdata = sos;
                                  userData!.sos!.data = sos;
                                  context.read<AccBloc>().add(UpdateEvent());
                                });
                              },
                            ),
                          ]),

                          // --- SETTINGS SECTION ---
                          SizedBox(height: size.width * 0.05),
                          MyText(
                            text: AppLocalizations.of(context)!.settings,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                          ),
                          SizedBox(height: size.width * 0.05),
                          MenuSectionCard(children: [
                            MenuOptions(
                              icon: Icons.settings_outlined,
                              iconColor: Colors.grey.shade700,
                              iconbackground: Colors.grey.shade200,
                              label: AppLocalizations.of(context)!.settings,
                              imagePath: AppImages.vehicleModelImage,
                              onTap: () => Navigator.pushNamed(
                                  context, SettingsPage.routeName),
                            ),
                            customDivider(context),
                            MenuOptions(
                              icon: Icons.logout,
                              iconColor: Colors.red.shade600,
                              iconbackground: Colors.red.shade50,
                              label: AppLocalizations.of(context)!.logout,
                              imagePath: AppImages.logOut,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext _) {
                                    return BlocProvider.value(
                                      value: BlocProvider.of<AccBloc>(context),
                                      child: CustomDoubleButtonDialoge(
                                        title: AppLocalizations.of(context)!
                                            .comeBackSoon,
                                        content: AppLocalizations.of(context)!
                                            .logoutSure,
                                        noBtnName:
                                            AppLocalizations.of(context)!.no,
                                        yesBtnName:
                                            AppLocalizations.of(context)!.yes,
                                        yesBtnFunc: () {
                                          context
                                              .read<AccBloc>()
                                              .add(LogoutEvent());
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ]),
                          // weeklyEarningsWidget(context, size),

                          // Bottom padding for scrollability
                          SizedBox(height: size.width * 0.1),
                        ]),
                      ),
                    ),
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

// Menu Group Card Widget ---------------------------------------------------
class MenuSectionCard extends StatelessWidget {
  final List<Widget> children;

  const MenuSectionCard({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 4, // Increase blur
            spreadRadius: 0.5, // Spread evenly
            offset: const Offset(0, 0), // Center shadow (all sides)
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

Widget circleProfile(Size size, BuildContext context) {
  return CircleAvatar(
      radius: size.width * 0.09,
      backgroundColor: Theme.of(context).dividerColor,
      backgroundImage: userData!.profilePicture.isNotEmpty
          ? NetworkImage(userData!.profilePicture)
          : null);
}

Widget customDivider(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Divider(
      height: 1,
      thickness: 0.4,
      color: Theme.of(context).dividerColor.withOpacity(0.1),
    ),
  );
}

Widget weeklyEarningsWidget(BuildContext context, Size size) {
  final bloc = context.watch<AccBloc>(); // 👈 FIXED

  final amount = (bloc.earningsList.isNotEmpty)
      ? '${bloc.earningCurrency} ${bloc.earningsList[bloc.choosenEarningsWeeks!].totalAmount}'
      : '';

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Theme.of(context).dividerColor.withOpacity(0.3),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyText(
                text: AppLocalizations.of(context)!.weeklyEarnings,
                textStyle: const TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                  fontWeight: FontWeight.w400,
                ),
              ),
              MyText(
                text: amount,
                textStyle: TextStyle(
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Theme.of(context).dividerColor.withOpacity(0.3),
          ),
        ),
      ],
    ),
  );
}
