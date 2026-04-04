import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:project_temp/components/components.dart';
import 'package:project_temp/l10n/app_localizations.dart';

/// Поля ручного ввода / правки записи (как на вкладке «вручную» на [AddEntryPage]).
class AddEntryManualFormBody extends StatelessWidget {
  const AddEntryManualFormBody({
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
    required this.onPhotoChanged,
    this.showPhotoDropZone = true,
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
  final ValueChanged<List<XFile>> onPhotoChanged;
  final bool showPhotoDropZone;

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
                    YearRangeFormRow(
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
          if (showPhotoDropZone) ...[
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
              onFilesChanged: onPhotoChanged,
            ),
          ],
        ],
      ),
    );
  }
}
