import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:self_traker/features/home/presentation/widgets/transaction_item.dart';

class HomeState extends Equatable {
  const HomeState({
    this.permissionStatus,
    this.isListening = false,
    this.speechResult = '',
    this.isSpeechInitialized = false,
    this.totalUserBalance = 0.0,
    this.userTransactionsList,
  });

  final PermissionStatus? permissionStatus;
  final bool isListening;
  final String speechResult;
  final bool isSpeechInitialized;
  final double totalUserBalance;
  final List<TransactionData>? userTransactionsList;

  HomeState copyWith({
    PermissionStatus? permissionStatus,
    bool? isListening,
    String? speechResult,
    bool? isSpeechInitialized,
    double? totalUserBalance,
    List<TransactionData>? userTransactionsList,
  }) {
    return HomeState(
      permissionStatus: permissionStatus ?? this.permissionStatus,
      isListening: isListening ?? this.isListening,
      speechResult: speechResult ?? this.speechResult,
      isSpeechInitialized: isSpeechInitialized ?? this.isSpeechInitialized,
      totalUserBalance: totalUserBalance ?? this.totalUserBalance,
      userTransactionsList: userTransactionsList?? this.userTransactionsList
    );
  }

  @override
  @override
  List<Object?> get props => [
    permissionStatus,
    isListening,
    speechResult,
    isSpeechInitialized,
    totalUserBalance,
    userTransactionsList
  ];
}
