
# QuickTOTP - Python GUI Anwendung

## Beschreibung der Anwendung

Eine kleine GUI-Anwendung namens **QuickTOTP** zur Anzeige eines TOTP-Codes, die mit Tkinter erstellt wurde. Die Anwendung bietet folgende Funktionen:

1. **TOTP-Code-Anzeige**:
   - Der TOTP-Code wird alle X Sekunden automatisch aktualisiert.
   - Farbige Hervorhebung des Codes: **grün**, wenn mehr als 7 Sekunden verbleiben, und **gelb**, wenn weniger als 7 Sekunden übrig sind.

2. **Countdown und Hotkey-Hinweis**:
   - Ein Countdown unter dem TOTP-Code zeigt die verbleibenden Sekunden an.
   - Ein Hinweistext zeigt einen Hotkey an, mit dem der TOTP-Code direkt in eine andere Anwendung eingefügt werden kann.

3. **Layout und Lesbarkeit**:
   - Das Layout ist zentriert und die Schriftarten sowie Abstände sorgen für gute Lesbarkeit.

4. **Konfiguration über JSON-Datei**:
   - Konfigurationswerte wie **SECRET**, **HOTKEY** und der Hinweistext werden aus einer separaten **config.json**-Datei geladen.

5. **Fehlerbehandlung**:
   - Falls die **config.json** fehlt oder ungültig ist, wird eine Fehlermeldung in einem Popup angezeigt und das Programm sauber beendet.

6. **UTF-8 Codierung**:
   - Die Konfigurationsdatei wird mit **UTF-8** geladen, um die korrekte Darstellung von Sonderzeichen zu gewährleisten.

## Beispiel `config.json` Datei

```json
{
    "SECRET": "OKHT65GDHIKCDSJ64V00HGKLDEN89MFD",
    "HOTKEY": "ctrl+alt+t",
    "HINT_TEXT": "Drücken Sie {HOTKEY}, um den TOTP-Code direkt in Ihre Anwendung einzufügen."
}
```

## Python Code

```python
import tkinter as tk
from tkinter import messagebox
import pyotp
import json
import os
import sys
import time
import keyboard


def load_config():
    """
    Lädt die Konfigurationsdatei und gibt ein Konfigurationsdokument zurück.
    Beendet das Programm mit einer Fehlermeldung, falls die Datei nicht gefunden wird
    oder ungültig ist.
    """
    config_path = 'config.json'
    if not os.path.exists(config_path):
        raise FileNotFoundError(f"Die Konfigurationsdatei '{config_path}' wurde nicht gefunden.")

    try:
        with open(config_path, 'r', encoding='utf-8') as f:
            config = json.load(f)
    except json.JSONDecodeError as e:
        raise ValueError(f"Fehler beim Lesen der Konfigurationsdatei: {e}")

    # Überprüfen, ob alle erforderlichen Schlüssel vorhanden sind
    required_keys = ['SECRET', 'HOTKEY', 'HINT_TEXT']
    for key in required_keys:
        if key not in config:
            raise KeyError(f"Der Schlüssel '{key}' fehlt in der Konfigurationsdatei.")

    return config


class QuickTOTPApp:
    def __init__(self, root, config):
        self.root = root
        self.config = config

        self.secret = config['SECRET']
        self.hotkey = config['HOTKEY']
        self.hint_text = config['HINT_TEXT'].replace('{HOTKEY}', self.hotkey)

        self.totp = pyotp.TOTP(self.secret)
        self.time_interval = self.totp.interval  # Standardmäßig 30 Sekunden

        self.create_widgets()
        self.update_totp()

        # Registriere den Hotkey
        try:
            keyboard.add_hotkey(self.hotkey, self.insert_totp_code)
        except Exception as e:
            messagebox.showerror(
                "Fehler", f"Der Hotkey '{self.hotkey}' konnte nicht registriert werden.\n{e}")

    def create_widgets(self):
        """Erstellt die GUI-Elemente."""
        self.root.title("QuickTOTP")
        self.root.geometry("300x200")
        self.root.resizable(False, False)

        self.frame = tk.Frame(self.root)
        self.frame.pack(expand=True)

        self.code_label = tk.Label(self.frame, text="", font=("Helvetica", 24), pady=10)
        self.code_label.pack()

        self.countdown_label = tk.Label(self.frame, text="", font=("Helvetica", 14))
        self.countdown_label.pack()

        self.hint_label = tk.Label(self.frame, text=self.hint_text, font=("Helvetica", 10),
                                   wraplength=280, justify="center", pady=10)
        self.hint_label.pack()

    def update_totp(self):
        """Aktualisiert den TOTP-Code und den Countdown."""
        current_code = self.totp.now()
        time_remaining = self.totp.interval - int(time.time()) % self.totp.interval

        # Aktualisiere den Code
        self.code_label.config(text=current_code)

        # Ändere die Farbe basierend auf der verbleibenden Zeit
        if time_remaining > 7:
            self.code_label.config(fg="green")
        else:
            self.code_label.config(fg="yellow")

        # Aktualisiere den Countdown
        self.countdown_label.config(text=f"Verbleibende Zeit: {time_remaining}s")

        # Plane die nächste Aktualisierung
        self.root.after(1000, self.update_totp)

    def insert_totp_code(self):
        """Fügt den aktuellen TOTP-Code in die aktive Anwendung ein."""
        current_code = self.totp.now()
        keyboard.write(current_code)

    def on_closing(self):
        """Bereinigt Ressourcen beim Schließen der Anwendung."""
        keyboard.remove_hotkey(self.hotkey)
        self.root.destroy()


def main():
    try:
        config = load_config()
    except Exception as e:
        # Zeige eine Fehlermeldung an und beende das Programm
        root = tk.Tk()
        root.withdraw()
        messagebox.showerror("Fehler", str(e))
        sys.exit(1)

    root = tk.Tk()
    app = QuickTOTPApp(root, config)
    root.protocol("WM_DELETE_WINDOW", app.on_closing)
    root.mainloop()


if __name__ == "__main__":
    main()
```

## EXE-Erstellung

Um das Programm in eine `.exe`-Datei umzuwandeln, verwenden Sie PyInstaller mit der `--windowed`-Option, um sicherzustellen, dass kein Konsolenfenster angezeigt wird:

```bash
pyinstaller --windowed --onefile your_script.py
```

Stellen Sie sicher, dass die Python-Abhängigkeiten installiert sind:

```bash
pip install pyotp keyboard
```

