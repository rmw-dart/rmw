import "dart:io";

void lock(String fp) => File(fp).openSync(mode: FileMode.write)..lockSync();
