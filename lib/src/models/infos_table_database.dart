class InfosTableDatabase {
  final String tableName;
  final Map<String, String> columns;
  final String primaryKey;

  InfosTableDatabase({
    required this.tableName,
    required this.columns,
    this.primaryKey = "Id",
  });

  String get createTable {
    final columnsString = columns.entries.map((e) => '${e.key} ${e.value}').toList().join(', ');

    return 'CREATE TABLE $tableName ($columnsString)';
  }
}
