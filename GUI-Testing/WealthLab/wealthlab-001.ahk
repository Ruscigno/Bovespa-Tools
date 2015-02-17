vcdEmpresa = symbol
vSaveTo = C:\Backtests\results\
vnYears = 5
vnPercentOfEquity = 50
vnMarginFactor = 1
vnNumberOfRuns = 40
vnNumberOfTests = 15
vnCapital = 5000

IfWinExist Wealth-Lab Developer 6.8
{
	createWorkingFolder(vSaveTo)
	;circleSymbolsStart(0)
	WinActivate
	Loop, 68 {
		doWeekly(vcdEmpresa, vSaveTo, vnYears, vnCapital, vnPercentOfEquity, vnMarginFactor, vnNumberOfRuns, vnNumberOfTests)
	}
}
else
	Run Notepad
	Send, Num deu!
return


;--------------------------------------------------------
doWeekly(vcdEmpresa, vSaveTo, vnYears, vnCapital, vnPercentOfEquity, vnMarginFactor, vnNumberOfRuns, vnNumberOfTests){
	IfNotExist, %vSaveTo%_Settings.txt 
		startSettings("Weekly", vcdEmpresa, vSaveTo, vnYears, vnCapital, vnPercentOfEquity, vnMarginFactor, vnNumberOfRuns, vnNumberOfTests)
	doWork(vcdEmpresa, vSaveTo, vnNumberOfRuns, vnNumberOfTests)
	circleSymbols(0)
}

startSettings(psType, vcdEmpresa, vSaveTo, vnYears, vnCapital, vnPercentOfEquity, vnMarginFactor, vnNumberOfRuns, vnNumberOfTests){
	saveSetting(psType, vcdEmpresa, vSaveTo, vnYears, vnCapital, vnPercentOfEquity, vnMarginFactor, vnNumberOfRuns, vnNumberOfTests)
	waitForWL(0)
	dataRange(vnYears)
	waitForWL(0)
	postionSize(vnCapital, vnPercentOfEquity, vnMarginFactor)
}

doWork(vcdEmpresa, vSaveTo, vnNumberOfRuns, vnNumberOfTests){
	waitForWL(0)
	activeOptimization(0)
	optimizationSettings(vnNumberOfRuns, vnNumberOfTests)
	optimizationStart(0)
	optimizationDone(0)
	waitForWL(0)
	symbolToVar(vcdEmpresa)
	saveResults(vcdEmpresa, vSaveTo)
	savePerformance(vcdEmpresa, vSaveTo)
	saveTrades(vcdEmpresa, vSaveTo)
	saveEquity(vcdEmpresa, vSaveTo)
	saveDrawdown(vcdEmpresa, vSaveTo)
	saveProfit(vcdEmpresa, vSaveTo)
}

saveProfit(vcdEmpresa, vSaveTo){
	waitForWL(0)
	MouseClick, left,  803,  109
	Sleep, 200
	MouseClick, right,  639,  294
	Sleep, 200
	MouseClick, left,  725,  341
	Sleep, 200
	savePaint(vcdEmpresa, vSaveTo, "Profit Distribution")
}

saveDrawdown(vcdEmpresa, vSaveTo){
	waitForWL(0)
	MouseClick, left,  724,  106
	Sleep, 200
	MouseClick, right,  639,  294
	Sleep, 200
	MouseClick, left,  725,  341
	Sleep, 200
	savePaint(vcdEmpresa, vSaveTo, "Dawdrown")
	waitForWL(0)
	MouseClick, right,  624,  642
	Sleep, 200
	MouseClick, left,  681,  651
	Sleep, 200
	savePaint(vcdEmpresa, vSaveTo, "Number of bars")
}

