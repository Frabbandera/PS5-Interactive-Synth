# === OSC_PS5_HANDLERS.PY ===

# 1. Importazione librerie
import pygame
import time
import threading

from pythonosc.udp_client import SimpleUDPClient
from pythonosc.dispatcher import Dispatcher
from pythonosc.osc_server import BlockingOSCUDPServer

# 2. Inizializzaione pygame e rilevamento joystick
pygame.init()
pygame.joystick.init()

if pygame.joystick.get_count() == 0:
    print("❌ Nessun controller trovato")
    exit()

joystick = pygame.joystick.Joystick(0)
joystick.init()

print(f"✅ Controller collegato: {joystick.get_name()}")

time.sleep(2) 

# 3. Setup OSC (IP e porta di SuperCollider)
client = SimpleUDPClient("127.0.0.1", 12000)

# 4. Mappatura pulsanti ed assi

# 4.1 Mappatura pulsanti 
BUTTON_CROSS = 0        # Croce
BUTTON_CIRCLE = 1       # Cerchio
BUTTON_SQUARE = 2       # Quadrato
BUTTON_TRIANGLE = 3     # Triangolo
BUTTON_SHARE = 4        # Share
BUTTON_PS = 5           # PS Button
BUTTON_OPTIONS = 6      # Options
BUTTON_L3 = 7           # L3
BUTTON_R3 = 8           # R3
BUTTON_L1 = 9           # L1
BUTTON_R1 = 10          # R1
BUTTON_DPAD_UP = 11     # Freccia su
BUTTON_DPAD_DOWN = 12   # Freccia giù
BUTTON_DPAD_LEFT = 13   # Freccia sinistra
BUTTON_DPAD_RIGHT = 14  # Freccia destra
BUTTON_TOUCHPAD = 15    # Touchpad
BUTTON_MUTE = 16        # Mute

# 4.2 Mappatura assi
AXIS_LEFT_STICK_X = 0   # Stick sinistro X
AXIS_LEFT_STICK_Y = 1   # Stick sinistro Y
AXIS_RIGHT_STICK_X = 2  # Stick destro X
AXIS_RIGHT_STICK_Y = 3  # Stick destro Y
AXIS_L2 = 4             # L2
AXIS_R2 = 5             # R2

# 5. Inizializzazione parametri 
lfoFreq = 0.0
lfoDepth = 0.0
lfoDepth_step = 0.01
cutoff = 20
cutoff_step = 0.2

# 6. Inizializzazione cache 
last_lfoFreq = None
last_lfoDepth = None
last_cutoff = None
last_sendLevel1 = None
last_sendLevel2 = None
last_sendLevel3 = None
last_sendLevel4 = None

# GPT
def update_lfoFreq(addr, value):
    global lfoFreq, last_lfoFreq
    lfoFreq = max(0, min(20, value))
    last_lfoFreq = lfoFreq

def update_lfoDepth(addr, value):
    global lfoDepth, last_lfoDepth
    lfoDepth = max(0, min(1.0, value))
    last_lfoDepth = lfoDepth

def update_cutoff(addr, value):
    global cutoff, last_cutoff
    cutoff = max(0, min(20, value))
    last_cutoff = cutoff

def update_sendLevel1(addr, value):
    global sendLevel1, last_sendLevel1
    sendLevel1 = max(0, min(1, value))
    last_sendLevel1 = sendLevel1

def update_sendLevel2(addr, value):
    global sendLevel2, last_sendLevel2
    sendLevel2 = max(0, min(1, value))
    last_sendLevel2 = sendLevel2

def update_sendLevel3(addr, value):
    global sendLevel3, last_sendLevel3
    sendLevel3 = max(0, min(1, value))
    last_sendLevel3 = sendLevel3

def update_sendLevel4(addr, value):
    global sendLevel4, last_sendLevel4
    sendLevel4 = max(0, min(1, value))
    last_sendLevel4 = sendLevel4

# 7. Funzione ottimizzazione invio OSC
def send_if_changed(path, value, last_value, threshold=0.001):
    if last_value is None or abs(value - last_value) > threshold:
        client.send_message(path, value)
        return True, value 
    return False, last_value

# 8. Aggiornamento stato controller
print("🎮 Pronto. Premere PS per uscire.")
force_sync = True  # Forza sincronizzazione al primo loop

