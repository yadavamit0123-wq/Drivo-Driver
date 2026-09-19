import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_tagxi/l10n/app_localizations.dart';
import '../../../../../../core/model/user_detail_model.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../core/utils/custom_snack_bar.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../core/utils/custom_textfield.dart';
import '../../../../application/home_bloc.dart';
import '../../home_page/page/home_page.dart';

class ReviewPage extends StatefulWidget {
  static const String routeName = '/reviewPage';
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  void initState() {
    context.read<HomeBloc>().add(ReviewPageInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  final HomeBloc = context.read<HomeBloc>();
    final size = MediaQuery.of(context).size;
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) async {
        if (state is AddReviewSuccessState) {
          Navigator.pushNamedAndRemoveUntil(
              context, HomePage.routeName, (route) => false);
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            // appBar: CustomAppBar(title: AppLocalizations.of(context)!.ratings),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    /// TOP TITLE
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        AppLocalizations.of(context)!.ratings,
                        style: const TextStyle(
                          fontSize: 24, // bigger font
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(size.width * 0.02),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).shadowColor,
                                    blurRadius: 3, // Increase blur
                                    spreadRadius: 0.5, // Spread evenly
                                    offset: const Offset(
                                        0, 0), // Center shadow (all sides)
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  /// Ride Title
                                  /// First line
                                  MyText(
                                    text: AppLocalizations.of(context)!
                                        .howWasYourLastRide
                                        .toString()
                                        .replaceAll('1111',
                                            userData!.onTripRequest!.userName),
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),

                                  SizedBox(height: size.width * 0.04),

                                  /// Ride ID pill
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .dividerColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: MyText(
                                      text: userData!
                                          .onTripRequest!.requestNumber,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ),

                                  SizedBox(height: size.width * 0.05),

                                  /// Driver + Vehicle Row
                                  IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        /// DRIVER SIDE
                                        Row(
                                          children: [
                                            /// Avatar
                                            Container(
                                              height: size.width * 0.15,
                                              width: size.width * 0.15,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(35),
                                              ),
                                              child: (userData!.onTripRequest!
                                                      .userImage.isEmpty)
                                                  ? const Icon(
                                                      Icons.person,
                                                      size: 50,
                                                    )
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              35),
                                                      child: CachedNetworkImage(
                                                        imageUrl: userData!
                                                            .onTripRequest!
                                                            .userImage,
                                                        height:
                                                            size.width * 0.15,
                                                        fit: BoxFit.fill,
                                                        placeholder:
                                                            (context, url) =>
                                                                const Center(
                                                          child: Loader(),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Center(
                                                          child: Text(""),
                                                        ),
                                                      ),
                                                    ),
                                            ),

                                            const SizedBox(width: 12),

                                            /// Name + Role
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    MyText(
                                                      text: userData!
                                                          .onTripRequest!
                                                          .userName,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textStyle: Theme.of(
                                                              context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    const Icon(
                                                      Icons.verified,
                                                      size: 14,
                                                      color: Colors.green,
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: size.width * 0.01),
                                                MyText(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .verified
                                                      .replaceAll(
                                                          '111',
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .user),
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: size.width * 0.05),

                          MyText(
                            text: AppLocalizations.of(context)!.giveRatings,
                            textStyle:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),

                          SizedBox(height: size.width * 0.025),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              5,
                              (index) {
                                final selectedIndex = context
                                    .read<HomeBloc>()
                                    .selectedRatingsIndex;

                                return InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  onTap: () {
                                    context.read<HomeBloc>().add(
                                          BookingRatingsSelectEvent(
                                            selectedIndex: index + 1,
                                          ),
                                        );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Icon(
                                      (index + 1 <= selectedIndex &&
                                              selectedIndex != 0)
                                          ? Icons.star_rounded
                                          : Icons.star_rounded,
                                      color: (index + 1 <= selectedIndex &&
                                              selectedIndex != 0)
                                          ? const Color(
                                              0xFFFFC107) // nice golden
                                          : Colors.grey.shade300,
                                      size: 42, // bigger like screenshot
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: size.width * 0.025),

                          Builder(
                            builder: (_) {
                              final rating =
                                  context.read<HomeBloc>().selectedRatingsIndex;

                              String ratingText = "";

                              switch (rating) {
                                case 1:
                                  ratingText =
                                      AppLocalizations.of(context)!.veryBad;
                                  break;
                                case 2:
                                  ratingText =
                                      AppLocalizations.of(context)!.bad;
                                  break;
                                case 3:
                                  ratingText =
                                      AppLocalizations.of(context)!.good;
                                  break;
                                case 4:
                                  ratingText =
                                      AppLocalizations.of(context)!.veryGood;
                                  break;
                                case 5:
                                  ratingText =
                                      AppLocalizations.of(context)!.great;
                                  break;
                              }

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  /// LEFT LINE
                                  Container(
                                    width: size.width * 0.225,
                                    height: size.width * 0.005,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.1),
                                          Theme.of(context).primaryColor,
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  /// TEXT
                                  Text(
                                    ratingText,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),

                                  SizedBox(width: size.width * 0.025),

                                  /// RIGHT LINE
                                  Container(
                                    width: size.width * 0.225,
                                    height: size.width * 0.005,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).primaryColor,
                                          Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.1),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          SizedBox(height: size.width * 0.05),

                          /// CARD CONTAINER
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).shadowColor,
                                    blurRadius: 3, // Increase blur
                                    spreadRadius: 0.5, // Spread evenly
                                    offset: const Offset(
                                        0, 0), // Center shadow (all sides)
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  /// TITLE
                                  Text(
                                    AppLocalizations.of(context)!
                                        .leaveFeedbackText,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                  ),

                                  SizedBox(height: size.width * 0.025),

                                  /// TEXT FIELD
                                  CustomTextField(
                                    controller: context
                                        .read<HomeBloc>()
                                        .reviewController,
                                    filled: true,
                                    maxLine: 5,
                                    hintText: AppLocalizations.of(context)!
                                        .leaveFeedback,
                                    borderRadius: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: size.width * 0.05),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: GestureDetector(
                                onTap: () {
                                  context.read<HomeBloc>().driverTips = 0.0;
                                  if (context
                                          .read<HomeBloc>()
                                          .selectedRatingsIndex >
                                      0) {
                                    context
                                        .read<HomeBloc>()
                                        .add(UploadReviewEvent());
                                  } else {
                                    showToast(
                                        message: AppLocalizations.of(context)!
                                            .giveRatingsError);
                                  }
                                },
                                child: Container(
                                  height:
                                      size.width * 0.125, // increased height
                                  width: size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Theme.of(context)
                                            .primaryColor
                                            .withOpacity(1),
                                        Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.9),
                                        Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.7),
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.submit,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: size.width * 0.03),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
