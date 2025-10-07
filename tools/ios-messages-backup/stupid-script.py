"""you should delete this"""

#!/usr/bin/env -S uv run python
import os
from pathlib import Path
import sqlite3
import shutil


def _existing_hashed_path(backup_root: Path, file_id: str) -> Path:
    """Map a fileID (40-hex) to its on-disk path in the backup."""
    p = backup_root / file_id[:2] / file_id
    if p.exists():
        return p
    # Some tools/backups may not use the 2-char subdir; fall back.
    p = backup_root / file_id
    if p.exists():
        return p
    raise FileNotFoundError(file_id)


def _open_manifest(backup_root: Path) -> sqlite3.Connection:
    return sqlite3.connect(backup_root / "Manifest.db")


def _get_messages_db_path(backup_root: Path) -> Path:
    with _open_manifest(backup_root) as conn:
        row = conn.execute(
            """
            SELECT fileID, relativePath
            FROM Files
            WHERE relativePath LIKE '%/SMS/sms.db%' OR relativePath LIKE '%/Messages/chat.db%';
        """
        ).fetchone()
        if not row:
            raise FileNotFoundError("Could not find sms.db or chat.db in Manifest.db")
        file_id, relative_path = row
    msg_db = _existing_hashed_path(backup_root, file_id)
    print(f"found file id for {relative_path}: {file_id}")
    return msg_db


def _symlink_attachments(backup_root: Path, out_root: Path) -> int:
    """
    Create symlinks for all SMS/iMessage attachments into out_root,
    preserving the iOS substructure under 'Attachments/'.
    Returns count of links created.
    """
    out_root.mkdir(parents=True, exist_ok=True)
    created = 0
    with _open_manifest(backup_root) as conn:
        # All attachments live under Library/SMS/Attachments/... on device.
        for file_id, relative_path in conn.execute(
            """
            SELECT fileID, relativePath
            FROM Files
            WHERE relativePath LIKE 'Library/SMS/Attachments/%';
        """
        ):
            try:
                src = _existing_hashed_path(backup_root, file_id)
            except FileNotFoundError:
                print(f"didn't find {relative_path}")
                continue

            rel_path = Path(relative_path)
            # Mirror only the subtree *under* Attachments/
            try:
                i = rel_path.parts.index("Attachments")
                suffix = Path(*rel_path.parts[i + 1 :])  # e.g., 0f/15/IMG_1234.JPG
            except ValueError:
                # Unexpected, but fall back to filename
                suffix = Path(rel_path.name)

            dest = out_root / suffix
            dest.parent.mkdir(parents=True, exist_ok=True)

            # If it already exists and points to the right src, skip; otherwise replace.
            if dest.is_symlink():
                try:
                    if Path(os.readlink(dest)) == src:
                        continue
                    dest.unlink()
                except OSError:
                    dest.unlink(missing_ok=True)
            elif dest.exists():
                # If you prefer to keep existing exports, continue; otherwise replace.
                dest.unlink()

            os.symlink(src, dest)
            created += 1
    return created


def main(copy_to: Path):
    device_backup_root = Path(os.environ["DEVICE_BACKUP_DIR"])
    messages_db_path = _get_messages_db_path(device_backup_root)
    print(f"db path = '{messages_db_path}'")

    export_dir = copy_to.parent
    export_dir.mkdir(exist_ok=True, parents=True)
    shutil.copy2(messages_db_path, copy_to)
    print(f"copied to '{copy_to}'")

    symlinked_count = _symlink_attachments(device_backup_root, export_dir / "attachments")
    print(f"symlinked {symlinked_count} attachments")

    print(
        f"""command would be something like

imessage-exporter \\
    --format html \\
    --db-path {copy_to} \\
    --attachment-root {export_dir / 'attachments'} \\
    --export-path {export_dir / 'export'} \\
    --copy-method clone
"""
    )


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("copy_to", type=Path)
    args = parser.parse_args()

    main(args.copy_to)
