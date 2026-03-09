import 'package:todo_list_app/app/app.dart';
import 'package:todo_list_app/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
