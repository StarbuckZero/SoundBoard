package;

#if !html5
import sys.FileSystem;
#end
import com.chaos.ui.layout.BaseContainer;
import com.chaos.media.SoundManager;
import com.chaos.ui.ScrollPolicy;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.media.SoundChannel;
import com.chaos.ui.layout.VerticalContainer;
import openfl.media.Sound;
import com.chaos.ui.ScrollPane;
import openfl.events.MouseEvent;
import com.chaos.ui.Menu;
import com.chaos.ui.data.MenuItemObjectData;
import com.chaos.data.DataProvider;
import com.chaos.ui.TabPane;
import SoundButton;
import haxe.Json;
import openfl.utils.Assets;
import openfl.display.Sprite;
import openfl.Lib;

/**
 * ...
 * @author Erick Feiling
 */
class Main extends Sprite {
	private static var BUTTON_FONT_SIZE:Int = 14;

	private var _dataObj:Dynamic;

	private var _tabArea:SoundTabPane;

	private var _scrollPanel:ScrollPane;
	private var _buttonHeight:Int;

	private var _soundName:String;
	private var _musicName:String;
	private var _currentButton:SoundButton;

	private var _soundManager:SoundManager;
	private var _currentMusic:SoundChannel;
	private var _currentSoundFX:SoundChannel;

	private var defaultTextColor:Int = 0x000000;
	private var defaultButtonColor:Int = 0xCCCCCC;


	public function new() {
		super();

		init();

		// TODO: If Icon is founded force to be 40x40

		// TODO: If no icon use default

		// Assets:
		// openfl.Assets.getBitmapData("img/assetname.jpg");

		addEventListener(Event.ADDED_TO_STAGE, onAddToStage, false, 0, true);
	}

	private function onAddToStage(event:Event):Void {
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		stage.addEventListener(Event.RESIZE, onResize, false, 0, true);
	}

	private function onResize(event:Event):Void {
		_tabArea.y = _tabArea.x = 0;

		_tabArea.width = Std.int(stage.stageWidth);
		_tabArea.height = Std.int(stage.stageHeight);
		_scrollPanel.height = Std.int(stage.stageHeight - _buttonHeight);

		// Upload scroll panel location
		if (_currentButton != null && _scrollPanel.parent != null) {
			_scrollPanel.x = _currentButton.x + _scrollPanel.width;
			_scrollPanel.y = _buttonHeight + 6;
		}

		if (_tabArea.selectedIndex >= 0) {
			_tabArea.getSelectedItem().content.width = Std.int(_tabArea.width);
			_tabArea.getSelectedItem().content.height = Std.int(_scrollPanel.height);

			cast(_tabArea.getSelectedItem().content, VerticalContainer).draw();
		}

		_tabArea.draw();
		_scrollPanel.draw();
		_tabArea.scrollPane.draw();
	}

