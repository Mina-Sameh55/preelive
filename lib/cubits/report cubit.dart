import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/model/report.dart';
import 'package:untitled1/repo/report%20repo.dart';

import 'reaport state.dart';

class ReportCubit extends Cubit<ReportState> {
  final ReportRepository repository;

  ReportCubit({required this.repository}) : super(ReportInitial());

  Future<void> loadReports() async {
    emit(ReportLoading());
    try {
      final reports = await repository.getReports();
      emit(ReportLoaded(reports));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }

  Future<void> dismissReport(String reportId) async {
    try {
      await repository.dismissReport(reportId);
      loadReports();
    } catch (e) {
      emit(ReportError('Failed to dismiss report'));
    }
  }
}