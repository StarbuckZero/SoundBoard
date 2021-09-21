import openfl.events.Event;
import openfl.events.MouseEvent;
import com.chaos.ui.classInterface.IButton;
import openfl.display.DisplayObject;
import com.chaos.ui.UIStyleManager;
import com.chaos.ui.TabPane;
import com.chaos.ui.Button;

class SoundTabPane extends TabPane 
{
    public function new(data:Dynamic = null)
    {
        super(data);
    }

    override function addItem(value:String, content:DisplayObject):Dynamic {
        
        var obJ:Dynamic = super.addItem(value, content);
        var button:IButton = getTabButton(buttonArea.numChildren - 1);

        button.textColor = _tabButtonTextColor;
        button.defaultColor = _tabButtonNormalColor;
        button.overColor = _tabButtonOverColor;
        button.downColor = _tabButtonSelectedColor;
        button.disableColor = _tabButtonDisableColor;

        return obJ;

    }

    override function draw() {


		if (null == _contentList)
			return;

		//super.draw();

		// Create and resize buttons
		for (i in 0 ... buttonArea.numChildren)
		{

			// Setting up buttons
            var button:Button = cast(buttonArea.getChildAt(i), Button);
			
			// Update all the i
			_contentList.getItemAt(i).id = i;
			
			button.name = Std.string(i);
			button.width = width / buttonArea.numChildren;
			button.height = _tabButtonHeight;
			button.x = button.width * i;
			button.y = 0;

			// Set TextFormat based on UIStyleManager
			if(UIStyleManager.hasStyle(UIStyleManager.TABPANE_BUTTON_TEXT_BOLD))
				button.textBold = UIStyleManager.getStyle(UIStyleManager.TABPANE_BUTTON_TEXT_BOLD);

			if(UIStyleManager.hasStyle(UIStyleManager.TABPANE_BUTTON_TEXT_ITALIC))
			 button.textItalic = UIStyleManager.getStyle(UIStyleManager.TABPANE_BUTTON_TEXT_ITALIC);


			if(UIStyleManager.hasStyle(UIStyleManager.TABPANE_BUTTON_TEXT_SIZE))
			 	button.textSize = UIStyleManager.getStyle(UIStyleManager.TABPANE_BUTTON_TEXT_ITALIC);

			if(UIStyleManager.hasStyle(UIStyleManager.TABPANE_BUTTON_TEXT_FONT))
				button.textFont = UIStyleManager.getStyle(UIStyleManager.TABPANE_BUTTON_TEXT_FONT);

			if(UIStyleManager.hasStyle(UIStyleManager.TABPANE_BUTTON_TEXT_EMBED))
				button.label.setEmbedFont(UIStyleManager.getStyle(UIStyleManager.TABPANE_BUTTON_TEXT_EMBED));

			if(UIStyleManager.hasStyle(UIStyleManager.TABPANE_BUTTON_TINT_ALPHA))
				button.borderAlpha = UIStyleManager.getStyle(UIStyleManager.TABPANE_BUTTON_TINT_ALPHA);
				
			button.draw();

		}

		// Set location of scroll pane
		buttonArea.x = 0;
		buttonArea.y = 0;
		
		_scrollPane.width = _width;
		_scrollPane.height = _height - _tabButtonHeight;
		_scrollPane.y = _tabButtonHeight;

		// Load in content
		if (_contentList.length > 0 && _contentList.getItemAt(_selectedIndex).content != null)
		{
			cast(buttonArea.getChildByName(Std.string(_selectedIndex)), Button).enabled = false;
			contentLoad(_contentList.getItemAt(_selectedIndex).content);
		}

		_scrollPane.update();
		_scrollPane.draw();

    }

    override function tabPress(event:MouseEvent) {
        //super.tabPress(event);

		var button:Button =  cast(event.currentTarget, Button);
		var oldButton:Button = cast(buttonArea.getChildByName(Std.string(_selectedIndex)), Button);

		if (_selectedIndex != Std.parseInt(button.name))
		{
			// Current Button
			button.enabled = false;

			// Disable old one
			oldButton.enabled = true;
			
			button.draw();
			oldButton.draw();

			// Update selected index and grab new content
			_selectedIndex = Std.parseInt(button.name);
			contentLoad(cast(_contentList.getItemAt(Std.parseInt(button.name)).content, DisplayObject));

			dispatchEvent(new Event(Event.CHANGE));
			
		}        


    }

}