import '../model/report.dart';

abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportLoaded extends ReportState {
  final List<Report> reports;

  ReportLoaded(this.reports);
}

class ReportError extends ReportState {
  final String message;

  ReportError(this.message);
}