savePaint(vcdEmpresa, vSaveTo, vPosfixo){
	Run mspaint.exe
	WinWait, Sem título - Paint, UIRibbonDockTop
	IfWinNotActive, Sem título - Paint, UIRibbonDockTop, WinActivate, Sem título - Paint, UIRibbonDockTop
	WinWaitActive, Sem título - Paint, UIRibbonDockTop
	;Para garantir que já colo e esta pronto para editar
	;Send, {CTRLDOWN}s{CTRLUP}
	;WinWait, Salvar como, Controle da Árvore d
	;IfWinNotActive, Salvar como, Controle da Árvore d, WinActivate, Salvar como, Controle da Árvore d
	;WinWaitActive, Salvar como, Controle da Árvore d
	;Send, {ESC}

	Send, {CTRLDOWN}v{CTRLUP}
	Sleep, 499
	Send, {SHIFTDOWN}{CTRLDOWN}x{SHIFTUP}{CTRLUP}
	Sleep, 499
	Send, {CTRLDOWN}s{CTRLUP}
	WinWait, Salvar como, Controle da Árvore d
	IfWinNotActive, Salvar como, Controle da Árvore d, WinActivate, Salvar como, Controle da Árvore d
	WinWaitActive, Salvar como, Controle da Árvore d
	Send, %vSaveTo%%vcdEmpresa%-%vPosfixo%.png{ENTER}
	;WinWait, %vcdEmpresa%-%vPosfixo%.png - Paint, UIRibbonDockTop
	;IfWinNotActive, %vcdEmpresa%-%vPosfixo%.png - Paint, UIRibbonDockTop, WinActivate, %vcdEmpresa%-%vPosfixo%.png - Paint, UIRibbonDockTop
	;WinWaitActive, %vcdEmpresa%-%vPosfixo%.png - Paint, UIRibbonDockTop
	Sleep, 500
	Send, {ALTDOWN}{F4}{ALTUP}
}

saveEquity(vcdEmpresa, vSaveTo){
	waitForWL(0)
	MouseClick, left,  646,  106
	Sleep, 200
	MouseClick, right,  697,  325
	Sleep, 200
	MouseClick, left,  767,  411
	Sleep, 200
	saveNotepad(vcdEmpresa, vSaveTo, "Equity Curve")
}

symbolToVar(ByRef vcdEmpresa){
	waitForWL(0)
	MouseClick, left,  175,  185
	Sleep, 200
	Send, {CTRLDOWN}c{CTRLUP}
	vcdEmpresa = %clipboard%
}

saveResults(vcdEmpresa, vSaveTo){
	waitForWL(0)
	MouseClick, right,  466,  416
	Sleep, 200
	MouseClick, left,  549,  457
	Sleep, 200
	WinWait, Save Optimization Results, Controle da Árvore d
	IfWinNotActive, Save Optimization Results, Controle da Árvore d, WinActivate, Save Optimization Results, Controle da Árvore d
	WinWaitActive, Save Optimization Results, Controle da Árvore d
	Send, {Home}
	Send, {Shift}+{End}
	Sleep, 200
	;MsgBox, %vSaveTo%
	;MsgBox, %vcdEmpresa%
	Send, %vSaveTo%%vcdEmpresa%
	Sleep, 200
	Send, {ENTER}
	WinWait, , Optimization Result 
	IfWinNotActive, , Optimization Result , WinActivate, , Optimization Result 
	WinWaitActive, , Optimization Result 
	MouseClick, left,  334,  103
	Sleep, 200
	;Send, {ENTER}
}

savePerformance(vcdEmpresa, vSaveTo){
	WinWait, Wealth-Lab Developer 6.8
	IfWinNotActive, Wealth-Lab Developer 6.8, WinActivate, Wealth-Lab Developer 6.8
	WinWaitActive, Wealth-Lab Developer 6.8
	MouseClick, left,  522,  106
	Sleep, 200
	MouseClick, right,  907,  338
	Sleep, 200
	MouseClick, left,  935,  350
	Sleep, 200
	saveNotepad(vcdEmpresa, vSaveTo, "Performance")
}

