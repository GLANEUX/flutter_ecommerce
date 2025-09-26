import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();

  bool _isLoading = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate() || !mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connexion réussie !'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _error = _mapError(e.code));
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = "Une erreur inattendue s'est produite.");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _mapError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Aucun utilisateur trouvé avec cet email.';
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      case 'invalid-email':
        return 'Adresse email invalide.';
      case 'user-disabled':
        return 'Ce compte a été désactivé.';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard.';
      default:
        return 'Une erreur est survenue. Veuillez réessayer.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_bag,
                            size: 42,
                            color: scheme.primary,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Fake Store',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Connexion',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_error != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: scheme.errorContainer,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: scheme.error.withValues(alpha: .4),
                            ),
                          ),
                          child: Text(
                            _error!,
                            style: TextStyle(color: scheme.onErrorContainer),
                          ),
                        ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailCtrl,
                              focusNode: _emailFocus,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [
                                AutofillHints.username,
                                AutofillHints.email,
                              ],
                              validator: (v) {
                                final value = (v ?? '').trim();
                                if (value.isEmpty) {
                                  return 'Veuillez saisir votre email';
                                }
                                final emailRegex = RegExp(
                                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                );
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Adresse email invalide';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) =>
                                  _passFocus.requestFocus(),
                              enabled: !_isLoading,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passCtrl,
                              focusNode: _passFocus,
                              decoration: InputDecoration(
                                labelText: 'Mot de passe',
                                prefixIcon: const Icon(Icons.lock_outline),
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  tooltip: _obscure ? 'Afficher' : 'Masquer',
                                  icon: Icon(
                                    _obscure
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: _isLoading
                                      ? null
                                      : () => setState(
                                          () => _obscure = !_obscure,
                                        ),
                                ),
                              ),
                              obscureText: _obscure,
                              autofillHints: const [AutofillHints.password],
                              validator: (v) {
                                if ((v ?? '').isEmpty) {
                                  return 'Veuillez saisir votre mot de passe';
                                }
                                if ((v ?? '').length < 6) {
                                  return 'Au moins 6 caractères';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) => _signIn(),
                              enabled: !_isLoading,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : () => Navigator.pushReplacementNamed(
                                    context,
                                    '/register',
                                  ),
                            child: const Text('Pas de compte ? S\'inscrire'),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 48,
                        child: FilledButton(
                          onPressed: _isLoading ? null : _signIn,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Se connecter'),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Divider
                      Row(
                        children: const [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('ou'),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  if (!context.mounted) return;
                                  try {
                                    await signInWithGoogle();
                                    if (!context.mounted) return;
                                  } catch (e) {
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Connexion Google impossible',
                                        ),
                                      ),
                                    );
                                  }
                                },

                          label: const Text('Se connecter avec Google'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> signInWithGoogle() async {
  try {
    if (kIsWeb) {
      // --- WEB: utiliser les popups Firebase directement ---
      final provider = GoogleAuthProvider();
      // Optionnel: scopes supplémentaires
      // provider.addScope('https://www.googleapis.com/auth/userinfo.email');

      await FirebaseAuth.instance.signInWithPopup(provider);
      // Alternative si popup bloqué:
      // await FirebaseAuth.instance.signInWithRedirect(provider);
      return;
    } else {
      // --- ANDROID / iOS ---
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // l’utilisateur a annulé

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      return;
    }
  } on FirebaseAuthException catch (e) {
    // Utile pour diagnostiquer
    debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
    rethrow;
  } catch (e) {
    debugPrint('Google sign-in error: $e');
    rethrow;
  }
}
