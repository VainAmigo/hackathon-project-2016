import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:project_temp/core/core.dart';

bool _voiceInputSupported() =>
    kIsWeb || defaultTargetPlatform == TargetPlatform.android;

String? _localeIdForSpeech(BuildContext context) {
  final locale = Localizations.localeOf(context);
  final cc = locale.countryCode;
  if (cc != null && cc.isNotEmpty) {
    return '${locale.languageCode}_$cc';
  }
  return locale.languageCode;
}

/// Нижняя панель ввода вопроса, отправки и голосового ввода (Android и Web).
class ChatComposerBar extends StatefulWidget {
  const ChatComposerBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSend,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String hintText;
  final VoidCallback onSend;
  final bool enabled;

  @override
  State<ChatComposerBar> createState() => _ChatComposerBarState();
}

class _ChatComposerBarState extends State<ChatComposerBar> {
  final SpeechToText _speech = SpeechToText();
  bool _speechTriedInit = false;
  bool _speechReady = false;
  bool _listening = false;

  @override
  void didUpdateWidget(covariant ChatComposerBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled && oldWidget.enabled && _speech.isListening) {
      _speech.stop();
      if (mounted) setState(() => _listening = false);
    }
  }

  @override
  void dispose() {
    if (_speech.isListening) {
      _speech.stop();
    }
    super.dispose();
  }

  void _onSpeechStatus(String status) {
    if (!mounted) return;
    final on = status == SpeechToText.listeningStatus;
    setState(() => _listening = on);
  }

  void _onSpeechError(SpeechRecognitionError error) {
    if (!mounted) return;
    setState(() => _listening = false);
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(
      SnackBar(content: Text(error.errorMsg)),
    );
  }

  Future<void> _ensureSpeechReady() async {
    if (_speechTriedInit) return;
    _speechTriedInit = true;
    try {
      _speechReady = await _speech.initialize(
        onError: _onSpeechError,
        onStatus: _onSpeechStatus,
        debugLogging: kDebugMode,
      );
    } on Object catch (_) {
      _speechReady = false;
    }
    if (mounted) setState(() {});
  }

  Future<void> _toggleVoiceInput() async {
    if (!widget.enabled || !_voiceInputSupported()) return;

    await _ensureSpeechReady();
    if (!mounted) return;

    if (!_speechReady) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(content: Text(context.l10n.chatVoiceUnavailable)),
      );
      return;
    }

    if (_speech.isListening) {
      await _speech.stop();
      if (mounted) setState(() => _listening = false);
      return;
    }

    try {
      await _speech.listen(
        onResult: (result) {
          if (!mounted) return;
          widget.controller.text = result.recognizedWords;
          widget.controller.selection = TextSelection.collapsed(
            offset: widget.controller.text.length,
          );
          setState(() {});
        },
        listenFor: const Duration(minutes: 2),
        pauseFor: const Duration(seconds: 5),
        localeId: _localeIdForSpeech(context),
        listenOptions: SpeechListenOptions(
          partialResults: true,
          cancelOnError: true,
          listenMode: ListenMode.dictation,
        ),
      );
      if (mounted) setState(() => _listening = _speech.isListening);
    } on Object catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final showMic = _voiceInputSupported();

    return Material(
      color: AppThemes.surfaceColor,
      elevation: 0,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  enabled: widget.enabled,
                  minLines: 1,
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    filled: true,
                    fillColor: AppThemes.backgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                        color: AppThemes.textColorGrey.withValues(alpha: 0.35),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                        color: AppThemes.textColorGrey.withValues(alpha: 0.35),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(
                        color: AppThemes.accentColor,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppThemes.textColorPrimary,
                      ),
                ),
              ),
              if (showMic) ...[
                const SizedBox(width: 4),
                IconButton(
                  onPressed: widget.enabled ? _toggleVoiceInput : null,
                  tooltip: _listening
                      ? l10n.chatVoiceStopTooltip
                      : l10n.chatVoiceInputTooltip,
                  icon: Icon(
                    _listening ? Icons.mic_rounded : Icons.mic_none_rounded,
                    color: _listening
                        ? AppThemes.accentColor
                        : AppThemes.textColorSecondary,
                  ),
                ),
              ],
              const SizedBox(width: 4),
              IconButton.filled(
                onPressed: widget.enabled ? widget.onSend : null,
                style: IconButton.styleFrom(
                  backgroundColor: AppThemes.accentColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      AppThemes.textColorGrey.withValues(alpha: 0.25),
                ),
                icon: const Icon(Icons.send_rounded, size: 22),
                tooltip: l10n.chatSendTooltip,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
