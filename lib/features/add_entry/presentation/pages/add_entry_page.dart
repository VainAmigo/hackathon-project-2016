import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:project_temp/components/components.dart';
import 'package:project_temp/core/core.dart';

import '../../../../l10n/app_localizations.dart';

/// Вкладка навигации «Добавить запись»: авто (файлы) и ручное заполнение.
class AddEntryPage extends StatefulWidget {
  const AddEntryPage({super.key});

  @override
  State<AddEntryPage> createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  static const _accentUnderline = AppThemes.accentColor;

  int _mode = 0; // 0 — из файлов, 1 — вручную

  final _manualKey = GlobalKey<FormState>();
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

  /// Смена ключа сбрасывает внутренние списки [FileDropZone].
  int _filesEpoch = 0;

  /// Сохраняет состояние формы и [FileDropZone] при смене ширины (main уезжает
  /// из [Expanded] в [Column] и обратно — без ключа Flutter пересоздаёт поддерево).
  final GlobalKey _mainColumnKey = GlobalKey();

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

  void _showPlaceholderSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.addEntrySubmitPlaceholder)),
    );
  }

  void _resetAll(BuildContext context) {
    setState(() {
      _mode = 0;
      _filesEpoch++;
      _fullName.clear();
      _accusation.clear();
      _yearFrom.clear();
      _yearTo.clear();
      _punishment.clear();
      _region.clear();
      _punishmentDate.clear();
      _occupation.clear();
      _rehabDate.clear();
      _biography.clear();
    });
    _manualKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final adaptive = context.adaptive;
    final wide = adaptive.canUseSideNavigation;

    final main = Column(
      key: _mainColumnKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.addEntryEyebrow,
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
            color: AppThemes.textColorGrey,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.addEntryTitle,
          style: const TextStyle(
            fontFamily: 'serif',
            fontSize: 32,
            height: 1.15,
            fontWeight: FontWeight.w700,
            color: AppThemes.textColorPrimary,
          ),
        ),
        const SizedBox(height: 24),
        _EntryModeTabs(
          mode: _mode,
          onChanged: (i) => setState(() => _mode = i),
          accent: _accentUnderline,
        ),
        const SizedBox(height: 24),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: _mode == 0
              ? _AutoBody(
                  key: ValueKey('auto_$_filesEpoch'),
                  l10n: l10n,
                )
              : _ManualBody(
                  key: ValueKey('manual_$_filesEpoch'),
                  l10n: l10n,
                  formKey: _manualKey,
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
                ),
        ),
        const SizedBox(height: 32),
        _ActionRow(
          cancelLabel: l10n.addEntryCancel,
          primaryLabel: _mode == 0 ? l10n.addEntrySendData : l10n.addEntryPublish,
          onCancel: () => _resetAll(context),
          onPrimary: () {
            if (_mode == 1) {
              if (_manualKey.currentState?.validate() ?? false) {
                _showPlaceholderSnack(context);
              }
            } else {
              _showPlaceholderSnack(context);
            }
          },
        ),
      ],
    );

    final sidebar = _SidebarPanel(l10n: l10n);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: wide ? 32 : 20,
            vertical: 24,
          ),
          child: wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 11, child: sidebar),
                    const SizedBox(width: 40),
                    Expanded(flex: 19, child: main),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    sidebar,
                    const SizedBox(height: 32),
                    main,
                  ],
                ),
        );
      },
    );
  }
}

class _SidebarPanel extends StatelessWidget {
  const _SidebarPanel({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    TextStyle serifTitle() => const TextStyle(
          fontFamily: 'serif',
          fontSize: 22,
          height: 1.2,
          fontWeight: FontWeight.w700,
          color: AppThemes.textColorPrimary,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.addEntryWhyTitle, style: serifTitle()),
        const SizedBox(height: 12),
        Text(
          l10n.addEntryWhyBody,
          style: TextStyle(
            fontSize: 15,
            height: 1.45,
            color: AppThemes.textColorSecondary,
          ),
        ),
        const SizedBox(height: 28),
        Text(l10n.addEntryHowTitle, style: serifTitle()),
        const SizedBox(height: 12),
        Text(
          l10n.addEntryHowIntro,
          style: TextStyle(
            fontSize: 15,
            height: 1.45,
            color: AppThemes.textColorSecondary,
          ),
        ),
        const SizedBox(height: 16),
        _NumberedStep(n: '01', text: l10n.addEntryHowStep1),
        _NumberedStep(n: '02', text: l10n.addEntryHowStep2),
        _NumberedStep(n: '03', text: l10n.addEntryHowStep3),
      ],
    );
  }
}

class _NumberedStep extends StatelessWidget {
  const _NumberedStep({required this.n, required this.text});