saveNotepad(vcdEmpresa, vSaveTo, vPosfixo){
	Run Notepad
	WinWait, Sem título - Bloco de notas, 
	IfWinNotActive, Sem título - Bloco de notas, , WinActivate, Sem título - Bloco de notas, 
	WinWaitActive, Sem título - Bloco de notas, 
	Send, {CTRLDOWN}v{CTRLUP}{CTRLDOWN}s{CTRLUP}
	WinWait, Salvar como, Controle da Árvore d
	IfWinNotActive, Salvar como, Controle da Árvore d, WinActivate, Salvar como, Controle da Árvore d
	WinWaitActive, Salvar como, Controle da Árvore d
	Send, %vSaveTo%%vcdEmpresa%-%vPosfixo%.txt{ENTER}
	Sleep, 500
	Send, {ALTDOWN}{F4}{ALTUP}
}

waitForWL(x){
	WinWait, Wealth-Lab Developer 6.8
	IfWinNotActive, Wealth-Lab Developer 6.8, WinActivate, Wealth-Lab Developer 6.8
	WinWaitActive, Wealth-Lab Developer 6.8
}

saveTrades(vcdEmpresa, vSaveTo){
	waitForWL(0)
	MouseClick, left,  593,  110
	Sleep, 200
	MouseClick, right,  573,  434
	Sleep, 200
	MouseClick, left,  593,  444
	Sleep, 200
	saveNotepad(vcdEmpresa, vSaveTo, "Trades")
}

scaleWeekly(x){
	MouseClick, left,  247,  113
	Sleep, 200
	WinWait, ScaleSelecterForm, Custom Intraday Scal
	IfWinNotActive, ScaleSelecterForm, Custom Intraday Scal, WinActivate, ScaleSelecterForm, Custom Intraday Scal
	WinWaitActive, ScaleSelecterForm, Custom Intraday Scal
	MouseClick, left,  29,  27
	Sleep, 200
}

dataRange(pnYears){
	MouseClick, left,  244,  134
	Sleep, 200
	WinWait, BarDataRangeSelecterForm, Number of Bars
	IfWinNotActive, BarDataRangeSelecterForm, Number of Bars, WinActivate, BarDataRangeSelecterForm, Number of Bars
	WinWaitActive, BarDataRangeSelecterForm, Number of Bars
	MouseClick, left,  12,  51
	Sleep, 200
	MouseClick, left,  116,  56
	MouseClick, left,  116,  56
	Sleep, 200
	Send, {Home}
	Send, {Shift}+{End}
	Send, %pnYears%
	Sleep, 200
	;Ok
	MouseClick, left,  116,  135
	Sleep, 200
}

postionSize(vnCapital, vnPercentOfEquity, pnMarginFactor){
	MouseClick, left,  250,  157
	Sleep, 200
	WinWait, PositionSizeSelecterForm, Portfolio Simulation
	IfWinNotActive, PositionSizeSelecterForm, Portfolio Simulation, WinActivate, PositionSizeSelecterForm, Portfolio Simulation
	WinWaitActive, PositionSizeSelecterForm, Portfolio Simulation
	MouseClick, left,  158,  94
	Sleep, 200
	Send, {HOME}{SHIFTDOWN}{END}{SHIFTUP}%vnCapital%
	MouseClick, left,  36,  159
	Sleep, 200
	MouseClick, left,  152,  160
	Sleep, 200
	Send, {Home}
	Send, {Shift}+{End}
	Send, %pnPercentOfEquity%
	Sleep, 200
	MouseClick, left,  94,  282
	MouseClick, left,  94,  282
	Sleep, 200
	Send, {Home}
	Send, {Shift}+{End}
	Send, %pnMarginFactor%
	Sleep, 200
	MouseClick, left,  97,  312
	Sleep, 200
}

optimizationStart(x){
	MouseClick, left,  338,  131
	Sleep, 200
	MouseClick, left,  608,  473
	Sleep, 200
}

