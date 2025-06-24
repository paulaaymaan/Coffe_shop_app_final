
import 'package:coffee_shop_app/src/features/onboarding/domain/repositories/onboarding_repository.dart';

class CheckOnboardingCompleteUseCase {
  final OnboardingRepository _repository;
  CheckOnboardingCompleteUseCase(this._repository);
  Future<bool> call() => _repository.checkOnboardingComplete();
}