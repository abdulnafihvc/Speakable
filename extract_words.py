import re
import json

# Read the test file
with open(r'c:\Users\Nafih\OneDrive\Documents\voicepulse\MANGLISH_TEST_EXAMPLES.md', 'r', encoding='utf-8') as f:
    content = f.read()

# Extract Input/Output pairs
pattern = r'Input: "([^"]+)"\s+Output: "([^"]+)"'
matches = re.findall(pattern, content)

# Create a dictionary of unique words
word_dict = {}
for manglish, malayalam in matches:
    # Clean up the Malayalam output (remove English translations in parentheses)
    malayalam_clean = re.sub(r'\s*\([^)]+\)', '', malayalam).strip()
    
    # Store single words and short phrases (up to 3 words)
    manglish_words = manglish.strip().split()
    malayalam_words = malayalam_clean.strip().split()
    
    # If it's a single word or short phrase, add it
    if len(manglish_words) <= 3 and len(malayalam_words) <= 3:
        key = manglish.strip().lower()
        if key not in word_dict:
            word_dict[key] = malayalam_clean

# Sort by key length (longer phrases first for better matching)
sorted_words = sorted(word_dict.items(), key=lambda x: len(x[0]), reverse=True)

print(f'Total unique entries extracted: {len(sorted_words)}')
print(f'\nGenerating Dart code for _commonWords map...\n')

# Generate Dart code
dart_entries = []
for manglish, malayalam in sorted_words:
    # Escape single quotes in strings
    manglish_escaped = manglish.replace("'", "\\'")
    malayalam_escaped = malayalam.replace("'", "\\'")
    dart_entries.append(f"    '{manglish_escaped}': '{malayalam_escaped}',")

# Write to output file
output_path = r'c:\Users\Nafih\OneDrive\Documents\voicepulse\extracted_words.txt'
with open(output_path, 'w', encoding='utf-8') as f:
    f.write('\n'.join(dart_entries))

print(f'Extracted {len(dart_entries)} word pairs')
print(f'Saved to: {output_path}')
print(f'\nFirst 20 entries:')
for entry in dart_entries[:20]:
    print(entry)
