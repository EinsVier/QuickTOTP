# QuickTOTP
Du bist ein Softwareentwickler und erstellst ein Programm in Python mit folgenden Kreterien.
Den Phyton-Code schreibs du nicht nur so hin, sondern so das es für jeden Programmierer eine Freude ist, den Code zu lesen.
Es macht dir Spass guten funktionierenden, sicheren Code zu schreiben.
Du erstellst eine kleine GUI-Anwendung mit den Namen **QuickTOTP**, wobei du Tkinter verwendest.
Nachfolgend die Beschreibung der App:

## 1. TOTP-Code-Anzeige
- Der TOTP-Code wird alle X Sekunden automatisch aktualisiert.
- Der Code sollte farblich hervorgehoben werden: **grün**, wenn mehr als 7 Sekunden verbleiben, und **gelb**, wenn weniger als 7 Sekunden übrig sind.

## 2. Countdown und Hotkey-Hinweis
- Unter dem TOTP-Code soll ein Countdown angezeigt werden, der die verbleibenden Sekunden zeigt.
- Zusätzlich soll ein Hinweis auf einen Hotkey dargestellt werden, der den TOTP-Code direkt in eine Anwendung einfügt.
- Der Hinweistext soll mehrzeilig sein, falls der Text zu lang ist, damit nichts abgeschnitten wird.

## 3. Layout und Lesbarkeit
- Das Layout soll zentriert und aufgeräumt sein, und die Schriftarten und Abstände angenehm lesbar.

## 4. Konfiguration über JSON-Datei
- Die Konfigurationswerte wie **SECRET**, **HOTKEY** und der Hinweistext sollen nicht im Code stehen, sondern aus einer separaten **config.json**-Datei geladen werden.
- Die App soll beim Start die Werte aus dieser Datei übernehmen.
- Falls die **config.json** fehlt oder ungültig ist, möchten wir eine Fehlermeldung in einem Popup anzeigen und das Programm sauber beenden.
Hier ist ein Beispiel einer config.json:
{
    "SECRET": "OKHT65GDHIKCDSJ64V00HGKLDEN89MFD",
    "HOTKEY": "Strg+Alt+t",
    "HINT_TEXT": "Drücken Sie {HOTKEY}, um den TOTP-Code direkt in Ihre Anwendung einzufügen."
}

## 5. Verwendung von UTF-8-Codierung
- Wir möchten sicherstellen, dass die Konfigurationsdatei im **UTF-8**-Format geladen wird, um eine korrekte Darstellung von Sonderzeichen zu gewährleisten.

## 6. Fehlerbehandlung
- Falls weitere Fehlerbehandlungen sinnvoll sind (z. B. für ungültige Eingaben oder unerwartete Situationen), sollen diese ebenfalls beachtet und entsprechend implementiert werden.

## 7. Umwandlung in eine .exe Datei
- Wenn du das Programm mit PyInstaller in eine .exe umwandle, verwende du die Option --windowed,
damit kein Konsolenfenster erscheint. In diesem Fall wird bei fehlender oder fehlerhafter config.json ein Fehlermeldungs-Popup angezeigt,
da keine Konsole verfügbar ist, um den Fehler anzuzeigen.
