

import com.chaos.ui.classInterface.IBaseUI;
import com.chaos.ui.classInterface.IOverlay;
import com.chaos.ui.classInterface.IButton;
import com.chaos.ui.Button;

class SoundButton extends Button implements IButton implements IBaseUI
{

    public var soundName:String = "";
    public var loop:Bool = false;
    public var music:Bool = false;
    public var soundDataList:Array<Dynamic>;

    public function new( dataObj : Dynamic)
    {
        super(dataObj);

        buttonMode = true;
    }

    override function setComponentData(data:Dynamic) 
    {
        super.setComponentData(data);

        if(Reflect.hasField(data,"SoundName"))
            soundName = Reflect.field(data,"SoundName");

        if(Reflect.hasField(data,"Loop"))
            loop = Reflect.field(data,"Loop");

        if(Reflect.hasField(data,"Music"))
            music = Reflect.field(data,"Music");

    } 
}