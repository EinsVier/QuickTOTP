@echo off
if not exist .venv (
    python -m venv .venv
)
pip install pyotp keyboard
pyinstaller --windowed --onefile --distpath .\ quicktotp.py
quicktotp.exe
