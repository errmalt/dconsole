package pgr.dconsole;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import pgr.dconsole.DCThemes.Theme;

/**
 * 
 * @author TiagoLr ( ~~~ProG4mr~~~ )
 */

class DCInterface extends Sprite
{
	var _promptFontYOffset:Int;
	var yAlign:String;
	var heightPt:Float; // percentage height
	var widthPt:Float; // percentage width
	var _width:Float; // width in pixels
	var _height:Float; // height in pixels
	var margin:Int = 0;
	
	var monitorDisplay:Sprite;
	var txtMonitorLeft:TextField;
	var txtMonitorRight:TextField;
	
	var profilerDisplay:Sprite;
	var txtProfiler:TextField;
	
	var consoleDisplay:Sprite;
	var promptDisplay:Sprite;
	var txtConsole:TextField;
	var txtPrompt:TextField;
	
	public function new(widthPt:Float, heightPt:Float, align:String) {
		super();
		Lib.current.stage.addChild(this); // by default the interface adds itself to the stage.
		
		this.widthPt = widthPt;
		this.heightPt = heightPt;
		yAlign = align;
		
		createMonitorDisplay();
		createProfilerDisplay();
		createConsoleDisplay();
		
		setConsoleFont();
		setMonitorFont();
		setProfilerFont();
		setPromptFont();
		
		onResize();
	}
	
	function onResize() {
		_width = this.parent.width * (widthPt / 100);
		_height = this.parent.height * (heightPt / 100);
		
		drawConsole(); // redraws console.
		drawMonitor();
	}
	
	
	function createConsoleDisplay() {
		consoleDisplay = new Sprite();
		consoleDisplay.alpha = DCThemes.current.CON_TXT_A;
		addChild(consoleDisplay);
		
		promptDisplay = new Sprite();
		addChild(promptDisplay);
		
		txtPrompt = new TextField();
		txtPrompt.type = TextFieldType.INPUT;
		txtPrompt.selectable = true;
		txtPrompt.multiline = false;
		promptDisplay.addChild(txtPrompt);
		
		txtConsole = new TextField();
		txtConsole.selectable = false;
		txtConsole.multiline = true;
		txtConsole.wordWrap = true;
		txtConsole.alpha = DCThemes.current.CON_TXT_A;
		consoleDisplay.addChild(txtConsole);
		#if flash
		txtConsole.mouseWheelEnabled = true;
		#end
		
	}
	
	/** 
	 * Draws console fields after changes to console appearence
	 */
	function drawConsole() {
		
		var _yOffset = (yAlign == DC.ALIGN_DOWN) ? _height - _height * heightPt : 0; 
		
		// draw console background.
		consoleDisplay.graphics.clear();
		consoleDisplay.graphics.beginFill(DCThemes.current.CON_C, 1);
		consoleDisplay.graphics.drawRect(0, 0, _width, _height);
		consoleDisplay.graphics.endFill();
		consoleDisplay.y = _yOffset;
		consoleDisplay.alpha = DCThemes.current.CON_A;
		
		// draw text input field.
		promptDisplay.graphics.clear();
		promptDisplay.graphics.beginFill(DCThemes.current.PRM_C);
		promptDisplay.graphics.drawRect(0, 0, _width, txtPrompt.textHeight);
		promptDisplay.graphics.endFill();
		promptDisplay.y = _height - txtPrompt.textHeight + _yOffset;
		
		// Resize textfields
		txtConsole.width = _width;
		txtConsole.height = _height - txtPrompt.textHeight + 2;
		
		txtPrompt.y = - 2; // -2 just looks better.
		txtPrompt.width = _width;
		txtPrompt.height = 32;
		
		#if (cpp || neko) // BUGFIX
		// fix margins bug.
		txtConsole.x += 10;
		txtConsole.width -= 10;
		txtPrompt.x += 10;
		txtPrompt.width -= 10;
		// fix bad starting font bug.
		txtPrompt.text = '';
		#end
	}
	
	@:allow(pgr.dconsole.DConsole)
	function showConsole() {
		consoleDisplay.visible = true;
		promptDisplay.visible = true;
		Lib.current.stage.focus = txtPrompt;
	}
	@:allow(pgr.dconsole.DConsole)
	function hideConsole() {
		consoleDisplay.visible = false;
		promptDisplay.visible = false;
		Lib.current.stage.focus = null;
	}
	
