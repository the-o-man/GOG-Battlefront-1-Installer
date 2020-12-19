# hello_psg.py

import PySimpleGUI as sg

layout = [[sg.Text("Welcome to the unofficial BattleFront I installer for PopOS")], [sg.Button("Continue")]]

# Create the window
window = sg.Window("Installer", layout)

# Create an event loop
continue_flag = False
while True:
    event, values = window.read()
    # End program if user closes window or
    # presses the OK button
    if event == "Continue":
        continue_flag = True
        break
    elif event == sg.WIN_CLOSED:
        break

window.close()

if continue_flag:

    # Move to next window
    layout1 = [[sg.Text("Test 1 window")], [sg.Button("Continue")]]

    # Create the window
    window1 = sg.Window("Step 1", layout)

    # Create an event loop
    while True:
        event, values = window.read()
        # End program if user closes window or
        # presses the OK button
        if event == "Continue" or event == sg.WIN_CLOSED:
            continue_flag = True
            break

    window1.close()
else:
    exit(0)
