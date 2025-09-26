import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _isLoading = false;
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inscription réussie !'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, '/');
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _mapError(e.code));
    } catch (_) {
      setState(() => _error = "Une erreur inattendue s'est produite.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _mapError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Cette adresse email est déjà utilisée.';
      case 'weak-password':
        return 'Le mot de passe est trop faible.';
      case 'invalid-email':
        return 'Adresse email invalide.';
      case 'operation-not-allowed':
        return "L'inscription par email est désactivée.";
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
                            Icons.person_add,
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
                        'Créer un compte',
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
                                helperText: 'Au moins 6 caractères',
                                prefixIcon: const Icon(Icons.lock_outline),
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  tooltip: _obscurePass
                                      ? 'Afficher'
                                      : 'Masquer',
                                  icon: Icon(
                                    _obscurePass
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: _isLoading
                                      ? null
                                      : () => setState(
                                          () => _obscurePass = !_obscurePass,
                                        ),
                                ),
                              ),
                              obscureText: _obscurePass,
                              autofillHints: const [AutofillHints.newPassword],
                              validator: (v) {
                                if ((v ?? '').isEmpty) {
                                  return 'Veuillez saisir un mot de passe';
                                }
                                if ((v ?? '').length < 6) {
                                  return 'Au moins 6 caractères';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) =>
                                  _confirmFocus.requestFocus(),
                              enabled: !_isLoading,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _confirmCtrl,
                              focusNode: _confirmFocus,
                              decoration: InputDecoration(
                                labelText: 'Confirmer le mot de passe',
                                prefixIcon: const Icon(
                                  Icons.lock_person_outlined,
                                ),
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  tooltip: _obscureConfirm
                                      ? 'Afficher'
                                      : 'Masquer',
                                  icon: Icon(
                                    _obscureConfirm
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: _isLoading
                                      ? null
                                      : () => setState(
                                          () => _obscureConfirm =
                                              !_obscureConfirm,
                                        ),
                                ),
                              ),
                              obscureText: _obscureConfirm,
                              autofillHints: const [AutofillHints.password],
                              validator: (v) {
                                if ((v ?? '').isEmpty) {
                                  return 'Veuillez confirmer le mot de passe';
                                }
                                if (v != _passCtrl.text) {
                                  return 'Les mots de passe ne correspondent pas';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) => _register(),
                              enabled: !_isLoading,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : () => Navigator.pushReplacementNamed(
                                    context,
                                    '/login',
                                  ),
                            child: const Text('Déjà un compte ? Se connecter'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      SizedBox(
                        height: 48,
                        child: FilledButton(
                          onPressed: _isLoading ? null : _register,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text("S'inscrire"),
                        ),
                      ),

                      const SizedBox(height: 16),
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
