import re
import os
import sys

def convert_to_screenutil(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content
    
    # Check if needs import
    if 'package:flutter_screenutil/flutter_screenutil.dart' not in content:
        # Add import after other flutter imports
        content = re.sub(
            r"(import 'package:flutter/material\.dart';)",
            r"\1\nimport 'package:flutter_screenutil/flutter_screenutil.dart';",
            content
        )

    # Simple transformations
    # SizedBox(height: X)
    content = re.sub(r'SizedBox\(\s*height:\s*([\d\.]+)\s*\)', r'SizedBox(height: \1.h)', content)
    # SizedBox(width: X)
    content = re.sub(r'SizedBox\(\s*width:\s*([\d\.]+)\s*\)', r'SizedBox(width: \1.w)', content)
    
    # height: X
    content = re.sub(r'(?<!SizedBox\()(?<!Container\()height:\s*([\d\.]+)(?![\.a-zA-Z])', r'height: \1.h', content)
    # Be careful with double.infinity
    content = content.replace('.h.h', '.h')
    
    # width: 
    content = re.sub(r'(?<!SizedBox\()(?<!Container\()width:\s*([\d\.]+)(?![\.a-zA-Z])', r'width: \1.w', content)
    content = content.replace('.w.w', '.w')
    
    # Container height and width overrides (they can be both)
    # A bit hard to regex without being destructive. I'll just run a general replacement for specific properties:
    
    props_to_replace = [
        (r'(\bheight\b\s*:\s*)([0-9]+(?:\.[0-9]+)?)(?![\w\.])', r'\1\2.h'),
        (r'(\bwidth\b\s*:\s*)([0-9]+(?:\.[0-9]+)?)(?![\w\.])', r'\1\2.w'),
        (r'(\bfontSize\b\s*:\s*)([0-9]+(?:\.[0-9]+)?)(?![\w\.])', r'\1\2.sp'),
        (r'(\biconSize\b\s*:\s*)([0-9]+(?:\.[0-9]+)?)(?![\w\.])', r'\1\2.sp'),
        (r'(?<=size:\s)([0-9]+(?:\.[0-9]+)?)(?![\w\.])', r'\1.sp'),
        (r'(?<=radius:\s)([0-9]+(?:\.[0-9]+)?)(?![\w\.])', r'\1.r'),
        (r'(?<=blurRadius:\s)([0-9]+(?:\.[0-9]+)?)(?![\w\.])', r'\1.r'),
    ]
    
    for pattern, repl in props_to_replace:
        content = re.sub(pattern, repl, content)

    # BorderRadius.circular(X)
    content = re.sub(r'Radius\.circular\(\s*([0-9]+(?:\.[0-9]+)?)\s*\)', r'Radius.circular(\1.r)', content)

    # Edge insets
    content = re.sub(r'EdgeInsets\.all\(\s*([0-9]+(?:\.[0-9]+)?)\s*\)', r'EdgeInsets.all(\1.w)', content)
    content = re.sub(r'EdgeInsets\.symmetric\(\s*(?:horizontal|vertical):\s*([0-9]+(?:\.[0-9]+)?)\s*\)', r'EdgeInsets.symmetric(horizontal: \1.w, vertical: \1.h)', content)
    # Actually symmetric can have only horizontal or only vertical, or both.
    
    def symmetric_replacer(match):
        inner = match.group(1)
        h = re.search(r'horizontal:\s*([0-9]+(?:\.[0-9]+)?)', inner)
        v = re.search(r'vertical:\s*([0-9]+(?:\.[0-9]+)?)', inner)
        
        args = []
        if h: args.append(f'horizontal: {h.group(1)}.w')
        if v: args.append(f'vertical: {v.group(1)}.h')
        return 'EdgeInsets.symmetric(' + ', '.join(args) + ')'
        
    content = re.sub(r'EdgeInsets\.symmetric\(([^)]+)\)', symmetric_replacer, content)

    # fromLTRB
    def ltrb_replacer(match):
        a = [x.strip() for x in match.group(1).split(',')]
        if len(a) == 4:
            return f'EdgeInsets.fromLTRB({a[0]}.w, {a[1]}.h, {a[2]}.w, {a[3]}.h)'
        return match.group(0)
    content = re.sub(r'EdgeInsets\.fromLTRB\(([^)]+)\)', ltrb_replacer, content)

    # only
    def only_replacer(match):
        inner = match.group(1)
        args_str = []
        for p in ['top', 'bottom', 'left', 'right']:
            m = re.search(rf'{p}:\s*([0-9]+(?:\.[0-9]+)?)', inner)
            if m:
                suffix = '.h' if p in ['top', 'bottom'] else '.w'
                args_str.append(f'{p}: {m.group(1)}{suffix}')
        if args_str:
            return 'EdgeInsets.only(' + ', '.join(args_str) + ')'
        return match.group(0)
    
    content = re.sub(r'EdgeInsets\.only\(([^)]+)\)', only_replacer, content)

    # Remove duplicates like .h.h, .w.w, .sp.sp, .r.r
    content = content.replace('.h.h', '.h')
    content = content.replace('.w.w', '.w')
    content = content.replace('.sp.sp', '.sp')
    content = content.replace('.r.r', '.r')

    # Remove screenutil from double.infinity
    content = content.replace('double.infinity.h', 'double.infinity')
    content = content.replace('double.infinity.w', 'double.infinity')
    content = content.replace('mainAxisSpacing: 12.h', 'mainAxisSpacing: 12.0')
    content = content.replace('crossAxisSpacing: 12.h', 'crossAxisSpacing: 12.0')
    content = content.replace('mainAxisSpacing: 12.w', 'mainAxisSpacing: 12.0')
    content = content.replace('crossAxisSpacing: 12.w', 'crossAxisSpacing: 12.0')

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
        
    print(f"Processed: {filepath}")

def process_directory(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):
                convert_to_screenutil(os.path.join(root, file))

if __name__ == '__main__':
    base_dir = r"e:\RestaurantManagement\uniquefoodapp\lib"
    process_directory(base_dir)
