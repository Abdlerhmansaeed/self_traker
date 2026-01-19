import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:self_traker/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:self_traker/features/auth/presentation/cubit/auth_state.dart';
import 'package:self_traker/features/auth/presentation/widgets/email_verification_banner.dart';

class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  late MockAuthCubit mockAuthCubit;

  setUp(() {
    mockAuthCubit = MockAuthCubit();
    // Provide default stream for BlocProvider
    when(
      () => mockAuthCubit.stream,
    ).thenAnswer((_) => const Stream<AuthState>.empty());
    when(() => mockAuthCubit.state).thenReturn(const AuthInitial());
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<AuthCubit>.value(
          value: mockAuthCubit,
          child: const EmailVerificationBanner(),
        ),
      ),
    );
  }

  group('EmailVerificationBanner', () {
    testWidgets('should display verification message', (tester) async {
      // Act
      await tester.pumpWidget(buildTestWidget());

      // Assert
      expect(find.text('Please verify your email'), findsOneWidget);
      expect(
        find.text('Check your inbox for the verification link'),
        findsOneWidget,
      );
    });

    testWidgets('should display info icon', (tester) async {
      // Act

      // Act
      await tester.pumpWidget(buildTestWidget());

      // Assert
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('should display resend button', (tester) async {
      // Act
      await tester.pumpWidget(buildTestWidget());

      // Assert
      expect(find.text('Resend'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets(
      'should call sendVerificationEmail when resend button is tapped',
      (tester) async {
        // Arrange
        when(
          () => mockAuthCubit.sendVerificationEmail(),
        ).thenAnswer((_) async {});

        // Act
        await tester.pumpWidget(buildTestWidget());
        await tester.tap(find.text('Resend'));
        await tester.pump();

        // Assert
        verify(() => mockAuthCubit.sendVerificationEmail()).called(1);
      },
    );

    testWidgets('should show snackbar when resend button is tapped', (
      tester,
    ) async {
      // Arrange
      when(
        () => mockAuthCubit.sendVerificationEmail(),
      ).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(buildTestWidget());
      await tester.tap(find.text('Resend'));
      await tester.pump(); // Start snackbar animation
      await tester.pump(
        const Duration(milliseconds: 100),
      ); // Progress animation

      // Assert
      expect(find.text('Verification email sent'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('should have amber color scheme', (tester) async {
      // Act
      await tester.pumpWidget(buildTestWidget());

      // Assert
      final container = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('Please verify your email'),
              matching: find.byType(Container),
            )
            .first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.amber.shade50);
    });

    testWidgets('should display banner with full width', (tester) async {
      // Act
      await tester.pumpWidget(buildTestWidget());

      // Assert
      final container = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('Please verify your email'),
              matching: find.byType(Container),
            )
            .first,
      );

      expect(container.constraints?.minWidth, double.infinity);
    });
  });
}
