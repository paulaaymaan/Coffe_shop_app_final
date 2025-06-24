
import 'package:coffee_shop_app/src/features/onboarding/data/onboarding_local_data_source.dart';
import 'package:coffee_shop_app/src/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource _localDataSource;
  OnboardingRepositoryImpl(this._localDataSource);

  @override
  Future<bool> checkOnboardingComplete() {
    return _localDataSource.getHasSeenWelcomeScreen();
  }

  @override
  Future<void> setOnboardingComplete() {
    return _localDataSource.setHasSeenWelcomeScreen(true);
  }
}