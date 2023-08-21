from datetime import datetime
from functools import lru_cache
from os import makedirs
from pathlib import Path
from sys import argv
import re

DATE_PATTERN = re.compile("(\d\d\d\d)-(\d\d)-(\d\d).*")


def parse_date(line: str) -> datetime:
    m = DATE_PATTERN.match(line)
    if m:
        year = int(m.groups(1)[0])
        month = int(m.groups(1)[1])
        day = int(m.groups(1)[2])
        return datetime(year, month, day, 0, 0, 0, 0)
    return None


def compare_dates(current_date: datetime, new_date: datetime) -> datetime:
    if (
        current_date.year != new_date.year
        or current_date.month != new_date.month
        or current_date.day != new_date.day
    ):
        print(
            f"New date found: {current_date.month}/{current_date.day}/{current_date.year}, starting new file..."
        )
        return new_date
    return current_date


@lru_cache()
def create_file_name(name: str, date: datetime) -> str:
    return f"{name}-{date.year}-{date.month}-{date.day}.txt"


def split_log_file(filepath: Path, output_directory: Path) -> None:
    if not output_directory.exists():
        makedirs(output_directory)
    with open(filepath, "r") as fp:
        line = fp.readline()
        date = parse_date(line)
        output_file_path = output_directory / create_file_name(filepath.name, date)
        if not date:
            print("Could not find date in first line, exiting!")
            line = None
        while line:
            new_date = parse_date(line)
            if new_date:
                date = compare_dates(date, new_date)
                output_file_path = output_directory / create_file_name(
                    filepath.name, date
                )
            with open(output_file_path, "a+") as f:
                f.write(line)
            line = fp.readline()


if __name__ == "__main__":
    if len(argv) < 2: # first item in argv is always the script name
        raise IndexError("Insufficient arguments provided, expected 1 argument")
    logs_directory = Path(argv[1])
    files_to_split: list[Path] = [
        logs_directory / "Debug.txt",
        logs_directory / "Info.txt",
        logs_directory / "Warn.txt",
        logs_directory / "Error.txt",
    ]
    output_directory = logs_directory / "output"
    for file in files_to_split:
        print(f"Splitting {file} by date...")
        split_log_file(file, output_directory)
