const fs = require('fs');
const path = require('path');
const rimraf = require('rimraf');

const gitignorePath = path.join(__dirname, '..', '.gitignore');

if (!fs.existsSync(gitignorePath)) {
  console.error('.gitignore not found!');
  process.exit(1);
}

// Read all lines from .gitignore
const lines = fs
  .readFileSync(gitignorePath, 'utf8')
  .split(/\r?\n/)
  .map((line) => line.trim())
  .filter((line) => line && !line.startsWith('#')); // Remove empty lines and comments

lines.forEach((entry) => {
  rimraf(entry, (err) => {
    if (err) {
      console.error(`Failed to delete ${entry}:`, err);
    } else {
      console.log(`Deleted: ${entry}`);
    }
  });
});