	private function init():Void {
		// Grab JSON Data file
		if (Assets.exists("data/menu.json")) {
			trace(FileSystem.absolutePath(""));

			_soundManager = new SoundManager();

			_dataObj = Json.parse(Assets.getText("data/menu.json"));

			// Start building out Tab Menu
			if (Reflect.hasField(_dataObj, "SoundBoard")) {

				_tabArea = new SoundTabPane();
				var soundBoardList:Array<Dynamic> = Reflect.field(_dataObj, "SoundBoard");

				_tabArea.width = stage.stageWidth;
				_tabArea.height = stage.stageHeight;
				_buttonHeight = _tabArea.tabButtonHeight;

				// Setup Scroll Panel Area for button
				_scrollPanel = new ScrollPane({"width": 200, "height": stage.stageHeight - _buttonHeight + 6});
				_scrollPanel.backgroundColor = 0;

				// Build buttons for tab
				for (i in 0...soundBoardList.length) {
					var buttonHolder:VerticalContainer = new VerticalContainer();
					buttonHolder.align = "left";
					buttonHolder.width = _tabArea.width;
					buttonHolder.height = stage.stageHeight - _buttonHeight;


					buttonHolder.name = Reflect.field(soundBoardList[i], "BoardName") + "_buttonHolder";

					// Make sure button list is there object
					if (Reflect.hasField(soundBoardList[i], "Button")) {
						var buttonList:Array<Dynamic> = Reflect.field(soundBoardList[i], "Button");

						trace(Reflect.field(soundBoardList[i],"TextColor"));

						// Start putting together menu data for buttons
						for (j in 0...buttonList.length) {

							var textColor : Int = (Reflect.hasField(buttonList[j],"TextColor")) ?  Std.parseInt(Reflect.field(buttonList[j],"TextColor")) : defaultTextColor;
							var buttonColor : Int = (Reflect.hasField(buttonList[j],"ButtonColor")) ?  Std.parseInt(Reflect.field(buttonList[j],"ButtonColor")) : defaultButtonColor;
							
							// Switch over to Sound Button Class
							var button:SoundButton = new SoundButton({
								"Label": {"textColor": textColor, "size": BUTTON_FONT_SIZE},
								"defaultColor":buttonColor,
								"text": Reflect.field(buttonList[j], "Name"),
								"width": 200,
								"height": 80
							});
							var soundDataList:Array<Dynamic> = Reflect.field(buttonList[j], "Sound");
							

							button.soundDataList = soundDataList;

							for (a in 0...soundDataList.length) {
								#if !html5
								_soundManager.load(Reflect.field(soundDataList[a], "Sound"),
									Std.string(FileSystem.absolutePath("") + "/sound/" + Reflect.field(soundDataList[a], "Sound") + ".ogg"));
								trace("Sound : "
									+ Reflect.field(soundDataList[a], "Sound")
									+ " => "
									+ FileSystem.exists(FileSystem.absolutePath("") + "/sound/" + Reflect.field(soundDataList[a], "Sound") + ".ogg"));
								#end
							}

							button.addEventListener(MouseEvent.CLICK, onSoundButtonClick, false, 0, true);
							buttonHolder.addElement(button);
						}

						_tabArea.addItem(Reflect.field(soundBoardList[i], "BoardName"), buttonHolder);
						_tabArea.getTabButton(i).addEventListener(MouseEvent.CLICK, onTabButtonClick, false, 0, true);

						 if(Reflect.hasField(soundBoardList[i],"TextColor"))
						 	_tabArea.getTabButton(i).textColor = Std.parseInt(Reflect.field(soundBoardList[i],"TextColor"));

						 if(Reflect.hasField(soundBoardList[i],"ButtonColor"))
						 	_tabArea.getTabButton(i).defaultColor = Std.parseInt(Reflect.field(soundBoardList[i],"ButtonColor"));
						
						_tabArea.getTabButton(i).draw();

					}
				}

				addChild(_tabArea);
			} else {
				trace("SoundBoard Object not found");
			}
		} else {
			// TODO: Create data file if one now found
			trace("Unabled to find file");
		}
	}

	private function onTabButtonClick(event:MouseEvent):Void {
		if (_scrollPanel.parent != null)
			removeChild(_scrollPanel);
	}

	private function onSoundButtonClick(event:MouseEvent):Void {
		_currentButton = cast(event.currentTarget, SoundButton);

		var buttonSoundInfoList:Array<Dynamic> = _currentButton.soundDataList;

		var subButtonHolder:BaseContainer = new BaseContainer({"width": 200, "height": (stage.stageHeight - (_buttonHeight + 6)), "background": false});

		for (i in 0...buttonSoundInfoList.length) {

			var textColor : Int = (Reflect.hasField(buttonSoundInfoList[i],"TextColor")) ?  Std.parseInt(Reflect.field(buttonSoundInfoList[i],"TextColor")) : defaultTextColor;
			var buttonColor : Int = (Reflect.hasField(buttonSoundInfoList[i],"ButtonColor")) ?  Std.parseInt(Reflect.field(buttonSoundInfoList[i],"ButtonColor")) : defaultButtonColor;

			var button:SoundButton = new SoundButton({
				"Label": {"textColor": textColor, "size": BUTTON_FONT_SIZE},
				"name": "button_" + i,
				"defaultColor":buttonColor,
				"Loop": Reflect.field(buttonSoundInfoList[i], "Loop"),
				"SoundName": Reflect.field(buttonSoundInfoList[i], "Sound"),
				"Music": Reflect.hasField(buttonSoundInfoList[i], "Music"),
				"text": Reflect.field(buttonSoundInfoList[i], "Name"),
				"width": 200,
				"height": 80
			});

			button.addEventListener(MouseEvent.CLICK, onPlaySoundbuttonClick, false, 0, true);

			button.x = 0;
			button.y = button.height * i;

			cast(subButtonHolder.content, Sprite).addChild(button);
		}

		_scrollPanel.x = _currentButton.x + _scrollPanel.width;
		_scrollPanel.y = _buttonHeight + 1;
		_scrollPanel.source = subButtonHolder;

		_scrollPanel.width = 200;
		_scrollPanel.height = subButtonHolder.height;

		subButtonHolder.draw();
		_scrollPanel.refreshPane();

		_scrollPanel.draw();

		addChild(_scrollPanel);
	}

	private function onPlaySoundbuttonClick(event:MouseEvent):Void {
		var soundButton:SoundButton = cast(event.currentTarget, SoundButton);

		// Come up with way to cache sound files after being loaded.
		if(_soundManager.getStatus(soundButton.soundName).playing)
		_soundManager.stopSound(soundButton.soundName);
			else
		_soundManager.playSound(soundButton.soundName);
	}
}
