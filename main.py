import TrackingManagement
from TrackingManagement.body import BodyThread
import time
import struct
import TrackingManagement.tracking_vars
from sys import exit
from TrackingManagement.bodyParts import MainBody
# import flet as ft
# import numpy as np
# import base64
# from io import BytesIO
# from PIL import Image as image
import websocketServer


mainBody = MainBody()
bodyThread = BodyThread()
bodyThread.start()
serverThread = websocketServer.WebsocketServerThread()
serverThread.start()
socketConnected = False


while True:
    while not socketConnected:
        socketConnected = serverThread.getConnected()
        print("connecting")
        time.sleep(1)
    # print("Nose position x: ", bodyThread.getRawBody().head.landmarks["nose"].x)
    smoothed = bodyThread.getSmoothedBody()
    serverThread.sendThis(bodyThread.getBodyMessage())
    # if (smoothed != None): print("Nose position x (smoothed): ", smoothed.head.landmarks["nose"].x)
    time.sleep(0.0333)
    # time.sleep(1)
# 
# 
    # time.sleep(15)
    # bodyThread.StartRecording(10, True)
    # print("recording...")
    # time.sleep(5)
    # record = bodyThread.StopRecording()
    # print (len(record))
# 
    # i = input()
    # print("Exiting…")        
    # TrackingManagement.tracking_vars.KILL_THREADS = True
    # time.sleep(0.5)
    # exit()


'''def main(page: ft.Page):
    page.title = "Flet prototype"
    primaryColor = "#50C5AA"
    page.theme = ft.Theme(color_scheme=ft.ColorScheme(primary=primaryColor))
    page.theme_mode = ft.ThemeMode.LIGHT
    page.window_height = 900
    page.window_width = 1600
    page.window_resizable = False
    page.bgcolor = "#50C5AA"

    # txt_number = ft.TextField(value="0", text_align=ft.TextAlign.RIGHT, width=100, color=ft.colors.CYAN_200)
# 
    # def minus_click(e):
        # txt_number.value = str(int(txt_number.value) - 1)
        # UpdateView()
        # page.update()
# 
    # def plus_click(e):
        # txt_number.value = str(int(txt_number.value) + 1)
        # page.update()
    
    view = ft.Image(src="test1.png")
    def UpdateView():
        imagePath = view.src
        pilImage = image.open(imagePath)
        arr = np.asarray(pilImage)
        pilImage = image.fromarray(arr)
        buff = BytesIO()
        pilImage.save(buff, format="PNG")
        view.src_base64 = base64.b64encode(buff.getvalue()).decode("utf-8")
        view.update()

    border=ft.border.all(1, ft.colors.BLACK)

    page.add(
        ft.Container(
            ft.Column(
                [
                    # ft.Container(
                    #     ft.Row(
                    #         [
                    #             ft.IconButton(ft.icons.REMOVE, on_click=minus_click),
                    #             txt_number,
                    #             ft.IconButton(ft.icons.ADD, on_click=plus_click)
                    #         ],
                    #         alignment=ft.MainAxisAlignment.CENTER
                    #     )
                    # ),
                    ft.Row(
                        [
                            ft.Container(
                                width=1000, height=830, bgcolor=ft.colors.WHITE, border_radius=10,
                                         content= view, alignment=ft.alignment.center),
                            ft.Column(
                                [
                                    ft.IconButton(ft.icons.MENU, bgcolor="#77F2D7"),
                                    ft.IconButton(ft.icons.PAUSE, bgcolor="#77F2D7"),
                                    ft.IconButton(ft.icons.STOP, bgcolor="#77F2D7"),
                                ],
                                width=40
                            ),
                            ft.Container(width=480, height=830, bgcolor=ft.colors.WHITE, border_radius=10,
                                         content=ft.Tooltip(message="Analysis information here", content=ft.Text("Analysis information here")), alignment=ft.alignment.center,)
                        ]
                    )
                ]
            ),
            margin=10
        )
    )

    


ft.app(target=main)'''