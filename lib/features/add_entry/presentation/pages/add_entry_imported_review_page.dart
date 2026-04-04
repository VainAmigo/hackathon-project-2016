import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_temp/components/components.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/add_entry/cubit/add_entry_confirm_cubit.dart';
import 'package:project_temp/features/add_entry/cubit/add_entry_confirm_state.dart';
import 'package:project_temp/features/add_entry/domain/apply_extracted_entry.dart';
import 'package:project_temp/features/add_entry/domain/build_persons_v1_request.dart';
import 'package:project_temp/features/add_entry/presentation/widgets/add_entry_manual_form_body.dart';
import 'package:project_temp/features/home/home_shell_tab_sync.dart';
import 'package:project_temp/l10n/app_localizations.dart';
import 'package:project_temp/source/source.dart';

/// Экран после импорта: при `type: single` — форма и выбор языка перевода; при `plural` / без данных — только закрытие.
class AddEntryImportedReviewPage extends StatefulWidget {
  const AddEntryImportedReviewPage({super.key, required this.uploadResponse});

  final DocumentUploadResponse uploadResponse;

  @override
  State<AddEntryImportedReviewPage> createState() =>
      _AddEntryImportedReviewPageState();
}

class _AddEntryImportedReviewPageState
    extends State<AddEntryImportedReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _accusation = TextEditingController();
  final _yearFrom = TextEditingController();
  final _yearTo = TextEditingController();
  final _punishment = TextEditingController();
  final _region = TextEditingController();
  final _punishmentDate = TextEditingController();
  final _occupation = TextEditingController();
  final _rehabDate = TextEditingController();
  final _biography = TextEditingController();

  XFile? _selectedPhoto;
  bool _localeKeysApplied = false;
  String? _selectedLocaleKey;

  bool get _editable =>
      importExtractAllowsEditing(widget.uploadResponse.mlResponse);

  @override
  void dispose() {
    _fullName.dispose();
    _accusation.dispose();
    _yearFrom.dispose();
    _yearTo.dispose();
    _punishment.dispose();
    _region.dispose();
    _punishmentDate.dispose();
    _occupation.dispose();
    _rehabDate.dispose();
    _biography.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_editable || _localeKeysApplied) return;
    final ml = widget.uploadResponse.mlResponse;
    if (ml == null || ml.byLocale.isEmpty) return;
    _localeKeysApplied = true;
    _selectedLocaleKey = pickInitialImportLocaleKey(
      ml.byLocale,
      AppLocaleScope.of(context).code,
    );
    _applyFieldsForKey(_selectedLocaleKey!);
  }

  void _applyFieldsForKey(String key) {
    final fields = widget.uploadResponse.mlResponse?.byLocale[key];
    applyExtractedToManualForm(
      fields: fields,
      fullName: _fullName,
      accusation: _accusation,
      yearFrom: _yearFrom,
      yearTo: _yearTo,
      punishment: _punishment,
      region: _region,
      punishmentDate: _punishmentDate,
      occupation: _occupation,
      rehabDate: _rehabDate,
      biography: _biography,
    );
  }

  void _onLanguageSelected(String key) {
    if (_selectedLocaleKey == key) return;
    setState(() {
      _selectedLocaleKey = key;
      _applyFieldsForKey(key);
    });
  }

  void _onSubmit(BuildContext context, AppLocalizations l10n) {
    final docId = widget.uploadResponse.documentId;
    final localeKey = _selectedLocaleKey;
    if (docId == null) {
      AppSnackMessenger.showMessage(
        l10n.addEntryConfirmNoDocument,
        isError: true,
      );
      return;
    }
    if (localeKey == null) {
      AppSnackMessenger.showMessage(
        l10n.addEntryFormValidationFailed,
        isError: true,
      );
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) {
      AppSnackMessenger.showMessage(
        l10n.addEntryFormValidationFailed,
        isError: true,
      );
      return;
    }
    final ru = widget.uploadResponse.mlResponse?.byLocale['ru'] ??
        widget.uploadResponse.mlResponse?.byLocale[localeKey];
    final request = buildPersonsV1Request(
      documentId: docId,
      contentLocaleKey: localeKey,
      fullName: _fullName.text,
      accusation: _accusation.text,
      yearFrom: _yearFrom.text,
      yearTo: _yearTo.text,
      punishment: _punishment.text,
      regionLine: _region.text,
      punishmentDate: _punishmentDate.text,
      occupation: _occupation.text,
      rehabDate: _rehabDate.text,
      biography: _biography.text,
      ruBaseline: ru,
    );
    context.read<AddEntryConfirmCubit>().submitImportedPerson(
          request: request,
          photo: _selectedPhoto,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (!_editable) {
      return _ImportPluralScaffold(
        l10n: l10n,
        ml: widget.uploadResponse.mlResponse,
      );
    }

    return BlocProvider(
      create: (_) => AddEntryConfirmCubit(sl()),
      child: BlocConsumer<AddEntryConfirmCubit, AddEntryConfirmState>(
        listenWhen: (prev, curr) =>
            (curr.errorMessage != null &&
                curr.errorMessage != prev.errorMessage) ||
            (curr.success && !prev.success),
        listener: (context, state) {
          final err = state.errorMessage;
          if (err != null) {
            AppSnackMessenger.showMessage(err, isError: true);
            context.read<AddEntryConfirmCubit>().clearError();
          }
          if (state.success && context.mounted) {
            sl<HomeShellTabSync>().selectTab(0);
            Navigator.of(context).pop(true);
            AppSnackMessenger.showMessage(l10n.addEntryConfirmSuccess);
          }
        },
        builder: (context, confirmState) {
          final ml = widget.uploadResponse.mlResponse!;
          final keys = sortedImportLocaleKeys(ml.byLocale);
          return Scaffold(
            appBar: AppBar(title: Text(l10n.addEntryImportReviewTitle)),
            body: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 48,
                        maxWidth: 720,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.addEntryImportLanguageLabel,
                            style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 0.6,
                              fontWeight: FontWeight.w600,
                              color: AppThemes.textColorGrey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: keys.map((k) {
                              final selected = _selectedLocaleKey == k;
                              return ChoiceChip(
                                label: Text(k.toUpperCase()),
                                selected: selected,
                                onSelected: (_) => _onLanguageSelected(k),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                          AddEntryManualFormBody(
                            l10n: l10n,
                            formKey: _formKey,
                            fullName: _fullName,
                            accusation: _accusation,
                            yearFrom: _yearFrom,
                            yearTo: _yearTo,
                            punishment: _punishment,
                            region: _region,
                            punishmentDate: _punishmentDate,
                            occupation: _occupation,
                            rehabDate: _rehabDate,
                            biography: _biography,
                            onPhotoChanged: (files) {
                              setState(() {
                                _selectedPhoto = files.isEmpty
                                    ? null
                                    : files.first;
                              });
                            },
                          ),
                          const SizedBox(height: 32),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: confirmState.isSubmitting
                                    ? null
                                    : () => Navigator.of(context).pop(false),
                                child: Text(
                                  l10n.addEntryCancel,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.6,
                                    color: AppThemes.textColorSecondary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: PrimaryButton(
                                  text: l10n.addEntryConfirmSave,
                                  onPressed: confirmState.isSubmitting
                                      ? null
                                      : () => _onSubmit(context, l10n),
                                  child: confirmState.isSubmitting
                                      ? const CenteredProgressingButton(null)
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ImportPluralScaffold extends StatelessWidget {
  const _ImportPluralScaffold({
    required this.l10n,
    required this.ml,
  });

  final AppLocalizations l10n;
  final EntryMlResponse? ml;

  @override
  Widget build(BuildContext context) {
    final warnings = ml?.warnings ?? const <String>[];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addEntryImportPluralTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.addEntryImportPluralBody,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.45,
                  color: AppThemes.textColorSecondary,
                ),
              ),
              if (warnings.isNotEmpty) ...[
                const SizedBox(height: 20),
                ...warnings.map(
                  (w) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                            color: AppThemes.textColorSecondary,
                            height: 1.45,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            w,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.45,
                              color: AppThemes.textColorSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const Spacer(),
              PrimaryButton(
                text: l10n.addEntryImportPluralClose,
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
