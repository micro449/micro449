DeclareModule SchematicDrawer
EndDeclareModule
Enumeration
  #WIN_Main
  #CANVAS_Drawing
  #BUTTON_Line
  #BUTTON_Symbol
  #BUTTON_Pointer
  #BUTTON_Delete
  #COMBO_Color
  #COMBO_LineWidth
  #LIST_Symbols
  #TEXT_Status
  #MENU_File
  #MENU_Edit
  #MENU_View
  #MENU_Symbols
  #MENU_Tools
  #MENU_Help
EndEnumeration
Enumeration 100
  #MENU_File_New
  #MENU_File_Open
  #MENU_File_Save
  #MENU_File_SaveAs
  #MENU_File_Export
  #MENU_File_Exit
  #MENU_Edit_Undo
  #MENU_Edit_Redo
  #MENU_Edit_Cut
  #MENU_Edit_Copy
  #MENU_Edit_Paste
  #MENU_Edit_Delete
  #MENU_Edit_SelectAll
  #MENU_View_ZoomIn
  #MENU_View_ZoomOut
  #MENU_View_ZoomFit
  #MENU_Symbols_New
  #MENU_Symbols_Import
  #MENU_Symbols_Edit
  #MENU_Symbols_Delete
  #MENU_Symbols_Manage
  #MENU_Tools_Properties
  #MENU_Tools_SnapGrid
  #MENU_Help_About
EndEnumeration
Enumeration
  #TOOL_Pointer
  #TOOL_Line
  #TOOL_Symbol
  #TOOL_Delete
EndEnumeration
Enumeration
  #SYMBOL_PowerSupply
  #SYMBOL_Earth
  #SYMBOL_GND
  #SYMBOL_Resistor
  #SYMBOL_Capacitor
  #SYMBOL_Inductor
  #SYMBOL_Diode
  #SYMBOL_Custom
EndEnumeration
Enumeration
  #LINE_Solid = 0
  #LINE_Dashed = 1
  #LINE_Dotted = 2
EndEnumeration
#WINDOW_WIDTH = 1200
#WINDOW_HEIGHT = 800
#TOOLBAR_HEIGHT = 40
#STATUS_BAR_HEIGHT = 20
#SIDEBAR_WIDTH = 250
Structure Point
  x.f
  y.f
EndStructure
Structure Line
  p1.Point
  p2.Point
  color.i
  width.i
  style.i
  selected.i
EndStructure
Structure Symbol
  x.f
  y.f
  width.f
  height.f
  type.i
  rotation.f
  color.i
  label.s
  image.i
  selected.i
  locked.i
EndStructure
Structure SymbolLibraryEntry
  name.s
  type.i
  width.f
  height.f
  color.i
  imageData.s
  properties.s
EndStructure
Structure SymbolLibrary
  entries.SymbolLibraryEntry[100]
  count.i
EndStructure
Structure UndoAction
  actionType.i
  data.s
EndStructure
Structure DrawingData
  lines.Line[1000]
  lineCount.i
  symbols.Symbol[500]
  symbolCount.i
  library.SymbolLibrary
  filename.s
  modified.i
  zoom.f
  panX.f
  panY.f
  snapGrid.i
  gridSize.i
EndStructure
Global drawing.DrawingData
Global currentTool = #TOOL_Pointer
Global currentColor = 0
Global currentLineWidth = 1
Global selectedLineIndex = -1
Global selectedSymbolIndex = -1
Global isDrawing = 0
Global startX.f, startY.f
Global undoStack.UndoAction[100]
Global undoStackCount = 0
Global redoStack.UndoAction[100]
Global redoStackCount = 0
Global colWhite = RGB(255, 255, 255)
Global colBlack = RGB(0, 0, 0)
Global colRed = RGB(255, 0, 0)
Global colBlue = RGB(0, 0, 255)
Global colGreen = RGB(0, 255, 0)
Global colYellow = RGB(255, 255, 0)
Global colGray = RGB(128, 128, 128)
Global colGrid = RGB(220, 220, 220)
Global colSelect = RGB(100, 150, 255)
Procedure InitializeDrawing()
  drawing\lineCount = 0
  drawing\symbolCount = 0
  drawing\zoom = 1.0
  drawing\panX = 0.0
  drawing\panY = 0.0
  drawing\snapGrid = 0
  drawing\gridSize = 10
  drawing\modified = 0
  drawing\filename = ""
  InitializeSymbolLibrary()
  CreateBuiltInSymbols()
