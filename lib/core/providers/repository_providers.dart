import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/idea_repository.dart';
import '../../domain/repositories/project_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/ai_repository.dart';
import '../../data/implementations/mock_idea_repository.dart';
import '../../data/implementations/mock_project_repository.dart';
import '../../data/implementations/mock_auth_repository.dart';
import '../../data/implementations/mock_ai_repository.dart';
import '../../data/network/api_client.dart';

/// ─── Dependency Injection ────────────────────────────────────────────────────
///
/// All repository bindings live here. Notifiers read from these providers
/// and NEVER instantiate concrete classes directly.
///
/// To swap to a real backend:
///   1. Add a new implementation in `lib/data/implementations/`.
///   2. Change the right-hand side of the relevant provider below.
///   Zero UI code needs to change.
/// ─────────────────────────────────────────────────────────────────────────────

/// Provides the [IdeaRepository] implementation currently in use.
final ideaRepositoryProvider = Provider<IdeaRepository>(
  (ref) => MockIdeaRepository(),
);

/// Provides the [ProjectRepository] implementation currently in use.
final projectRepositoryProvider = Provider<ProjectRepository>(
  (ref) => MockProjectRepository(),
);

/// Provides the [AuthRepository] implementation currently in use.
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => MockAuthRepository(),
);

/// Provides the [AiRepository] implementation currently in use.
final aiRepositoryProvider = Provider<AiRepository>(
  (ref) => MockAiRepository(),
);

/// Provides the [ApiClient] implementation currently in use.
/// Swap [MockApiClient] → [HttpApiClient] when a real backend is ready.
final apiClientProvider = Provider<ApiClient>(
  (ref) => MockApiClient(),
);
