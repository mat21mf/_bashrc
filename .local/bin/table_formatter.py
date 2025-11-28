#!/usr/bin/env python3
"""
Reusable table formatter module.
Can be used as a module or as a command-line script.
"""
import sys
import csv


def format_table(rows, align=None):
    """
    Format rows as a table with proper alignment.

    Args:
        rows: List of lists (or iterable of iterables) containing table data
        align: List of alignment characters ('l', 'r', 'c') for each column,
               or None to auto-detect (numbers right, text left)

    Returns:
        Formatted table as string
    """
    rows = list(rows)
    if not rows:
        return ""

    # Calculate column widths
    num_cols = max(len(row) for row in rows)
    widths = [0] * num_cols

    for row in rows:
        for i, cell in enumerate(row):
            widths[i] = max(widths[i], len(str(cell)))

    # Auto-detect alignment if not provided
    if align is None:
        align = []
        header = rows[0] if rows else []
        for i in range(num_cols):
            # Check if column contains numbers (skip header)
            is_numeric = True
            for row in rows[1:]:
                if i < len(row) and row[i]:
                    try:
                        # Check if it looks like a number (with possible dots/commas)
                        val = str(row[i]).replace('.', '').replace(',', '')
                        float(val)
                    except (ValueError, AttributeError):
                        is_numeric = False
                        break
            align.append('r' if is_numeric else 'l')

    # Format rows
    lines = []
    for idx, row in enumerate(rows):
        formatted_cells = []
        for i in range(num_cols):
            cell = str(row[i]) if i < len(row) else ''
            if align[i] == 'r':
                formatted_cells.append(cell.rjust(widths[i]))
            elif align[i] == 'c':
                formatted_cells.append(cell.center(widths[i]))
            else:  # 'l' or default
                formatted_cells.append(cell.ljust(widths[i]))

        lines.append('  '.join(formatted_cells))

        # Add separator after header
        if idx == 0:
            lines.append('  '.join(['-' * widths[i] for i in range(num_cols)]))

    return '\n'.join(lines)


def main():
    """Command-line interface: read CSV from stdin and print formatted table."""
    rows = list(csv.reader(sys.stdin))
    print(format_table(rows))


if __name__ == '__main__':
    main()
