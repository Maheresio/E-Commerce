import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/repositories/visa_card_repository.dart';
import '../../../domain/usecases/visa_card/add_visa_card_usecase.dart';
import '../../../domain/usecases/visa_card/create_ephemeral_key_usecase.dart';
import '../../../domain/usecases/visa_card/delete_visa_card_usecase.dart';
import '../../../domain/usecases/visa_card/get_or_create_customer_usecase.dart';
import '../../../domain/usecases/visa_card/get_visa_cards_usecase.dart';
import '../../../domain/usecases/visa_card/set_default_visa_card_usecase.dart';
import 'visa_card_providers.dart';

// Get All Cards
final Provider<GetVisaCardsUseCase> getVisaCardsUseCaseProvider =
    Provider<GetVisaCardsUseCase>((ref) {
      final VisaCardRepository repository = ref.watch(
        visaCardRepositoryProvider,
      );
      return GetVisaCardsUseCase(repository);
    });

// Add a Card
final Provider<AddVisaCardUseCase> addVisaCardUseCaseProvider =
    Provider<AddVisaCardUseCase>((ref) {
      final VisaCardRepository repository = ref.watch(
        visaCardRepositoryProvider,
      );
      return AddVisaCardUseCase(repository);
    });

// Delete a Card
final Provider<DeleteVisaCardUseCase> deleteVisaCardUseCaseProvider =
    Provider<DeleteVisaCardUseCase>((ref) {
      final VisaCardRepository repository = ref.watch(
        visaCardRepositoryProvider,
      );
      return DeleteVisaCardUseCase(repository);
    });

// Set Default Card
final Provider<SetDefaultVisaCardUseCase> setDefaultVisaCardUseCaseProvider =
    Provider<SetDefaultVisaCardUseCase>((ref) {
      final VisaCardRepository repository = ref.watch(
        visaCardRepositoryProvider,
      );
      return SetDefaultVisaCardUseCase(repository);
    });

final Provider<GetOrCreateCustomerUsecase> getOrCreateCustomerUseCaseProvider =
    Provider<GetOrCreateCustomerUsecase>((ref) {
      final VisaCardRepository repository = ref.watch(
        visaCardRepositoryProvider,
      );
      return GetOrCreateCustomerUsecase(repository);
    });

final Provider<CreateEphemeralKeyUsecase> createEphemeralKeyUseCaseProvider =
    Provider<CreateEphemeralKeyUsecase>((ref) {
      final VisaCardRepository repository = ref.watch(
        visaCardRepositoryProvider,
      );
      return CreateEphemeralKeyUsecase(repository);
    });