  final String n;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 36,
            child: Text(
              n,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppThemes.textColorGrey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                color: AppThemes.textColorSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EntryModeTabs extends StatelessWidget {
  const _EntryModeTabs({
    required this.mode,
    required this.onChanged,
    required this.accent,
  });

  final int mode;
  final ValueChanged<int> onChanged;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        _TabChip(
          label: l10n.addEntryTabAuto,
          selected: mode == 0,
          accent: accent,
          onTap: () => onChanged(0),
        ),
        const SizedBox(width: 28),
        _TabChip(
          label: l10n.addEntryTabManual,
          selected: mode == 1,
          accent: accent,
          onTap: () => onChanged(1),
        ),
      ],
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.label,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 0.8,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                color: selected
                    ? AppThemes.textColorPrimary
                    : AppThemes.textColorGrey,
              ),
            ),
            const SizedBox(height: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: 72,
              decoration: BoxDecoration(
                color: selected ? accent : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AutoBody extends StatelessWidget {
  const _AutoBody({
    super.key,
    required this.l10n,
  });

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return FileDropZone(
      title: l10n.addEntryDocumentsTitle,
      hint: l10n.addEntryDocumentsHint,
      browseLabel: l10n.addEntryBrowseFiles,
      changeFileLabel: l10n.addEntryFileChange,
      removeFileLabel: l10n.addEntryFileRemove,
      invalidTypeMessage: l10n.addEntryInvalidFilePdf,
      kind: FileDropZoneKind.document,
      fileType: FileType.custom,
      allowedExtensions: const ['pdf'],
    );
  }
}

class _ManualBody extends StatelessWidget {
  const _ManualBody({
    super.key,
    required this.l10n,
    required this.formKey,
    required this.fullName,
    required this.accusation,
    required this.yearFrom,
    required this.yearTo,
    required this.punishment,
    required this.region,
    required this.punishmentDate,
    required this.occupation,
    required this.rehabDate,
    required this.biography,
  });

  final AppLocalizations l10n;
  final GlobalKey<FormState> formKey;
  final TextEditingController fullName;
  final TextEditingController accusation;
  final TextEditingController yearFrom;
  final TextEditingController yearTo;
  final TextEditingController punishment;
  final TextEditingController region;
  final TextEditingController punishmentDate;
  final TextEditingController occupation;
  final TextEditingController rehabDate;
  final TextEditingController biography;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, c) {
              final twoCol = c.maxWidth >= 520;
              Widget row2(Widget a, Widget b) {
                if (!twoCol) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [a, b],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: a),
                    const SizedBox(width: 20),
                    Expanded(child: b),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  row2(
                    CustomTextFormField(
                      controller: fullName,
                      label: l10n.addEntryFieldFullName,
                      hintText: l10n.addEntryFieldFullNameHint,
                    ),
                    CustomTextFormField(
                      controller: accusation,
                      label: l10n.addEntryFieldAccusation,
                    ),
                  ),
                  row2(
                    _YearRangeRow(
                      l10n: l10n,
                      yearFrom: yearFrom,
                      yearTo: yearTo,
                    ),
                    CustomTextFormField(
                      controller: punishment,
                      label: l10n.addEntryFieldPunishment,
                    ),
                  ),
                  row2(
                    CustomTextFormField(
                      controller: region,
                      label: l10n.addEntryFieldRegion,
                      hintText: l10n.addEntryFieldRegionHint,
                    ),
                    CustomTextFormField(
                      controller: punishmentDate,
                      label: l10n.addEntryFieldPunishmentDate,
                    ),
                  ),
                  row2(
                    CustomTextFormField(
                      controller: occupation,
                      label: l10n.addEntryFieldOccupation,
                    ),
                    CustomTextFormField(
                      controller: rehabDate,
                      label: l10n.addEntryFieldRehabDate,
                    ),
                  ),
                ],
              );
            },
          ),
          CustomTextFormField(
            controller: biography,
            label: l10n.addEntryFieldBiography,
            maxLines: 6,
          ),
          const SizedBox(height: 8),
          FileDropZone(
            title: l10n.addEntryPhotosTitle,
            hint: l10n.addEntryPhotosHint,
            browseLabel: l10n.addEntryBrowseFiles,
            changeFileLabel: l10n.addEntryFileChange,
            removeFileLabel: l10n.addEntryFileRemove,
            invalidTypeMessage: l10n.addEntryInvalidFileImage,
            kind: FileDropZoneKind.image,
            fileType: FileType.custom,
            allowedExtensions: const ['jpg', 'jpeg', 'png'],
            minHeightEmpty: 152,
          ),
        ],
      ),
    );
  }
}

class _YearRangeRow extends StatelessWidget {
  const _YearRangeRow({
    required this.l10n,
    required this.yearFrom,
    required this.yearTo,
  });

  final AppLocalizations l10n;
  final TextEditingController yearFrom;
  final TextEditingController yearTo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.addEntryFieldLifeYears,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppThemes.textColorSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  controller: yearFrom,
                  hintText: l10n.addEntryYearFrom,
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
                child: Text(
                  '—',
                  style: TextStyle(color: AppThemes.textColorGrey),
                ),
              ),
              Expanded(
                child: CustomTextFormField(
                  controller: yearTo,
                  hintText: l10n.addEntryYearTo,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.cancelLabel,
    required this.primaryLabel,
    required this.onCancel,
    required this.onPrimary,
  });

  final String cancelLabel;
  final String primaryLabel;
  final VoidCallback onCancel;
  final VoidCallback onPrimary;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            cancelLabel,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: AppThemes.textColorSecondary,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: PrimaryButton(text: primaryLabel, onPressed: onPrimary)),
      ],
    );
  }
}
