import serial
import sys

# Define scan code to character mapping
SCAN_CODE_MAP = {
    '0E': '`', '16': '1', '1E': '2', '26': '3', '25': '4', '2E': '5', '36': '6', '3D': '7', '3E': '8', '46': '9', '45': '0', '4E': '-', '55': '=', '66': '\b',
    '0D': '\t', '15': 'q', '1D': 'w', '24': 'e', '2D': 'r', '2C': 't', '35': 'y', '3C': 'u', '43': 'i', '44': 'o', '4D': 'p', '54': '[', '5B': ']', '5D': '\\',
    '1C': 'a', '1B': 's', '23': 'd', '2B': 'f', '34': 'g', '33': 'h', '3B': 'j', '42': 'k', '4B': 'l', '4C': ';', '5A': '\n',
    '1Z': 'z', '22': 'x', '21': 'c', '2A': 'v', '32': 'b', '31': 'n', '3A': 'm', '41': ',', '49': '.', '4A': '/',
    '29': ' '
}

SHIFT_MAP = {
    '1': '!', '2': '@', '3': '#', '4': '$', '5': '%',
    '6': '^', '7': '&', '8': '*', '9': '(', '0': ')',
    '`': '~', '-': '_', '=': '+', '[': '{', ']': '}', '\\': '|',
    ';': ':', ',': '<', '.': '>', '/': '?',
    'q': 'Q', 'w': 'W', 'e': 'E', 'r': 'R', 't': 'T',
    'y': 'Y', 'u': 'U', 'i': 'I', 'o': 'O', 'p': 'P',
    'a': 'A', 's': 'S', 'd': 'D', 'f': 'F', 'g': 'G',
    'h': 'H', 'j': 'J', 'k': 'K', 'l': 'L',
    'z': 'Z', 'x': 'X', 'c': 'C', 'v': 'V', 'b': 'B',
    'n': 'N', 'm': 'M', ' ': ' '
}

ser = serial.Serial('COM10', 9600)

shift_pressed = False
last_char = ""  # Store the last character for handling backspace

try:
    while True:
        ser_obj = ser.readline()
        scan_code = ser_obj.decode().strip().upper()

        if scan_code[0:2] == "12" or scan_code[0:2] == "59":
            shift_pressed = True
            continue

        if scan_code[0:2] == "F0":
            if scan_code[3:5] == "12" or scan_code[3:5] == "59":
                shift_pressed = False
            continue

        if scan_code[0:2] in SCAN_CODE_MAP:
            character = SCAN_CODE_MAP[scan_code[0:2]]
            if shift_pressed:
                character = SHIFT_MAP.get(character, character)

            if character == '\b':  # Backspace handling
                print('\b \b', end="", flush=True)  # Move cursor back and overwrite with space
                last_char = ""
            else:
                print(character, end="", flush=True)
                last_char = character

except KeyboardInterrupt:
    print("\nProgram interrupted by user. Exiting...")
    sys.exit(0)