# GPT
dispatcher = Dispatcher()
dispatcher.map("/controller/lfoFreq", update_lfoFreq)
dispatcher.map("/controller/lfoDepth", update_lfoDepth)
dispatcher.map("/controller/cutoff", update_cutoff)
dispatcher.map("/controller/sendLevel1", update_sendLevel1)
dispatcher.map("/controller/sendLevel2", update_sendLevel2)
dispatcher.map("/controller/sendLevel3", update_sendLevel3)
dispatcher.map("/controller/sendLevel4", update_sendLevel4)

def start_osc_server():
    server = BlockingOSCUDPServer(("127.0.0.1", 12001), dispatcher)
    server.serve_forever()

osc_thread = threading.Thread(target=start_osc_server, daemon=True)
osc_thread.start()

while True:
    pygame.event.pump()

    updated = False  # flag per sapere se qualcosa è cambiato

    now = time.time()

    # === USCITA SICURA: PS + OPTIONS ===
    if joystick.get_button(BUTTON_PS):
        print("🛑 Combinazione di uscita rilevata. Termine script.")
        break

    # 8.1 BUTTONS

    # 8.1.1 Debounced Cutoff (Triangolo = incrementa, Freccia su = decrementa)
    if joystick.get_button(BUTTON_TRIANGLE):
        cutoff += cutoff_step
        last_cutoff_change = now
    elif joystick.get_button(BUTTON_DPAD_UP):
        cutoff -= cutoff_step
        last_cutoff_change = now
    cutoff = max(0, min(20, cutoff))
    sent, last_cutoff = send_if_changed("/controller/cutoff", cutoff, last_cutoff, threshold=0 if force_sync else 1e-6)
    if force_sync:
        force_sync = False
    updated = updated or sent
    
    # 8.1.2 Debounced lfoDepth (L1 = decrementa, R1 = incrementa)
    if joystick.get_button(BUTTON_R1):
        lfoDepth += lfoDepth_step
        last_lfoDepth_change = now
    elif joystick.get_button(BUTTON_L1):
        lfoDepth -= lfoDepth_step
        last_lfoDepth_change = now
    lfoDepth = max(0, min(1.0, lfoDepth))
    sent, last_lfoDepth = send_if_changed("/controller/lfoDepth", lfoDepth, last_lfoDepth, threshold=0 if force_sync else 1e-6)
    if force_sync:
        force_sync = False
    updated = updated or sent

    # 8.2 AXIS

    # 8.2.1 LFO Frequency (R2 - L2)
    l2 = (joystick.get_axis(AXIS_L2) + 1) / 2
    r2 = (joystick.get_axis(AXIS_R2) + 1) / 2
    delta = r2 - l2
    lfoFreq += delta * 0.5
    lfoFreq = max(0, min(20, lfoFreq))
    sent, last_lfoFreq = send_if_changed("/controller/lfoFreq", lfoFreq, last_lfoFreq)
    updated = updated or sent

    # 8.2.2 Riverbero (Stick sinistro Y)
    ly = abs(joystick.get_axis(AXIS_LEFT_STICK_Y))
    sent, last_sendLevel1 = send_if_changed("/controller/sendLevel1", ly, last_sendLevel1)
    updated = updated or sent

    # 8.2.3 Delay (Stick sinistro X) 
    lx = abs(joystick.get_axis(AXIS_LEFT_STICK_X))
    sent, last_sendLevel2 = send_if_changed("/controller/sendLevel2", lx, last_sendLevel2)
    updated = updated or sent

    # 8.2.4 Flanger (Stick destro Y)
    ry = abs(joystick.get_axis(AXIS_RIGHT_STICK_Y))
    sent, last_sendLevel3 = send_if_changed("/controller/sendLevel3", ry, last_sendLevel3)
    updated = updated or sent

    # 8.2.5 Delay (Stick destro X) 
    rx = abs(joystick.get_axis(AXIS_RIGHT_STICK_X))
    sent, last_sendLevel4 = send_if_changed("/controller/sendLevel4", rx, last_sendLevel4)
    updated = updated or sent

    if updated:
        print(f"LFO: {lfoFreq:.2f}, lfoDepth: {lfoDepth:.2f}, Cutoff: {cutoff:.2f}, Reverb: {ly:.2f}, Delay: {lx:.2f}, Flanger: {ry:.2f}, Distortion: {rx:.2f}")    # Debug Console (solo se un parametro viene modificato)

    time.sleep(0.05)
