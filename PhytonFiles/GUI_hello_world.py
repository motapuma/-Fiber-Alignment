from Tkinter import *
print "This line will be printed. :D"

rootBlankWindow = Tk()
#label = Label(rootBlankWindow, text = "Fourier Alignment Orientation Test")
#label.pack()

# topFrame = Frame(rootBlankWindow)
# topFrame.pack()

# bottomFrame = Frame(rootBlankWindow)
# bottomFrame.pack(side = BOTTOM)

# button1 = Button(topFrame,text = "clik1", fg="red")
# button2 = Button(topFrame,text = "clik2", fg="green")
# button3 = Button(topFrame,text = "clik3", fg="blue")
# button4 = Button(bottomFrame,text = "clik4", fg="yellow")


# button1.pack(side=LEFT)
# button2.pack(side=LEFT)
# button3.pack(side=LEFT)
# button4.pack()



one = Label(rootBlankWindow, text="One", bg="red",fg="white")
one.pack()
two = Label(rootBlankWindow, text="two", bg="green",fg="white")
two.pack(fill=X)

three = Label(rootBlankWindow, text="two", bg="blue",fg="white")
three.pack(fill=Y, side = LEFT)


rootBlankWindow.mainloop()



