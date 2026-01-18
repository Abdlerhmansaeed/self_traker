import 'package:flutter/material.dart';
import 'package:self_traker/features/auth/domain/entities/auth_failure.dart';
// import '../domain/entities/auth_failure.dart';

extension AuthFailureLocalization on AuthFailure {
  String getLocalizedMessage(BuildContext context, {int? countdown}) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';

    switch (getLocalizedMessageKey()) {
      case 'auth_error_invalid_credentials':
        return isArabic
            ? 'البريد الإلكتروني أو كلمة المرور غير صحيحة. يرجى المحاولة مرة أخرى.'
            : 'Invalid email or password. Please try again.';
      case 'auth_error_email_exists':
        return isArabic
            ? 'يوجد حساب بهذا البريد الإلكتروني بالفعل.'
            : 'An account with this email already exists.';
      case 'auth_error_email_exists_google':
        return isArabic
            ? 'هذا البريد مسجل بحساب جوجل. يرجى تسجيل الدخول بجوجل.'
            : 'This email is registered with Google. Please sign in with Google.';
      case 'auth_error_weak_password':
        return isArabic
            ? 'يجب أن تكون كلمة المرور 8 أحرف على الأقل مع حرف كبير وصغير ورقم.'
            : 'Password must be at least 8 characters with uppercase, lowercase, and number.';
      case 'auth_error_rate_limited':
        final countdownStr = countdown?.toString() ?? '60';
        return isArabic
            ? 'محاولات كثيرة. يرجى الانتظار $countdownStr ثانية.'
            : 'Too many attempts. Please wait $countdownStr seconds.';
      case 'auth_error_network':
        return isArabic
            ? 'خطأ في الشبكة. يرجى التحقق من اتصالك والمحاولة مرة أخرى.'
            : 'Network error. Please check your connection and try again.';
      case 'auth_error_account_disabled':
        return isArabic
            ? 'تم تعطيل هذا الحساب. تواصل مع الدعم للمساعدة.'
            : 'This account has been disabled. Contact support for help.';
      case 'auth_error_email_not_verified':
        return isArabic
            ? 'يرجى تأكيد بريدك الإلكتروني للوصول لجميع الميزات.'
            : 'Please verify your email to access all features.';
      default:
        return isArabic
            ? 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.'
            : 'An unexpected error occurred. Please try again.';
    }
  }
}