EndProcedure
Procedure InitializeSymbolLibrary()
  drawing\library\count = 0
EndProcedure
Procedure CreateBuiltInSymbols()
  drawing\library\entries[drawing\library\count]\name = "Power Supply"
  drawing\library\entries[drawing\library\count]\type = #SYMBOL_PowerSupply
  drawing\library\entries[drawing\library\count]\width = 30
  drawing\library\entries[drawing\library\count]\height = 30
  drawing\library\entries[drawing\library\count]\color = colBlack
  drawing\library\count + 1
  drawing\library\entries[drawing\library\count]\name = "Earth"
  drawing\library\entries[drawing\library\count]\type = #SYMBOL_Earth
  drawing\library\entries[drawing\library\count]\width = 20
  drawing\library\entries[drawing\library\count]\height = 30
  drawing\library\entries[drawing\library\count]\color = colBlack
  drawing\library\count + 1
  drawing\library\entries[drawing\library\count]\name = "GND"
  drawing\library\entries[drawing\library\count]\type = #SYMBOL_GND
  drawing\library\entries[drawing\library\count]\width = 20
  drawing\library\entries[drawing\library\count]\height = 25
  drawing\library\entries[drawing\library\count]\color = colBlack
  drawing\library\count + 1
EndProcedure
Procedure CreateMenuBar()
  CreateMenu(#MENU_File, WindowID(#WIN_Main))
  MenuItem(#MENU_File_New, "New")
  MenuItem(#MENU_File_Open, "Open")
  MenuItem(#MENU_File_Save, "Save")
  MenuItem(#MENU_File_SaveAs, "Save As...")
  MenuItem(#MENU_File_Export, "Export as Image")
  MenuBar()
  MenuItem(#MENU_File_Exit, "Exit")
  CreateMenu(#MENU_Edit, WindowID(#WIN_Main))
  MenuItem(#MENU_Edit_Undo, "Undo")
  MenuItem(#MENU_Edit_Redo, "Redo")
  MenuBar()
  MenuItem(#MENU_Edit_Cut, "Cut")
  MenuItem(#MENU_Edit_Copy, "Copy")
  MenuItem(#MENU_Edit_Paste, "Paste")
  MenuBar()
  MenuItem(#MENU_Edit_Delete, "Delete")
  MenuItem(#MENU_Edit_SelectAll, "Select All")
  CreateMenu(#MENU_View, WindowID(#WIN_Main))
  MenuItem(#MENU_View_ZoomIn, "Zoom In")
  MenuItem(#MENU_View_ZoomOut, "Zoom Out")
  MenuItem(#MENU_View_ZoomFit, "Fit to Window")
  CreateMenu(#MENU_Symbols, WindowID(#WIN_Main))
  MenuItem(#MENU_Symbols_New, "New Symbol")
  MenuItem(#MENU_Symbols_Import, "Import Image as Symbol")
  MenuBar()
  MenuItem(#MENU_Symbols_Edit, "Edit Symbol")
  MenuItem(#MENU_Symbols_Delete, "Delete Symbol")
  MenuBar()
  MenuItem(#MENU_Symbols_Manage, "Manage Library")
  CreateMenu(#MENU_Tools, WindowID(#WIN_Main))
  MenuItem(#MENU_Tools_Properties, "Properties")
  MenuItem(#MENU_Tools_SnapGrid, "Toggle Snap to Grid")
  CreateMenu(#MENU_Help, WindowID(#WIN_Main))
  MenuItem(#MENU_Help_About, "About")
EndProcedure
Procedure CreateMainWindow()
  If OpenWindow(#WIN_Main, 100, 100, #WINDOW_WIDTH, #WINDOW_HEIGHT, "Schematic Drawing Tool", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget)
    CreateMenuBar()
    TextGadget(#TEXT_Status, 0, 0, #WINDOW_WIDTH, 20, "Ready")
    CanvasGadget(#CANVAS_Drawing, 0, 20, #WINDOW_WIDTH - #SIDEBAR_WIDTH, #WINDOW_HEIGHT - 20, #PB_Canvas_DrawingArea | #PB_Canvas_Keyboard)
    ContainerGadget(10, #WINDOW_WIDTH - #SIDEBAR_WIDTH, 20, #SIDEBAR_WIDTH, #WINDOW_HEIGHT - 40)
    GroupGadget(11, 5, 5, #SIDEBAR_WIDTH - 10, 100, "Tools")
    ButtonGadget(#BUTTON_Pointer, 10, 25, 80, 25, "Pointer", #PB_Button_Toggle)
    ButtonGadget(#BUTTON_Line, 10, 55, 80, 25, "Line", #PB_Button_Toggle)
    ButtonGadget(#BUTTON_Symbol, 100, 25, 80, 25, "Symbol", #PB_Button_Toggle)
    ButtonGadget(#BUTTON_Delete, 100, 55, 80, 25, "Delete", #PB_Button_Toggle)
    CloseGadgetList()
    GroupGadget(12, 5, 110, #SIDEBAR_WIDTH - 10, 80, "Line Properties")
    TextGadget(13, 10, 125, 50, 15, "Color:")
    ComboBoxGadget(#COMBO_Color, 70, 125, 140, 200)
    AddGadgetItem(#COMBO_Color, "Black")
    AddGadgetItem(#COMBO_Color, "Red")
    AddGadgetItem(#COMBO_Color, "Blue")
    AddGadgetItem(#COMBO_Color, "Green")
    AddGadgetItem(#COMBO_Color, "Yellow")
    SetGadgetState(#COMBO_Color, 0)
    TextGadget(14, 10, 150, 50, 15, "Width:")
    ComboBoxGadget(#COMBO_LineWidth, 70, 150, 140, 100)
    AddGadgetItem(#COMBO_LineWidth, "1")
    AddGadgetItem(#COMBO_LineWidth, "2")
    AddGadgetItem(#COMBO_LineWidth, "3")
    AddGadgetItem(#COMBO_LineWidth, "4")
    SetGadgetState(#COMBO_LineWidth, 0)
    CloseGadgetList()
    GroupGadget(15, 5, 195, #SIDEBAR_WIDTH - 10, 500, "Symbol Library")
    ListIconGadget(#LIST_Symbols, 10, 210, 230, 450, "Symbol Name", 200)
    AddGadgetColumn(#LIST_Symbols, "Type", 60)
    UpdateSymbolList()
    CloseGadgetList()
    CloseGadgetList()
    SetStatusText("Ready")
  EndIf
EndProcedure
Procedure UpdateSymbolList()
  ClearGadgetItems(#LIST_Symbols)
  For i = 0 To drawing\library\count - 1
    AddGadgetItem(#LIST_Symbols, drawing\library\entries[i]\name)
  Next
EndProcedure
Procedure DrawCanvas()
  If StartDrawing(CanvasOutput(#CANVAS_Drawing))
    Box(0, 0, OutputWidth(), OutputHeight(), colWhite)
    If drawing\snapGrid
      DrawGrid()
    EndIf
    DrawAllLines()
    DrawAllSymbols()
    StopDrawing()
  EndIf
EndProcedure
Procedure DrawGrid()
  FrontColor(colGrid)
  For x = 0 To OutputWidth() Step drawing\gridSize
    Line(x, 0, x, OutputHeight())
  Next
  For y = 0 To OutputHeight() Step drawing\gridSize
    Line(0, y, OutputWidth(), y)
  Next
  FrontColor(colBlack)
EndProcedure
Procedure DrawAllLines()
  For i = 0 To drawing\lineCount - 1
    line.Line = drawing\lines[i]
    FrontColor(line\color)
    LineWidth(line\width)
    Line(line\p1\x, line\p1\y, line\p2\x, line\p2\y)
    If line\selected
      FrontColor(colSelect)
      Circle(line\p1\x, line\p1\y, 5)
      Circle(line\p2\x, line\p2\y, 5)
    EndIf
  Next
  LineWidth(1)
  FrontColor(colBlack)
EndProcedure
Procedure DrawAllSymbols()
  For i = 0 To drawing\symbolCount - 1
    sym.Symbol = drawing\symbols[i]
    FrontColor(sym\color)
    Select sym\type
      Case #SYMBOL_PowerSupply
        DrawPowerSupplySymbol(sym\x, sym\y, sym\width, sym\height)
      Case #SYMBOL_Earth
        DrawEarthSymbol(sym\x, sym\y, sym\width, sym\height)
      Case #SYMBOL_GND
        DrawGNDSymbol(sym\x, sym\y, sym\width, sym\height)
      Case #SYMBOL_Custom
        DrawCustomSymbol(sym\x, sym\y, sym\width, sym\height, sym\image)
    EndSelect
    If sym\selected
      FrontColor(colSelect)
      Box(sym\x - 2, sym\y - 2, sym\width + 4, sym\height + 4)
    EndIf
    If sym\label <> ""
      DrawText(sym\x + 5, sym\y - 15, sym\label)
    EndIf
  Next
  FrontColor(colBlack)
EndProcedure
Procedure DrawPowerSupplySymbol(x.f, y.f, w.f, h.f)
  Circle(x + w/2, y + h/2, w/2)
  DrawText(x + w/2 - 4, y + h/2 - 8, "+")
  DrawText(x + w/2 - 4, y + h/2 + 4, "-")
EndProcedure
Procedure DrawEarthSymbol(x.f, y.f, w.f, h.f)
  Line(x + w/2, y, x + w/2, y + h/3)
  Line(x + w/4, y + h/3, x + 3*w/4, y + h/3)
  Line(x + 3*w/10, y + 2*h/3, x + 7*w/10, y + 2*h/3)
  Line(x + 2*w/5, y + h, x + 3*w/5, y + h)
EndProcedure
Procedure DrawGNDSymbol(x.f, y.f, w.f, h.f)
  Line(x + w/2, y, x + w/2, y + h/3)
  Line(x + w/4, y + h/3, x + 3*w/4, y + h/3)
  Line(x + 3*w/10, y + 2*h/3, x + 7*w/10, y + 2*h/3)
EndProcedure
Procedure DrawCustomSymbol(x.f, y.f, w.f, h.f, imageID.i)
  If imageID > 0
    DrawImage(imageID, x, y)
  Else
    Box(x, y, w, h)
    DrawText(x + 5, y + 5, "Image")
  EndIf
EndProcedure
Procedure AddLine(x1.f, y1.f, x2.f, y2.f, color.i, width.i)
  If drawing\lineCount < 1000
    drawing\lines[drawing\lineCount]\p1\x = x1
    drawing\lines[drawing\lineCount]\p1\y = y1
    drawing\lines[drawing\lineCount]\p2\x = x2
    drawing\lines[drawing\lineCount]\p2\y = y2
    drawing\lines[drawing\lineCount]\color = color
    drawing\lines[drawing\lineCount]\width = width
    drawing\lines[drawing\lineCount]\style = #LINE_Solid
    drawing\lines[drawing\lineCount]\selected = 0
    drawing\lineCount + 1
    drawing\modified = 1
    PushUndoAction("AddLine", Format(x1) + "," + Format(y1) + "," + Format(x2) + "," + Format(y2))
  EndIf
EndProcedure
Procedure DeleteSelectedLine()
  If selectedLineIndex >= 0 And selectedLineIndex < drawing\lineCount
    For i = selectedLineIndex To drawing\lineCount - 2
      drawing\lines[i] = drawing\lines[i + 1]
    Next
    drawing\lineCount - 1
    selectedLineIndex = -1
    drawing\modified = 1
    PushUndoAction("DeleteLine", "")
  EndIf
EndProcedure
Procedure SelectLine(index.i)
  If index >= 0 And index < drawing\lineCount
    selectedLineIndex = index
    drawing\lines[index]\selected = 1
  EndIf
EndProcedure
Procedure DeselectAllLines()
  For i = 0 To drawing\lineCount - 1
    drawing\lines[i]\selected = 0
  Next
  selectedLineIndex = -1
EndProcedure
Procedure GetLineAtPoint(x.f, y.f)
  For i = 0 To drawing\lineCount - 1
    line.Line = drawing\lines[i]
    If IsPointNearLine(x, y, line\p1\x, line\p1\y, line\p2\x, line\p2\y, 5)
      SelectLine(i)
      ProcedureReturn i
    EndIf
  Next
  ProcedureReturn -1
EndProcedure
Procedure IsPointNearLine(px.f, py.f, x1.f, y1.f, x2.f, y2.f, threshold.f)
  distance.f = PointToLineDistance(px, py, x1, y1, x2, y2)
  ProcedureReturn (distance <= threshold)
EndProcedure
Procedure.f PointToLineDistance(px.f, py.f, x1.f, y1.f, x2.f, y2.f)
  dx.f = x2 - x1
  dy.f = y2 - y1
  If dx = 0 And dy = 0
    ProcedureReturn Sqr((px - x1) * (px - x1) + (py - y1) * (py - y1))
  EndIf
  t.f = ((px - x1) * dx + (py - y1) * dy) / (dx * dx + dy * dy)
  t = ((t < 0) ? 0 : ((t > 1) ? 1 : t))
  closestX.f = x1 + t * dx
  closestY.f = y1 + t * dy
  ProcedureReturn Sqr((px - closestX) * (px - closestX) + (py - closestY) * (py - closestY))
EndProcedure
Procedure AddSymbol(x.f, y.f, type.i, width.f, height.f)
  If drawing\symbolCount < 500
    drawing\symbols[drawing\symbolCount]\x = x
    drawing\symbols[drawing\symbolCount]\y = y
    drawing\symbols[drawing\symbolCount]\type = type
    drawing\symbols[drawing\symbolCount]\width = width
    drawing\symbols[drawing\symbolCount]\height = height
    drawing\symbols[drawing\symbolCount]\rotation = 0
    drawing\symbols[drawing\symbolCount]\color = colBlack
    drawing\symbols[drawing\symbolCount]\label = ""
    drawing\symbols[drawing\symbolCount]\selected = 0
    drawing\symbolCount + 1
    drawing\modified = 1
    PushUndoAction("AddSymbol", Format(x) + "," + Format(y) + "," + Str(type))
  EndIf
EndProcedure
Procedure DeleteSelectedSymbol()
  If selectedSymbolIndex >= 0 And selectedSymbolIndex < drawing\symbolCount
    For i = selectedSymbolIndex To drawing\symbolCount - 2
      drawing\symbols[i] = drawing\symbols[i + 1]
    Next
    drawing\symbolCount - 1
    selectedSymbolIndex = -1
    drawing\modified = 1
    PushUndoAction("DeleteSymbol", "")
  EndIf
EndProcedure
Procedure SelectSymbol(index.i)
  If index >= 0 And index < drawing\symbolCount
    selectedSymbolIndex = index
    drawing\symbols[index]\selected = 1
  EndIf
EndProcedure
Procedure DeselectAllSymbols()
  For i = 0 To drawing\symbolCount - 1
    drawing\symbols[i]\selected = 0
  Next
  selectedSymbolIndex = -1
EndProcedure
Procedure GetSymbolAtPoint(x.f, y.f)
  For i = drawing\symbolCount - 1 To 0 Step -1
    sym.Symbol = drawing\symbols[i]
    If x >= sym\x And x <= sym\x + sym\width And y >= sym\y And y <= sym\y + sym\height
      SelectSymbol(i)
      ProcedureReturn i
    EndIf
  Next
  ProcedureReturn -1
EndProcedure
Procedure MoveSelectedSymbol(newX.f, newY.f)
  If selectedSymbolIndex >= 0 And selectedSymbolIndex < drawing\symbolCount
    drawing\symbols[selectedSymbolIndex]\x = newX
    drawing\symbols[selectedSymbolIndex]\y = newY
    drawing\modified = 1
  EndIf
EndProcedure
Procedure ResizeSelectedSymbol(newWidth.f, newHeight.f)
  If selectedSymbolIndex >= 0 And selectedSymbolIndex < drawing\symbolCount
    drawing\symbols[selectedSymbolIndex]\width = newWidth
    drawing\symbols[selectedSymbolIndex]\height = newHeight
    drawing\modified = 1
  EndIf
EndProcedure
Procedure RotateSelectedSymbol(angle.f)
  If selectedSymbolIndex >= 0 And selectedSymbolIndex < drawing\symbolCount
    drawing\symbols[selectedSymbolIndex]\rotation + angle
    drawing\modified = 1
  EndIf
EndProcedure
Procedure SetSymbolLabel(index.i, label.s)
  If index >= 0 And index < drawing\symbolCount
    drawing\symbols[index]\label = label
    drawing\modified = 1
  EndIf
EndProcedure
Procedure ImportImageAsSymbol(filename.s, name.s)
  imageID = LoadImage(#PB_Any, filename)
  If imageID <> 0
    If drawing\library\count < 100
      drawing\library\entries[drawing\library\count]\name = name
      drawing\library\entries[drawing\library\count]\type = #SYMBOL_Custom
      drawing\library\entries[drawing\library\count]\width = ImageWidth(imageID)
      drawing\library\entries[drawing\library\count]\height = ImageHeight(imageID)
      drawing\library\entries[drawing\library\count]\color = colBlack
      drawing\library\count + 1
      drawing\modified = 1
      UpdateSymbolList()
      SetStatusText("Symbol imported: " + name)
      ProcedureReturn 1
    EndIf
  Else
    SetStatusText("Failed to import image: " + filename)
  EndIf
  ProcedureReturn 0
EndProcedure
Procedure.i GetColorFromCombo()
  Select GetGadgetState(#COMBO_Color)
    Case 0
      ProcedureReturn colBlack
    Case 1
      ProcedureReturn colRed
    Case 2
      ProcedureReturn colBlue
    Case 3
      ProcedureReturn colGreen
    Case 4
      ProcedureReturn colYellow
    Default
      ProcedureReturn colBlack
  EndSelect
EndProcedure
Procedure.i GetLineWidthFromCombo()
  ProcedureReturn Val(GetGadgetText(#COMBO_LineWidth))
EndProcedure
Procedure UpdateColorSelection(color.i)
  Select color
    Case colBlack
      SetGadgetState(#COMBO_Color, 0)
    Case colRed
      SetGadgetState(#COMBO_Color, 1)
    Case colBlue
      SetGadgetState(#COMBO_Color, 2)
    Case colGreen
      SetGadgetState(#COMBO_Color, 3)
    Case colYellow
      SetGadgetState(#COMBO_Color, 4)
  EndSelect
  currentColor = color
EndProcedure
Procedure PushUndoAction(actionType.s, data.s)
  If undoStackCount < 100
    undoStack[undoStackCount]\actionType = actionType
    undoStack[undoStackCount]\data = data
    undoStackCount + 1
  EndIf
  redoStackCount = 0
EndProcedure
Procedure Undo()
  If undoStackCount > 0
    undoStackCount - 1
    SetStatusText("Undo: " + undoStack[undoStackCount]\actionType)
  EndIf
EndProcedure
Procedure Redo()
  If redoStackCount < 100
    SetStatusText("Redo: " + redoStack[redoStackCount]\actionType)
    redoStackCount + 1
  EndIf
EndProcedure
Procedure NewDrawing()
  InitializeDrawing()
  drawing\filename = ""
  drawing\modified = 0
  DeselectAllLines()
  DeselectAllSymbols()
  SetStatusText("New drawing created")
  DrawCanvas()
EndProcedure
Procedure OpenDrawing()
  filename.s = OpenFileRequester("Open Drawing", "", "Drawing Files (*.smd)|*.smd", 0)
  If filename <> ""
    drawing\filename = filename
    drawing\modified = 0
    SetStatusText("Drawing opened: " + filename)
    DrawCanvas()
  EndIf
EndProcedure
Procedure SaveDrawing()
  If drawing\filename = ""
    SaveDrawingAs()
  Else
    drawing\modified = 0
    SetStatusText("Drawing saved: " + drawing\filename)
  EndIf
EndProcedure
Procedure SaveDrawingAs()
  filename.s = SaveFileRequester("Save Drawing As", "", "Drawing Files (*.smd)|*.smd", 0)
  If filename <> ""
    drawing\filename = filename
    drawing\modified = 0
    SetStatusText("Drawing saved: " + filename)
  EndIf
EndProcedure
Procedure ExportAsImage()
  filename.s = SaveFileRequester("Export as Image", "", "PNG Image (*.png)|*.png", 0)
  If filename <> ""
    SetStatusText("Drawing exported: " + filename)
  EndIf
EndProcedure
Procedure SetStatusText(text.s)
  SetGadgetText(#TEXT_Status, text)
EndProcedure
Procedure SelectTool(tool.i)
  currentTool = tool
  SetGadgetState(#BUTTON_Pointer, (tool = #TOOL_Pointer))
  SetGadgetState(#BUTTON_Line, (tool = #TOOL_Line))
  SetGadgetState(#BUTTON_Symbol, (tool = #TOOL_Symbol))
  SetGadgetState(#BUTTON_Delete, (tool = #TOOL_Delete))
  Select tool
    Case #TOOL_Pointer
      SetStatusText("Pointer tool selected")
    Case #TOOL_Line
      SetStatusText("Line tool selected - Click to set start, click again to set end")
    Case #TOOL_Symbol
      SetStatusText("Symbol tool selected - Click to place symbol")
    Case #TOOL_Delete
      SetStatusText("Delete tool selected - Click to delete")
  EndSelect
EndProcedure
Procedure ZoomIn()
  drawing\zoom * 1.2
  DrawCanvas()
  SetStatusText("Zoom: " + Format(drawing\zoom * 100, "#0.0") + "%")
EndProcedure
Procedure ZoomOut()
  drawing\zoom / 1.2
  DrawCanvas()
  SetStatusText("Zoom: " + Format(drawing\zoom * 100, "#0.0") + "%")
EndProcedure
Procedure Pan(dx.f, dy.f)
  drawing\panX + dx
  drawing\panY + dy
  DrawCanvas()
EndProcedure
Procedure HandleCanvasMouseDown(x.f, y.f, button.i)
  Select currentTool
    Case #TOOL_Pointer
      If GetSymbolAtPoint(x, y) < 0
        GetLineAtPoint(x, y)
      EndIf
    Case #TOOL_Line
      If Not isDrawing
        startX = x
        startY = y
        isDrawing = 1
        SetStatusText("Line started at (" + Format(x, "#0.0") + ", " + Format(y, "#0.0") + ")")
      Else
        currentColor = GetColorFromCombo()
        currentLineWidth = GetLineWidthFromCombo()
        AddLine(startX, startY, x, y, currentColor, currentLineWidth)
        isDrawing = 0
        SetStatusText("Line added")
      EndIf
    Case #TOOL_Symbol
      symbolIndex = GetGadgetState(#LIST_Symbols)
      If symbolIndex >= 0 And symbolIndex < drawing\library\count
        entry.SymbolLibraryEntry = drawing\library\entries[symbolIndex]
        AddSymbol(x, y, entry\type, entry\width, entry\height)
        SetStatusText("Symbol placed: " + entry\name)
      EndIf
    Case #TOOL_Delete
      If GetSymbolAtPoint(x, y) >= 0
        DeleteSelectedSymbol()
        SetStatusText("Symbol deleted")
      ElseIf GetLineAtPoint(x, y) >= 0
        DeleteSelectedLine()
        SetStatusText("Line deleted")
      EndIf
  EndSelect
EndProcedure
Procedure HandleCanvasMouseMove(x.f, y.f)
  If currentTool = #TOOL_Pointer And selectedSymbolIndex >= 0
  EndIf
  DrawCanvas()
EndProcedure
Procedure HandleCanvasMouseUp(x.f, y.f, button.i)
EndProcedure
Procedure HandleKeyPress(key.i)
  Select key
    Case #PB_Shortcut_Delete
      If selectedSymbolIndex >= 0
        DeleteSelectedSymbol()
      ElseIf selectedLineIndex >= 0
        DeleteSelectedLine()
      EndIf
    Case #PB_Shortcut_Escape
      DeselectAllLines()
      DeselectAllSymbols()
      isDrawing = 0
    Case #PB_Shortcut_Z
      If GetAsyncKeyState_(16) < 0
        Undo()
      EndIf
    Case #PB_Shortcut_Y
      If GetAsyncKeyState_(16) < 0
        Redo()
      EndIf
  EndSelect
  DrawCanvas()
EndProcedure
Procedure HandleMenuEvent(menu.i)
  Select menu
    Case #MENU_File_New
      NewDrawing()
    Case #MENU_File_Open
      OpenDrawing()
    Case #MENU_File_Save
      SaveDrawing()
    Case #MENU_File_SaveAs
      SaveDrawingAs()
    Case #MENU_File_Export
      ExportAsImage()
    Case #MENU_File_Exit
      End
    Case #MENU_Edit_Undo
      Undo()
    Case #MENU_Edit_Redo
      Redo()
    Case #MENU_Edit_Delete
      If selectedSymbolIndex >= 0
        DeleteSelectedSymbol()
      ElseIf selectedLineIndex >= 0
        DeleteSelectedLine()
      EndIf
    Case #MENU_View_ZoomIn
      ZoomIn()
    Case #MENU_View_ZoomOut
      ZoomOut()
    Case #MENU_View_ZoomFit
      drawing\zoom = 1.0
      drawing\panX = 0
      drawing\panY = 0
      DrawCanvas()
    Case #MENU_Symbols_Import
      filename.s = OpenFileRequester("Import Image", "", "Image Files (*.png;*.jpg;*.bmp)|*.png;*.jpg;*.bmp", 0)
      If filename <> ""
        name.s = GetFilePart(filename)
        ImportImageAsSymbol(filename, name)
      EndIf
    Case #MENU_Tools_SnapGrid
      drawing\snapGrid = Not drawing\snapGrid
      SetStatusText("Snap to Grid: " + (drawing\snapGrid ? "ON" : "OFF"))
    Case #MENU_Help_About
      MessageRequester("About", "Schematic Drawing Tool v1.0" + Chr(10) + "A tool for creating electronic schematics")
  EndSelect
  DrawCanvas()
EndProcedure
Procedure HandleGadgetEvent(gadgetID.i)
  Select gadgetID
    Case #BUTTON_Pointer
      SelectTool(#TOOL_Pointer)
    Case #BUTTON_Line
      SelectTool(#TOOL_Line)
    Case #BUTTON_Symbol
      SelectTool(#TOOL_Symbol)
    Case #BUTTON_Delete
      SelectTool(#TOOL_Delete)
    Case #COMBO_Color
      UpdateColorSelection(GetColorFromCombo())
  EndSelect
  DrawCanvas()
EndProcedure
Procedure MainEventLoop()
  Repeat
    event.i = WaitWindowEvent()
    Select event
      Case #PB_Event_Gadget
        gadgetID.i = EventGadget()
        If gadgetID = #CANVAS_Drawing
          Select EventType()
            Case #PB_EventType_LeftButtonDown
              GetCanvasCoordinates(#CANVAS_Drawing, x.i, y.i)
              HandleCanvasMouseDown(x, y, #PB_MouseButton_Left)
            Case #PB_EventType_MouseMove
              GetCanvasCoordinates(#CANVAS_Drawing, x.i, y.i)
              HandleCanvasMouseMove(x, y)
            Case #PB_EventType_LeftButtonUp
              GetCanvasCoordinates(#CANVAS_Drawing, x.i, y.i)
              HandleCanvasMouseUp(x, y, #PB_MouseButton_Left)
            Case #PB_EventType_KeyDown
              HandleKeyPress(GetGadgetAttribute(#CANVAS_Drawing, #PB_Canvas_Key))
          EndSelect
        Else
          HandleGadgetEvent(gadgetID)
        EndIf
      Case #PB_Event_Menu
        menuID.i = EventMenu()
        HandleMenuEvent(menuID)
      Case #PB_Event_CloseWindow
        Break
    EndSelect
    DrawCanvas()
  ForEver
EndProcedure
InitializeDrawing()
CreateMainWindow()
SelectTool(#TOOL_Pointer)
DrawCanvas()
MainEventLoop()
End
