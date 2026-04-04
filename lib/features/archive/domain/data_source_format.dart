/// Формат прикреплённого источника (файл из assets).
enum DataSourceFormat {
  pdf,
  md,
  txt;

  static DataSourceFormat parse(String raw) {
    switch (raw.toLowerCase().trim()) {
      case 'pdf':
        return DataSourceFormat.pdf;
      case 'md':
      case 'markdown':
        return DataSourceFormat.md;
      case 'txt':
      case 'text':
        return DataSourceFormat.txt;
      default:
        return DataSourceFormat.txt;
    }
  }
}
