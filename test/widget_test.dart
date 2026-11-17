import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/main.dart';

void main() {
  testWidgets('TaskFlow muestra el listado de tareas', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TaskFlowApp());

    expect(find.text('Mis tareas'), findsOneWidget);
    expect(find.text('Completar Codelab 05'), findsOneWidget);
  });
}
