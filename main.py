import json
import sys
import os

def main(args=None):
    with open('export_paranoid.json', 'w', encoding='utf-8') as f:
        # Human Readable JSON
        json.dump(merged, f, ensure_ascii=False, indent=4, sort_keys=True)



if __name__ == '__main__':
    # execute only if run as the entry point into the program
    main()
