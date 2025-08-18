import 'package:go_router/go_router.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

import '../../../../core/helpers/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/product_info_tile.dart';

class SelectField<T> extends HookWidget {
  const SelectField({
    super.key,
    required this.value,
    required this.title,
    required this.options,
    required this.infoTitle,
    required this.selectedOption,
    required this.onSelected,
    this.onInfoTap,
  });

  final T value;
  final String title;
  final List<T> options;
  final String infoTitle;
  final T selectedOption;
  final void Function(T selectedOption) onSelected;
  final VoidCallback? onInfoTap;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = useTextEditingController(
      text: value.toString(),
    );
    final themeColors = context.color;

    useEffect(() {
      controller.text = value.toString();
      return null;
    }, <Object?>[value]);

    return TextFormField(
      controller: controller,
      onTap: () async {
        await _displaySheet(context);
      },

      enableInteractiveSelection: false,
      style: AppStyles.font14BlackMedium(context),
      readOnly: true,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        suffixIcon: const Icon(Icons.keyboard_arrow_down_outlined),
        filled: true,
        isDense: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: themeColors.primary, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: themeColors.secondary.withValues(alpha: .4),
          ),
        ),
      ),
    );
  }

  Future<void> _displaySheet(BuildContext context) async {
    final themeColors = context.color;

    await Navigator.of(context).push(
      ModalSheetRoute(
        builder:
            (context) => Sheet(
              initialOffset: const SheetOffset(0.9),
              physics: const BouncingSheetPhysics(),
              snapGrid: const MultiSnapGrid(
                snaps: [SheetOffset(0.6), SheetOffset(0.9), SheetOffset(1.0)],
              ),
              child: SafeArea(
                top: false,
                child: Material(
                  color: themeColors.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: constraints.maxHeight * 0.96,
                        ),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                            16,
                            12,
                            16,
                            MediaQuery.viewInsetsOf(context).bottom + 24,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 36,
                                height: 4,
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: themeColors.secondary.withValues(
                                    alpha: 0.25,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),

                              Text(
                                title,
                                style: AppStyles.font18BlackSemiBold(context),
                              ),
                              const SizedBox(height: 22),

                              if (options.isNotEmpty)
                                Wrap(
                                  runSpacing: 16,
                                  spacing: 22.w,
                                  children:
                                      options.map((option) {
                                        final isSelected =
                                            option == selectedOption;
                                        return Material(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            splashColor: themeColors.primary
                                                .withValues(alpha: 0.08),
                                            onTap: () {
                                              onSelected(option);
                                              context.pop();
                                            },
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 220,
                                              ),
                                              curve: Curves.easeInOutCubic,
                                              height:
                                                  40, // 40.h if using ScreenUtil
                                              width:
                                                  100, // 100.w if using ScreenUtil
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color:
                                                      isSelected
                                                          ? themeColors.primary
                                                          : themeColors
                                                              .secondary
                                                              .withValues(
                                                                alpha: 0.5,
                                                              ),
                                                  width: isSelected ? 1.5 : 1,
                                                ),
                                                color:
                                                    isSelected
                                                        ? themeColors.primary
                                                            .withValues(
                                                              alpha: 0.06,
                                                            )
                                                        : null,
                                              ),
                                              child: Center(
                                                child: FittedBox(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 4.w,
                                                        ),
                                                    child: Text(
                                                      option.toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          AppStyles.font14BlackMedium(
                                                            context,
                                                          ).copyWith(
                                                            height: 1.2,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),

                              const SizedBox(height: 24),
                              ProductInfoTile(
                                title: infoTitle,
                                onTap: onInfoTap,
                              ),

                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
      ),
    );
  }

  // Future<dynamic> _displaySheet(BuildContext context) {
  //   final themeColors = context.color;
  //   return showModalBottomSheet(
  //     isDismissible: true,
  //     showDragHandle: true,
  //     sheetAnimationStyle: const AnimationStyle(
  //       curve: Curves.easeInOutCubic,
  //       duration: Duration(milliseconds: 350),
  //       reverseDuration: Duration(milliseconds: 300),
  //     ),

  //     backgroundColor: themeColors.surface,
  //     context: context,
  //     builder:
  //         (context) => Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text(title, style: AppStyles.font18BlackSemiBold(context)),
  //             const SizedBox(height: 22),
  //             if (options.isNotEmpty)
  //               Wrap(
  //                 runSpacing: 16,
  //                 spacing: 22.w,
  //                 children:
  //                     options
  //                         .map(
  //                           (option) => InkWell(
  //                             borderRadius: BorderRadius.circular(8),
  //                             splashColor: themeColors.primary.withValues(
  //                               alpha: 0.1,
  //                             ),
  //                             onTap: () {
  //                               onSelected(option);
  //                               context.pop();
  //                             },
  //                             child: AnimatedContainer(
  //                               duration: const Duration(milliseconds: 300),

  //                               height: 40.h,
  //                               width: 100.w,
  //                               decoration: BoxDecoration(
  //                                 shape: BoxShape.rectangle,
  //                                 border: Border.all(
  //                                   color:
  //                                       option == selectedOption
  //                                           ? themeColors.primary
  //                                           : themeColors.secondary.withValues(
  //                                             alpha: 0.5,
  //                                           ),
  //                                   width: 1,
  //                                 ),
  //                                 borderRadius: BorderRadius.circular(8),
  //                               ),
  //                               child: Center(
  //                                 child: FittedBox(
  //                                   child: Text(
  //                                     textAlign: TextAlign.center,
  //                                     option.toString(),
  //                                     style: AppStyles.font14BlackMedium(
  //                                       context,
  //                                     ).copyWith(height: 1.2),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         )
  //                         .toList(),
  //               ),
  //             const SizedBox(height: 24),
  //             ProductInfoTile(title: infoTitle, onTap: onInfoTap),
  //             const SizedBox(height: 24),
  //           ],
  //         ),
  //   );
  // }
}
