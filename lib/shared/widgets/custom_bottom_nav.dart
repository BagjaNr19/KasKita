import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/app_user.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final UserRole role;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    List<({IconData icon, String label})> items = [];

    switch (role) {
      case UserRole.admin:
        items = [
          (icon: Icons.home_rounded, label: AppStrings.navHome),
          (icon: Icons.people_alt_rounded, label: AppStrings.navResidents),
          (icon: Icons.account_balance_wallet_rounded, label: AppStrings.navCash),
          (icon: Icons.bar_chart_rounded, label: AppStrings.navReports),
          (icon: Icons.person_rounded, label: AppStrings.navProfile),
        ];
        break;
      case UserRole.bendahara:
        items = [
          (icon: Icons.home_rounded, label: AppStrings.navHome),
          (icon: Icons.receipt_long_rounded, label: AppStrings.navTransactions),
          (icon: Icons.request_quote_rounded, label: AppStrings.navBilling),
          (icon: Icons.bar_chart_rounded, label: AppStrings.navReports),
          (icon: Icons.person_rounded, label: AppStrings.navProfile),
        ];
        break;
      case UserRole.warga:
        items = [
          (icon: Icons.home_rounded, label: AppStrings.navHome),
          (icon: Icons.account_balance_wallet_rounded, label: AppStrings.navCash),
          (icon: Icons.payment_rounded, label: AppStrings.navDues),
          (icon: Icons.bar_chart_rounded, label: AppStrings.navReports),
          (icon: Icons.person_rounded, label: AppStrings.navProfile),
        ];
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              final isSelected = currentIndex == i;

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  splashColor: AppColors.primary.withValues(alpha: 0.08),
                  highlightColor: Colors.transparent,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.12)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            item.icon,
                            size: 22,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textHint,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
