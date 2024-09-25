import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../colors.dart';
import 'language/language_dialog.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor,
      insetPadding: EdgeInsets.zero,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width * 0.8,
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
            const SizedBox(height: 16),
            _buildSettingItem(context, Icons.language, translate('language'),
                () {
              showDialog(
                context: context,
                builder: (BuildContext context) => const LanguageDialog(),
              );
            }),
            const Divider(color: textColor),
            _buildSettingItem(context, Icons.delete, translate('clear_data'),
                () {
              // Implement clear data functionality
            }),
            const Divider(color: textColor),
            _buildSettingItem(context, Icons.info, translate('about'), () {
              // Implement about functionality
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
      BuildContext context, IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 16),
            Text(text, style: const TextStyle(color: textColor, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
