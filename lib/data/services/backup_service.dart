import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paragonik/data/services/database_service.dart';
import 'package:paragonik/data/services/l10n_service.dart';
import 'package:paragonik/data/services/notifications/notification_service.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class BackupService {
  Future<void> createAndShareBackup() async {
    try {
      final dbPath = await DatabaseService.instance.getDatabasePath();
      final appDocDir = await getApplicationDocumentsDirectory();
      final tempDir = await getTemporaryDirectory();

      final archive = Archive();

      final dbFile = File(dbPath);
      if (await dbFile.exists()) {
        final dbBytes = await dbFile.readAsBytes();
        archive.addFile(ArchiveFile('paragonik.db', dbBytes.length, dbBytes));
      } else {
        debugPrint('⚠️ UWAGA: Nie znaleziono pliku bazy danych!');
      }

      final files = appDocDir.listSync();
      int imageCount = 0;

      for (var entity in files) {
        if (entity is File) {
          final fileExtension = extension(entity.path).toLowerCase();
          if (['.jpg', '.jpeg', '.png', '.webp'].contains(fileExtension)) {
            final imageBytes = await entity.readAsBytes();
            final fileName = 'images/${basename(entity.path)}';

            archive.addFile(
              ArchiveFile(fileName, imageBytes.length, imageBytes),
            );
            imageCount++;
          }
        }
      }
      debugPrint('📸 Dodano $imageCount zdjęć do backupu.');

      final zipEncoder = ZipEncoder();
      final encodedArchive = zipEncoder.encode(archive);

      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final zipPath = '${tempDir.path}/paragonik_backup_$timestamp.zip';
      final zipFile = File(zipPath);

      await zipFile.writeAsBytes(encodedArchive);

      await SharePlus.instance.share(
        ShareParams(
          text: L10nService.l10n.servicesBackupServiceBackupShareText,
          files: [XFile(zipPath)],
          subject: L10nService.l10n.servicesBackupServiceBackupShareSubject(
            timestamp,
          ),
        ),
      );
    } catch (e) {
      NotificationService.showError('${L10nService.l10n.commonError}: $e');
      rethrow;
    }
  }

  Future<bool> restoreBackup() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );

      if (result == null || result.files.single.path == null) {
        return false;
      }

      final zipFile = File(result.files.single.path!);

      await DatabaseService.instance.close();

      final appDocDir = await getApplicationDocumentsDirectory();
      final dbPath = await DatabaseService.instance.getDatabasePath();

      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      for (final file in archive) {
        if (file.isFile) {
          final filename = file.name;

          if (filename == 'paragonik.db') {
            final data = file.content as List<int>;
            File(dbPath)
              ..createSync(recursive: true)
              ..writeAsBytesSync(data);
          } else if (filename.startsWith('images/')) {
            final localFileName = filename.replaceFirst('images/', '');
            if (localFileName.isNotEmpty) {
              final data = file.content as List<int>;
              File('${appDocDir.path}/$localFileName')
                ..createSync(recursive: true)
                ..writeAsBytesSync(data);
            }
          }
        }
      }

      return true;
    } catch (e) {
      NotificationService.showError('${L10nService.l10n.commonError}: $e');
      rethrow;
    }
  }
}
