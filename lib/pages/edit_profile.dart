import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/header/drawer.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _displayFormKey = GlobalKey<FormState>();
  final _pwdFormKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _currentPwdCtrl = TextEditingController();
  final _newPwdCtrl = TextEditingController();
  final _confirmPwdCtrl = TextEditingController();

  bool _savingProfile = false;
  bool _changingPwd = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  String? _errorProfile;
  String? _errorPwd;

  User? get _user => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    final u = _user;
    _nameCtrl.text = u?.displayName ?? '';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _currentPwdCtrl.dispose();
    _newPwdCtrl.dispose();
    _confirmPwdCtrl.dispose();
    super.dispose();
  }

  // ----- PROFILE -----
  Future<void> _saveProfile() async {
    if (_user == null) return;
    if (!_displayFormKey.currentState!.validate()) return;

    setState(() {
      _savingProfile = true;
      _errorProfile = null;
    });

    try {
      await _user!.updateDisplayName(_nameCtrl.text.trim());
      await _user!.reload();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profil mis à jour ✅')));
      setState(() {}); // refresh UI
    } on FirebaseAuthException catch (e) {
      setState(() => _errorProfile = _mapFirebaseError(e.code));
    } catch (_) {
      setState(() => _errorProfile = "Une erreur inattendue s'est produite.");
    } finally {
      if (mounted) setState(() => _savingProfile = false);
    }
  }

  // ----- PASSWORD -----
  Future<void> _changePassword() async {
    if (_user == null) return;
    if (!_pwdFormKey.currentState!.validate()) return;

    setState(() {
      _changingPwd = true;
      _errorPwd = null;
    });

    try {
      final email = _user!.email;
      if (email == null || email.isEmpty) {
        throw FirebaseAuthException(
          code: 'missing-email',
          message: "Email manquant pour l'utilisateur.",
        );
      }

      // Re-authentifier
      final cred = EmailAuthProvider.credential(
        email: email,
        password: _currentPwdCtrl.text,
      );
      await _user!.reauthenticateWithCredential(cred);

      // Mettre à jour le mot de passe
      await _user!.updatePassword(_newPwdCtrl.text);
      await _user!.reload();

      if (!mounted) return;
      _currentPwdCtrl.clear();
      _newPwdCtrl.clear();
      _confirmPwdCtrl.clear();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Mot de passe changé ✅')));
    } on FirebaseAuthException catch (e) {
      setState(() => _errorPwd = _mapFirebaseError(e.code));
    } catch (_) {
      setState(() => _errorPwd = "Une erreur inattendue s'est produite.");
    } finally {
      if (mounted) setState(() => _changingPwd = false);
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'wrong-password':
        return 'Mot de passe actuel incorrect.';
      case 'requires-recent-login':
        return 'Action sensible : reconnectez-vous puis réessayez.';
      case 'weak-password':
        return 'Nouveau mot de passe trop faible.';
      case 'missing-email':
        return 'Aucun email associé au compte.';
      case 'user-mismatch':
      case 'user-not-found':
        return 'Utilisateur non reconnu.';
      case 'invalid-credential':
        return 'Identifiants invalides.';
      default:
        return 'Une erreur est survenue. Veuillez réessayer.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final u = _user;
    return Scaffold(
      appBar: AppBar(title: const Text('Éditer le profil')),
      drawer: const AppDrawer(),
      body: u == null
          ? _NotLoggedIn()
          : SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Infos utilisateur
                        Card(
                          child: ListTile(
                            leading: const Icon(Icons.account_circle, size: 32),
                            title: Text(u.email ?? ''),
                            subtitle: Text(
                              (u.displayName?.isNotEmpty ?? false)
                                  ? 'Nom affiché : ${u.displayName}'
                                  : 'Aucun nom d’affichage',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ------- Profil (nom) -------
                        Text(
                          'Profil',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),

                        if (_errorProfile != null) ...[
                          _ErrorBox(_errorProfile!),
                          const SizedBox(height: 8),
                        ],

                        Form(
                          key: _displayFormKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _nameCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Nom d’affichage',
                                  prefixIcon: Icon(Icons.badge_outlined),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (v) {
                                  final t = (v ?? '').trim();
                                  if (t.length > 50) {
                                    return 'Nom trop long (50 max).';
                                  }
                                  return null;
                                },
                                enabled: !_savingProfile,
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 48,
                                width: double.infinity,
                                child: FilledButton.icon(
                                  onPressed: _savingProfile
                                      ? null
                                      : _saveProfile,
                                  icon: _savingProfile
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.save_outlined),
                                  label: const Text('Enregistrer'),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ------- Mot de passe -------
                        Text(
                          'Mot de passe',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),

                        if (_errorPwd != null) ...[
                          _ErrorBox(_errorPwd!),
                          const SizedBox(height: 8),
                        ],

                        Form(
                          key: _pwdFormKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _currentPwdCtrl,
                                decoration: InputDecoration(
                                  labelText: 'Mot de passe actuel',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    tooltip: _obscureCurrent
                                        ? 'Afficher'
                                        : 'Masquer',
                                    icon: Icon(
                                      _obscureCurrent
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: _changingPwd
                                        ? null
                                        : () => setState(
                                            () => _obscureCurrent =
                                                !_obscureCurrent,
                                          ),
                                  ),
                                ),
                                obscureText: _obscureCurrent,
                                validator: (v) {
                                  if ((v ?? '').isEmpty) {
                                    return 'Veuillez entrer votre mot de passe actuel';
                                  }
                                  return null;
                                },
                                enabled: !_changingPwd,
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _newPwdCtrl,
                                decoration: InputDecoration(
                                  labelText: 'Nouveau mot de passe',
                                  prefixIcon: const Icon(
                                    Icons.lock_reset_outlined,
                                  ),
                                  border: const OutlineInputBorder(),
                                  helperText: 'Au moins 6 caractères',
                                  suffixIcon: IconButton(
                                    tooltip: _obscureNew
                                        ? 'Afficher'
                                        : 'Masquer',
                                    icon: Icon(
                                      _obscureNew
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: _changingPwd
                                        ? null
                                        : () => setState(
                                            () => _obscureNew = !_obscureNew,
                                          ),
                                  ),
                                ),
                                obscureText: _obscureNew,
                                validator: (v) {
                                  final t = (v ?? '');
                                  if (t.length < 6) {
                                    return 'Au moins 6 caractères';
                                  }
                                  return null;
                                },
                                enabled: !_changingPwd,
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _confirmPwdCtrl,
                                decoration: InputDecoration(
                                  labelText:
                                      'Confirmer le nouveau mot de passe',
                                  prefixIcon: const Icon(
                                    Icons.lock_outline_rounded,
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
                                    onPressed: _changingPwd
                                        ? null
                                        : () => setState(
                                            () => _obscureConfirm =
                                                !_obscureConfirm,
                                          ),
                                  ),
                                ),
                                obscureText: _obscureConfirm,
                                validator: (v) {
                                  if (v != _newPwdCtrl.text) {
                                    return 'Les mots de passe ne correspondent pas';
                                  }
                                  return null;
                                },
                                enabled: !_changingPwd,
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 48,
                                width: double.infinity,
                                child: FilledButton.icon(
                                  onPressed: _changingPwd
                                      ? null
                                      : _changePassword,
                                  icon: _changingPwd
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.password),
                                  label: const Text('Changer le mot de passe'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.error.withOpacity(.3)),
      ),
      child: Text(text, style: TextStyle(color: cs.onErrorContainer)),
    );
  }
}

class _NotLoggedIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 64),
            const SizedBox(height: 12),
            const Text(
              'Vous devez être connecté pour éditer votre profil.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}
