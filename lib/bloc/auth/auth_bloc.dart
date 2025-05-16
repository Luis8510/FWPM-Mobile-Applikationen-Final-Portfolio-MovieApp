import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_event.dart';
import 'auth_state.dart';

export 'auth_event.dart';
export 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;

  AuthBloc({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>((e, emit) => emit(AuthAuthenticated(e.userId)));
    on<LoggedOut>(_onLoggedOut);
    on<RegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user.uid));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _firebaseAuth.signOut();
    emit(AuthUnauthenticated());
  }

  Future<void> _onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final cred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      await cred.user?.updateDisplayName(event.username);
      await cred.user?.reload();
      final user = _firebaseAuth.currentUser!;
      emit(AuthAuthenticated(user.uid));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'Registrierung fehlgeschlagen'));
    }
  }
}
