import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/core/utils/custom_appbar.dart';
import 'package:restart_tagxi/features/account/application/acc_bloc.dart';
import 'package:restart_tagxi/features/account/presentation/pages/settings/page/faq_page.dart';
import 'package:restart_tagxi/features/account/presentation/pages/settings/page/map_settings.dart';
import 'package:restart_tagxi/features/language/presentation/page/choose_language_page.dart';
import '../../../../../../common/common.dart';
import '../../../../../../core/model/user_detail_model.dart';
import '../../../../../../core/utils/custom_dialoges.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../widgets/menu_options.dart';
import 'terms_privacy_policy_view_page.dart';

class SettingsPage extends StatelessWidget {
  static const String routeName = '/settingsPage';
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => AccBloc()..add(AccGetDirectionEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) async {
          if (state is DeleteAccountSuccess) {
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
        child: BlocBuilder<AccBloc, AccState>(
          builder: (context, state) {
            return Scaffold(
              appBar: CustomAppBar(
                title: AppLocalizations.of(context)!.settings,
                automaticallyImplyLeading: true,
              ),
              body: CustomScrollView(
                slivers: [
                  SliverGap(size.height * 0.03),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    sliver: SliverSection(
                      child: MenuSectionCard(
                        children: [
                          MenuOptions(
                            icon: Icons.palette_outlined,
                            iconColor: Colors.deepPurple.shade500,
                            iconbackground: Colors.deepPurple.shade50,
                            label: AppLocalizations.of(context)!.theme,
                            showTheme: true,
                            onTap: () {},
                          ),
                          customDivider(context),
                          if (userData!.enableMapAppearanceChange == '1')
                            MenuOptions(
                              icon: Icons.map_outlined,
                              iconColor: Colors.green.shade600,
                              iconbackground: Colors.green.shade50,
                              label:
                                  AppLocalizations.of(context)!.mapAppearance,
                              imagePath: AppImages.mapImage,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  MapSettingsPage.routeName,
                                );
                              },
                            ),
                          customDivider(context),
                          MenuOptions(
                            icon: Icons.help_outline,
                            iconColor: Colors.blue.shade600,
                            iconbackground: Colors.blue.shade50,
                            label: AppLocalizations.of(context)!.faq,
                            imagePath: AppImages.messageSquare,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                FaqPage.routeName,
                              );
                            },
                          ),
                          customDivider(context),
                          MenuOptions(
                            icon: Icons.privacy_tip_outlined,
                            iconColor: Colors.indigo.shade600,
                            iconbackground: Colors.indigo.shade50,
                            label: AppLocalizations.of(context)!.privacy,
                            imagePath: AppImages.shield,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                TermsPrivacyPolicyViewPage.routeName,
                                arguments: TermsAndPrivacyPolicyArguments(
                                    isPrivacyPolicy: true),
                              );
                            },
                          ),
                          customDivider(context),
                          MenuOptions(
                            icon: Icons.delete_outline,
                            iconColor: Colors.red.shade600,
                            iconbackground: Colors.red.shade50,
                            label: AppLocalizations.of(context)!.deleteAccount,
                            imagePath: AppImages.trash,
                            textColor: const Color(0xFFDC3545),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext _) {
                                  return BlocProvider.value(
                                    value: BlocProvider.of<AccBloc>(context),
                                    child: CustomSingleButtonDialoge(
                                      title: userData!.isDeletedAt.isEmpty
                                          ? '${AppLocalizations.of(context)!.deleteAccount} ?'
                                          : AppLocalizations.of(context)!
                                              .deleteAccount,
                                      content: userData!.isDeletedAt.isEmpty
                                          ? AppLocalizations.of(context)!
                                              .deleteText
                                          : userData!.isDeletedAt,
                                      btnName: userData!.isDeletedAt.isEmpty
                                          ? AppLocalizations.of(context)!
                                              .deleteAccount
                                          : AppLocalizations.of(context)!.ok,
                                      btnColor: AppColors.errorLight,
                                      isLoader:
                                          context.read<AccBloc>().isLoading,
                                      onTap: () {
                                        if (userData!.isDeletedAt.isEmpty) {
                                          context
                                              .read<AccBloc>()
                                              .add(DeleteAccountEvent());
                                        } else {
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverGap(30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

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

class SliverSection extends StatelessWidget {
  final Widget child;
  const SliverSection({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: child);
  }
}

class SliverGap extends StatelessWidget {
  final double height;
  const SliverGap(this.height, {super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: SizedBox(height: height));
  }
}
