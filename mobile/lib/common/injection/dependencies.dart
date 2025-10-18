import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:fodie_ai/common/injection/dependencies.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  await getIt.init();
  // CachedRepository.logger = getIt<Logger>();
}