	//---------------------------------------------------------------------------------
	//  MONITOR
	//---------------------------------------------------------------------------------
	function createMonitorDisplay() {
		
		monitorDisplay = new Sprite();
		addChild(monitorDisplay);
		
		txtMonitorLeft = new TextField();
		txtMonitorLeft.selectable = false;
		txtMonitorLeft.multiline = true;
		txtMonitorLeft.wordWrap = true;
		monitorDisplay.addChild(txtMonitorLeft);
		
		txtMonitorRight = new TextField();
		txtMonitorRight.selectable = false;
		txtMonitorRight.multiline = true;
		txtMonitorRight.wordWrap = true;
		monitorDisplay.addChild(txtMonitorRight);
		monitorDisplay.visible = false;
	}
	
	function drawMonitor() {
		
		// draws background
		monitorDisplay.graphics.clear(); 
		monitorDisplay.graphics.beginFill(DCThemes.current.MON_C, DCThemes.current.MON_A);
		monitorDisplay.graphics.drawRect(0, 0, _width, _height);
		monitorDisplay.graphics.endFill();
		// draws decoration line
		monitorDisplay.alpha = DCThemes.current.MON_TXT_A; 
		monitorDisplay.graphics.lineStyle(1, DCThemes.current.MON_TXT_C);
		monitorDisplay.graphics.moveTo(0, txtMonitorLeft.textHeight);
		monitorDisplay.graphics.lineTo(_width, txtMonitorLeft.textHeight);
		// position and scales left text
		txtMonitorLeft.x = 0;
		txtMonitorLeft.width = _width / 2;
		txtMonitorLeft.height = _height;
		// position and scale right text
		txtMonitorRight.x = _width / 2;
		txtMonitorRight.width = _width / 2;
		txtMonitorRight.height = _height;
	}
	
	// Splits output into left and right monitor text fields
	public function writeMonitorOutput(output:Array<String>) {
		txtMonitorLeft.text = "";
		txtMonitorRight.text = "";
		
		txtMonitorLeft.text += "DC Monitor\n\n";
		txtMonitorRight.text += "\n\n";
		
		var i = 0;
		while (output.length > 0) {
			
			if (i % 2 == 0) {
				txtMonitorLeft.text += output.shift();
			} else {
				txtMonitorRight.text += output.shift();
			}
			i++;
		}
	}
	
	@:allow(pgr.dconsole.DConsole)
	function showMonitor() {
		monitorDisplay.visible = true;
	}
	@:allow(pgr.dconsole.DConsole)
	function hideMonitor() {
		monitorDisplay.visible = false;
	}
	
	//---------------------------------------------------------------------------------
	//  PROFILER
	//---------------------------------------------------------------------------------
	function createProfilerDisplay() {
		
		profilerDisplay = new Sprite();
		addChild(profilerDisplay);
		
		txtProfiler = new TextField();
		txtProfiler.selectable = false;
		txtProfiler.multiline = true;
		txtProfiler.wordWrap = true;
		profilerDisplay.addChild(txtProfiler);
		profilerDisplay.visible = false;
	}
	
	function drawProfiler() {
		
		// draw background
		profilerDisplay.graphics.clear();
		profilerDisplay.graphics.beginFill(DCThemes.current.MON_C, DCThemes.current.MON_A);
		profilerDisplay.graphics.drawRect(0, 0, _width, _height);
		profilerDisplay.graphics.endFill();
		// draw decoration line
		profilerDisplay.graphics.lineStyle(1, DCThemes.current.MON_TXT_C); 
		profilerDisplay.graphics.moveTo(0, txtProfiler.textHeight);
		profilerDisplay.graphics.lineTo(_width, txtProfiler.textHeight);
		// position and scale monitor text
		txtProfiler.alpha = DCThemes.current.MON_TXT_A;
		txtProfiler.width = _width;
		txtProfiler.height = _height;
	}
	
	public function writeProfilerOutput(output:String) {
		txtProfiler.text = "DC Profiler\n\n";
		txtProfiler.text += output;
	}
	
	@:allow(pgr.dconsole.DConsole)
	function showProfiler() {
		profilerDisplay.visible = true;
	}
	
	@:allow(pgr.dconsole.DConsole)
	function hideProfiler() {
		profilerDisplay.visible = false;
	}
	
	//---------------------------------------------------------------------------------
	//  PUBLIC METHODS
	//---------------------------------------------------------------------------------
	public function log(data:Dynamic, color:Int) {
		// Adds text to console interface
		var tf = txtConsole; 
		tf.appendText(Std.string(data) + '\n');
		tf.scrollV = tf.maxScrollV;
		
		// Applies color - is always applied to avoid bug.
		if (color == -1) {
			color = DCThemes.current.CON_TXT_C;
		}
		
		// Applies text formatting
		var format:TextFormat = new TextFormat();
		format.color = color;
		var l = Std.string(data).length;
		tf.setTextFormat(format, tf.text.length - l - 1, tf.text.length - 1);
	}
	
