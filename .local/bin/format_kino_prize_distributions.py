#!/usr/bin/env python3
import sys
import csv
from table_formatter import format_table


def format_row(cols, is_header=False):
    """Format a single row with number formatting for columns 4, 5, 6."""
    if is_header:
        return cols

    # Keep columns 0-3 as-is
    result = cols[:4]

    # Format columns 4, 5, 6 with dot separators
    for i in [4, 5, 6]:
        if len(cols) > i and cols[i]:
            result.append(f'{float(cols[i]):,.0f}'.replace(',', '.'))
        else:
            result.append('')

    return result


def main():
    # Read and format all rows
    rows = []
    for idx, cols in enumerate(csv.reader(sys.stdin)):
        rows.append(format_row(cols, is_header=(idx == 0)))

    # Print formatted table
    print(format_table(rows))


if __name__ == '__main__':
    main()