activeOptimization(x){
	MouseClick, left,  351,  864
	Sleep, 200
}

optimizationDone(x){
	;Otimização completa
	WinWait, , Optimization complet
	IfWinNotActive, , Optimization complet, WinActivate, , Optimization complet
	WinWaitActive, , Optimization complet
	MouseClick, left,  119,  100
	Sleep, 200
}

optimizationSettings(pnNumberOfRuns, pnNumberOfTests){
	MouseClick, left,  935,  107
	Sleep, 200
	MouseClick, left,  328,  129
	Sleep, 200
	waitForWL(0)
	MouseClick, left,  468,  527
	Sleep, 200
	WinWait, Optimizer Settings, Number of Tests in e
	IfWinNotActive, Optimizer Settings, Number of Tests in e, WinActivate, Optimizer Settings, Number of Tests in e
	WinWaitActive, Optimizer Settings, Number of Tests in e
	MouseClick, left,  231,  35
	Sleep, 200
	MouseClick, left,  152,  52
	Sleep, 200
	MouseClick, left,  194,  107
	Sleep, 200
	Send, {HOME}{SHIFTDOWN}{END}{SHIFTUP}%pnNumberOfRuns%
	MouseClick, left,  198,  132
	Sleep, 200
	Send, {HOME}{SHIFTDOWN}{END}{SHIFTUP}%pnNumberOfTests%{ENTER}
	waitForWL(0)
	;Method
	MouseClick, left,  512,  445
	Sleep, 200
	MouseClick, left,  434,  477
	Sleep, 200
	MouseClick, left,  924,  420
	Sleep, 200
	MouseClick, left,  832,  451
	Sleep, 200
}

circleSymbols(x){
	waitForWL(0)
	MouseClick, left,  247,  736
	Sleep, 200
	MouseClick, left,  109,  230
	Sleep, 200		
}

circleSymbolsStart(x){
	waitForWL(0)
	MouseClick, left,  109,  230
	Sleep, 200		
	Send {HOME}
	;MouseClick, left,  247,  736
	Sleep, 200
}

createWorkingFolder(ByRef vSaveTo){
	vSaveTo = %vSaveTo%%A_YYYY%%A_MM%%A_DD% - %A_Hour%%A_Min%%A_Sec%\
	FileCreateDir, %vSaveTo%
}

saveSetting(psType, vcdEmpresa, vSaveTo, vnYears, vnCapital, vnPercentOfEquity, vnMarginFactor, vnNumberOfRuns, vnNumberOfTests){
	Run Notepad
	WinWait, Sem título - Bloco de notas, 
	IfWinNotActive, Sem título - Bloco de notas, , WinActivate, Sem título - Bloco de notas, 
	WinWaitActive, Sem título - Bloco de notas, 
	Send Tipo{TAB}{TAB}{TAB}%psType%{ENTER}
	Send Data Range-Years{TAB}%vnYears%{ENTER}
	Send Capital{TAB}{TAB}{TAB}%vnCapital%{ENTER}
	Send PercentOfEquity{TAB}{TAB}%vnPercentOfEquity%{ENTER}
	Send MarginFactor{TAB}{TAB}%vnMarginFactor%{ENTER}
	Send NumberOfRuns{TAB}{TAB}%vnNumberOfRuns%{ENTER}
	Send NumberOfTests{TAB}{TAB}%vnNumberOfTests%{ENTER}
	Send, {CTRLDOWN}s{CTRLUP}
	WinWait, Salvar como, Controle da Árvore d
	IfWinNotActive, Salvar como, Controle da Árvore d, WinActivate, Salvar como, Controle da Árvore d
	WinWaitActive, Salvar como, Controle da Árvore d
	Send, %vSaveTo%_Settings.txt{ENTER}
	Sleep, 500
	Send, {ALTDOWN}{F4}{ALTUP}
}