	public function moveCarretToEnd() {
		#if !(cpp || neko)
		txtPrompt.setSelection(txtPrompt.length, txtPrompt.length);
		#end
	}
	
	public function scrollConsoleUp() {
		txtConsole.scrollV += txtConsole.bottomScrollV - txtConsole.scrollV +1;
		if (txtConsole.scrollV > txtConsole.maxScrollV)
			txtConsole.scrollV = txtConsole.maxScrollV;
	}
	
	public function scrollConsoleDown() {
		txtConsole.scrollV -= txtConsole.bottomScrollV - txtConsole.scrollV +1;
		if (txtConsole.scrollV < 0)
			txtConsole.scrollV = 0;
	}
	
	/**
	 * Brings this display object to the front of display list.
	 */
	public function toFront() {
		parent.swapChildren(this, parent.getChildAt(parent.numChildren - 1));
	}
	
	public function setConsoleFont(font:String = null, embed:Bool = false, size:Int = 14, bold:Bool = false, italic:Bool = false, underline:Bool = false ){
		#if (flash || html5)
		if (font == null) {
		#else
		if (font == null && Sys.systemName() == "Windows") {
		#end
			font = "Consolas";
		}
		embed ? txtConsole.embedFonts = true : txtConsole.embedFonts = false;
		txtConsole.defaultTextFormat = new TextFormat(font, size, DCThemes.current.CON_TXT_C, bold, italic, underline, '', '', TextFormatAlign.LEFT, margin, margin);
		// TODO - redraw console here?
	}
	
	
	public function setPromptFont(font:String = null, embed:Bool = false, size:Int = 16, bold:Bool = false, ?italic:Bool = false, underline:Bool = false ){
		#if (flash || html5)
		if (font == null) {
		#else
		if (font == null && Sys.systemName() == "Windows") {
		#end
			font = "Consolas";
		}
		embed ? txtPrompt.embedFonts = true : txtPrompt.embedFonts = false;
		txtPrompt.defaultTextFormat = new TextFormat(font, size, DCThemes.current.PRM_TXT_C, bold, italic, underline, '', '' , TextFormatAlign.LEFT);
		// TODO - redraw console here?
	}
	
	public function setProfilerFont(font:String = null, embed:Bool = false, size:Int = 14, bold:Bool = false, ?italic:Bool = false, underline:Bool = false ){
		#if (flash || html5)
		if (font == null) {
		#else
		if (font == null && Sys.systemName() == "Windows") {
		#end
			font = "Consolas";
		}
		
		embed ? txtProfiler.embedFonts = true : txtProfiler.embedFonts = false;
		txtProfiler.defaultTextFormat = new TextFormat(font, size, DCThemes.current.MON_TXT_C, bold, italic, underline, '', '', TextFormatAlign.LEFT, 10,10);
	}
	
	public function setMonitorFont(font:String = null, embed:Bool = false, size:Int = 14, bold:Bool = false, ?italic:Bool = false, underline:Bool = false ){
		#if (flash || html5)
		if (font == null) {
		#else
		if (font == null && Sys.systemName() == "Windows") {
		#end
			font = "Consolas";
		}
		
		embed ? txtMonitorLeft.embedFonts = true : txtMonitorLeft.embedFonts = false;
		embed ? txtMonitorRight.embedFonts = true : txtMonitorRight.embedFonts = false;
		txtMonitorLeft.defaultTextFormat = new TextFormat(font, size, DCThemes.current.MON_TXT_C, bold, italic, underline, '', '', TextFormatAlign.LEFT, 10,10);
		txtMonitorRight.defaultTextFormat = new TextFormat(font, size, DCThemes.current.MON_TXT_C, bold, italic, underline, '', '', TextFormatAlign.LEFT, 10,10);
	}
	
	/**
	 * Removes last input char
	 */
	public function inputRemoveLastChar() {
		if (txtPrompt.text.length > 0) {
			txtPrompt.text = txtPrompt.text.substr(0, txtPrompt.text.length - 1);
		}
	}
	
	
	public function getInputTxt():String {
		return txtPrompt.text;
	}
	
	
	public function setInputTxt(string:String) {
		txtPrompt.text = string;
	}
	
	
	public function getConsoleText():String {
		return txtConsole.text;
	}
	
	
	public function clearInput() {
		txtPrompt.text = "";
	}
	
	
	public function clearConsole() {
		txtConsole.text = "";
	}

	
}