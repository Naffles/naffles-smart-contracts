import fs from 'fs';

export function createDir(_dirPath: string): void {
  if (!fs.existsSync(_dirPath)) {
    try {
      fs.mkdirSync(process.cwd() + _dirPath, { recursive: true });
    } catch (error) {
      console.error(`An error occurred: `, error);
    }
  }
}

export function createFile(
  filePath: string,
  fileContent: string | NodeJS.ArrayBufferView,
): void {
  try {
    fs.writeFileSync(filePath, fileContent);
  } catch (error) {
    console.error(`An error occurred: `, error);
  }
}
