import 'package:untitled1/model/report.dart';

abstract class ReportRepository {
  Future<List<Report>> getReports();
  Future<void> dismissReport(String reportId);
}