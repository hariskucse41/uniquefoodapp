import re
import os

def remove_const(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Remove `const ` before [A-Z]
    # Be careful not to replace `const ` variable definitions, e.g. `const int x = 5;`
    # Also `const List<String> x` -> `List<String> x`
    # It's safest to just remove `const ` before a Class Constructor `const ClassName(`
    new_content = re.sub(r'\bconst\s+([A-Z]\w*(?:<[^>]+>)?\()', r'\1', content)
    # Remove const before Lists and Maps `const [` or `const {`
    new_content = re.sub(r'\bconst\s+([\[\{])', r'\1', new_content)

    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Removed const in: {filepath}")

def process_directory(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):
                remove_const(os.path.join(root, file))

if __name__ == '__main__':
    base_dir = r"e:\RestaurantManagement\uniquefoodapp\lib"
    process_directory(base_dir)
