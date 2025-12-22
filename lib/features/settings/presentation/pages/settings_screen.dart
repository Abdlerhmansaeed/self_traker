import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resposive_xx/responsive_x.dart';

import '../../../../core/cubit/theme_cubit.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/settings_cubit.dart';
import '../widgets/ai_coach_style_selector.dart';
import '../widgets/profile_header.dart';
import '../widgets/settings_group.dart';
import '../widgets/settings_item.dart';

/// Settings screen with profile and app settings
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            _buildAppBar(context),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: AppDimensions.paddingHorizontal,
                  right: AppDimensions.paddingHorizontal,
                  bottom: 100.h,
                ),
                child: Column(
                  children: [
                    // Profile header
                    const ProfileHeader(
                      name: 'Alex Morgan',
                      email: 'alex.morgan@example.com',
                      avatarUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuA5YoOJFbQ_e59g8xBL7OKkGVolGB4i4LnDECp9QFQ_2HTaHv5Ixb_7f8uiA3bLcqfv9IhRPKZcJ8tyfkXaH3Slnl4pNCH3-68WRx9QgykMxxOGxYNdQXBMB7LV8wLNS_dhO5_Kh9ocuLN1ECrIn68evcnOi5xFDdm_KO4dX4urwHLmhi6P-lv_VTWd8BdGBJitB8jdPam5qaq4GYMKkW-vv6zOHDCt5AN4D5D8iRnWXZET59fpZeCuloR6AclDHw4t4eQGE9y782k',
                      badge: 'Pro Member',
                    ),
                    SizedBox(height: AppDimensions.spacingLg),
                    // General settings
                    _buildGeneralSettings(context),
                    SizedBox(height: AppDimensions.spacingLg),
                    // App settings
                    _buildAppSettings(context),
                    SizedBox(height: AppDimensions.spacingLg),
                    // Data management
                    _buildDataManagement(context),
                    SizedBox(height: AppDimensions.spacingLg),
                    // Logout button
                    _buildLogoutButton(context, isDark),
                    SizedBox(height: AppDimensions.spacingMd),
                    // Version
                    Text(
                      'Version 1.0.0 (Build 1)',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Row(
        children: [
          const SizedBox(width: 48), // Spacer for centering
          Expanded(
            child: Text(
              'Settings',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Save settings
            },
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSettings(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return SettingsGroup(
          title: 'General',
          children: [
            // Currency
            SettingsItem(
              icon: Icons.attach_money,
              title: 'Currency',
              iconBackgroundColor: AppColors.primary.withOpacity(0.2),
              iconColor: AppColors.textDark,
              trailingText: 'USD (\$)',
              onTap: () {
                // TODO: Show currency picker
              },
            ),
            // AI Coach Style
            Padding(
              padding: EdgeInsets.all(AppDimensions.spacingMd),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36.r,
                        height: 36.r,
                        decoration: BoxDecoration(
                          color: Colors.indigo.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.psychology,
                          size: 20.r,
                          color: Colors.indigo,
                        ),
                      ),
                      SizedBox(width: AppDimensions.spacingMd),
                      Expanded(
                        child: Text(
                          'AI Coach Style',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.info_outline,
                        size: 20.r,
                        color: AppColors.textSub,
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spacingSm),
                  AiCoachStyleSelector(
                    selectedStyle: state.aiCoachStyle,
                    onStyleChanged: (style) {
                      context.read<SettingsCubit>().setAiCoachStyle(style);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAppSettings(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return SettingsGroup(
              title: 'App Settings',
              children: [
                // Smart Alerts
                SettingsItem(
                  icon: Icons.notifications_active,
                  title: 'Smart Alerts',
                  subtitle: 'AI-driven spending notifications',
                  iconBackgroundColor: Colors.purple.withOpacity(0.1),
                  iconColor: Colors.purple,
                  trailing: SettingsItemTrailing.toggle,
                  toggleValue: settingsState.smartAlertsEnabled,
                  onToggleChanged: (_) {
                    context.read<SettingsCubit>().toggleSmartAlerts();
                  },
                ),
                // Dark Mode
                SettingsItem(
                  icon: Icons.dark_mode,
                  title: 'Dark Mode',
                  iconBackgroundColor: Colors.grey.withOpacity(0.1),
                  iconColor: Colors.grey.shade600,
                  trailing: SettingsItemTrailing.toggle,
                  toggleValue: themeState.isDarkMode,
                  onToggleChanged: (_) {
                    context.read<ThemeCubit>().toggleTheme();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDataManagement(BuildContext context) {
    return SettingsGroup(
      title: 'Data Management',
      children: [
        // Backup & Sync
        SettingsItem(
          icon: Icons.cloud_sync,
          title: 'Backup & Sync',
          subtitle: 'Last synced: 2m ago',
          iconBackgroundColor: Colors.blue.withOpacity(0.1),
          iconColor: Colors.blue,
          onTap: () {
            // TODO: Show backup options
          },
        ),
        // Export Data
        SettingsItem(
          icon: Icons.ios_share,
          title: 'Export Data',
          iconBackgroundColor: Colors.orange.withOpacity(0.1),
          iconColor: Colors.orange,
          onTap: () {
            // TODO: Show export options
          },
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Implement logout
        },
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Padding(
          padding: EdgeInsets.all(14.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, size: 20.r, color: AppColors.negative),
              SizedBox(width: 8.w),
              Text(
                'Log Out',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.negative,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
