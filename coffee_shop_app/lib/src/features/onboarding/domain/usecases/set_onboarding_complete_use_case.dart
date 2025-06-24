
import 'package:coffee_shop_app/src/features/onboarding/domain/repositories/onboarding_repository.dart';

class SetOnboardingCompleteUseCase {
  final OnboardingRepository _repository;
  SetOnboardingCompleteUseCase(this._repository);
  Future<void> call() => _repository.setOnboardingComplete();
}