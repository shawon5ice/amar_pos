import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/accounting/data/models/manage_journal/journal_list_response_model.dart';
import 'package:amar_pos/features/accounting/presentation/views/manage_journal/manage_journal_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/manage_journal/pages/journal_entry_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/methods/helper_methods.dart';
import '../../../../../../core/widgets/custom_text_field.dart';
import '../../../../../../core/widgets/loading/random_lottie_loader.dart';
import '../../../../../../core/widgets/pager_list_view.dart';
import '../../../../../../core/widgets/reusable/custom_svg_icon_widget.dart';
import '../../../../../../core/widgets/reusable/forbidden_access_full_screen_widget.dart';
import '../../widgets/account_opening_history_item_widget.dart';
import '../../widgets/journal_list_item_widget.dart';

class ManageJournalScreen extends StatefulWidget {
  static const routeName = '/accounting/manage-journal';

  const ManageJournalScreen({super.key});

  @override
  State<ManageJournalScreen> createState() => _ManageJournalScreenState();
}

class _ManageJournalScreenState extends State<ManageJournalScreen> {
  final ManageJournalController controller = Get.find();

  @override
  void initState() {
    controller.getJournalList();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManageJournalController>(
      id: 'permission_handler_builder',
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Manage Journal"),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () async {
                  DateTimeRange? selectedDate = await showDateRangePicker(
                    context: context,
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 1000)),
                    lastDate: DateTime.now().add(const Duration(days: 1000)),
                    initialDateRange: controller.selectedDateTimeRange.value,
                  );
                  controller.selectedDateTimeRange.value = selectedDate;
                  controller.update(['date_status']);
                  controller.getJournalList();
                },
                icon: SvgPicture.asset(AppAssets.calenderIcon),
              )
            ],
          ),
          backgroundColor: const Color(0xFFFAFAF5),
          body: !controller.journalListAccess
              ? const ForbiddenAccessFullScreenWidget()
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      controller.getJournalList();
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                textCon: controller.searchController,
                                hintText: "Search...",
                                brdrClr: Colors.transparent,
                                txtSize: 12,
                                debounceDuration: const Duration(
                                  milliseconds: 500,
                                ),
                                // noInputBorder: true,
                                brdrRadius: 40,
                                prefixWidget: const Icon(Icons.search),
                                onChanged: (value) {
                                  controller.getJournalList();
                                },
                              ),
                            ),
                            addW(8),
                            CustomSvgIconButton(
                              bgColor: const Color(0xffEBFFDF),
                              onTap: () {
                                controller.downloadList(
                                  isPdf: false,
                                );
                              },
                              assetPath: AppAssets.excelIcon,
                            ),
                            addW(4),
                            CustomSvgIconButton(
                              bgColor: const Color(0xffE1F2FF),
                              onTap: () {
                                controller.downloadList(
                                  isPdf: true,
                                );
                              },
                              assetPath: AppAssets.downloadIcon,
                            ),
                            addW(4),
                            CustomSvgIconButton(
                              bgColor: const Color(0xffFFFCF8),
                              onTap: () {
                                controller.downloadList(
                                    isPdf: true, shouldPrint: true);
                              },
                              assetPath: AppAssets.printIcon,
                            )
                          ],
                        ),
                        addH(8),
                        GetBuilder<ManageJournalController>(
                          id: 'date_status',
                          builder: (controller) {
                            if (controller.selectedDateTimeRange.value !=
                                null) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        textAlign: TextAlign.center,
                                        '${formatDate(controller.selectedDateTimeRange.value!.start)} to ${formatDate(controller.selectedDateTimeRange.value!.end)}',
                                        style: const TextStyle(fontSize: 14),
                                        overflow: TextOverflow.visible,
                                        softWrap: false,
                                      ),
                                      ...[
                                        addW(32),
                                        GestureDetector(
                                          onTap: controller
                                                      .selectedDateTimeRange
                                                      .value ==
                                                  null
                                              ? null
                                              : () {
                                                  controller
                                                      .selectedDateTimeRange
                                                      .value = null;
                                                  controller
                                                      .update(['date_status']);
                                                  controller.getJournalList();
                                                },
                                          child: CircleAvatar(
                                              radius: 16,
                                              backgroundColor: controller
                                                          .selectedDateTimeRange
                                                          .value !=
                                                      null
                                                  ? Colors.red
                                                  : Colors.transparent,
                                              child: controller
                                                          .selectedDateTimeRange
                                                          .value !=
                                                      null
                                                  ? Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                      size: 16,
                                                    )
                                                  : null),
                                        ),
                                      ],
                                    ],
                                  ),
                                  addH(8),
                                ],
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                        ),
                        Expanded(
                          child: GetBuilder<ManageJournalController>(
                            id: 'journal_list',
                            builder: (controller) {
                              if (controller.isJournalListLoading) {
                                return Center(
                                  child: RandomLottieLoader.lottieLoader(),
                                );
                              } else if (controller.journalEntryList.isEmpty) {
                                return const Center(
                                    child: Text("No data found"));
                              } else if (controller.journalListResponseModel ==
                                  null) {
                                return const Center(
                                    child: Text("Something went wrong"));
                              }
                              return PagerListView<JournalEntryData>(
                                // scrollController: _scrollController,
                                items: controller.journalEntryList,
                                itemBuilder: (_, item) {
                                  return JournalListItemWidget(
                                    journalEntryData: item,
                                  );
                                },
                                isLoading: controller.isLoadingMore,
                                hasError: controller.hasError.value,
                                onNewLoad: (int nextPage) async {
                                  await controller.getJournalList(
                                      page: nextPage);
                                },
                                totalPage: controller.journalListResponseModel
                                        ?.data?.meta.lastPage ??
                                    0,
                                totalSize: controller.journalListResponseModel
                                        ?.data?.meta.total ??
                                    0,
                                itemPerPage: 10,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          floatingActionButton: !controller.journalCreateAccess
              ? null
              : CustomFloatingActionButton(
                  onTap: () {
                    Get.toNamed(JournalEntryForm.routeName);
                  },
                ),
        );
      },
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton(
      {super.key, required this.onTap, this.buttonTitle = "Create"});

  final Function() onTap;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
            color: AppColors.primary, borderRadius: BorderRadius.circular(50)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add,
              color: Colors.white,
              size: 18,
            ),
            addW(8),
            Text(
              buttonTitle,
              style: TextStyle(color: Colors.white, fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
