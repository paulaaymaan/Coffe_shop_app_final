
abstract class OnboardingRepository {
  Future<bool> checkOnboardingComplete();
  Future<void> setOnboardingComplete();
}