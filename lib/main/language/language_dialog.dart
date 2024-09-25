import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import '../../colors.dart';
import 'bloc/language_bloc.dart';
import 'bloc/language_event.dart';
import 'bloc/language_state.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return Dialog(
          backgroundColor: backgroundColor,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: iconColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                _buildLanguageOption(
                    context, 'English', 'en', state.languageCode),
                _buildLanguageOption(context, '中文', 'zh', state.languageCode),
                _buildLanguageOption(context, '日本語', 'ja', state.languageCode),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(BuildContext context, String label,
      String languageCode, String currentLanguageCode) {
    return CheckboxListTile(
      title: Text(label, style: const TextStyle(color: textColor)),
      value: currentLanguageCode == languageCode,
      onChanged: (bool? value) {
        if (value == true) {
          context.read<LanguageBloc>().add(ChangeLanguage(languageCode));
          Navigator.of(context).pop();
          Phoenix.rebirth(context);
        }
      },
      checkColor: backgroundColor,
      activeColor: textColor,
    );
  }
}
