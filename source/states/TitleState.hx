package states;

import utils.GameData;
import lime.system.System;
import lime.app.Application;
import flixel.ui.FlxButton.FlxTypedButton;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxState;

using StringTools;

class TitleState extends FlxState
{
    #if desktop
    var options:Array<String> = ["Play", "Exit"];
    #else
    var options:Array<String> = ["Play"];
    #end

    var optionsGroup:FlxTypedGroup<FlxText>;
    var curSelected:Int = 0;

    override function create()
    {
        FlxG.autoPause = true;
        FlxG.camera.bgColor = 0xFF20202E;

        optionsGroup = new FlxTypedGroup<FlxText>();
        add(optionsGroup);

        FlxG.sound.playMusic("assets/music/introsong" + GameData.audioExtension, 0);
        FlxG.sound.music.fadeIn(3, 0, 1);

		for (i in 0...options.length)
		{
			var item:FlxText = new FlxText(FlxG.width * 1.5, i * 120, 0, options[i], 120);
            item.setFormat("assets/fonts/futura.ttf", 120, FlxColor.WHITE, FlxTextAlign.RIGHT);
			item.y += 320;
			item.ID = i;
			optionsGroup.add(item);

			FlxTween.tween(item, {x: FlxG.width - 400}, 1 + (i * 0.25), {ease: FlxEase.expoInOut});
		}

        var credits:FlxText = new FlxText(10, FlxG.height - 40, 0, "By A Crazy Town & DakotaDepresso | v1.0 (JAM VERSION)", 24);
        credits.alpha = 0;
        credits.setFormat("assets/fonts/futura.ttf", 24);
        add(credits);

        FlxTween.tween(credits, {alpha: 1}, 1.75);

        var logo:FlxSprite = new FlxSprite().loadGraphic("assets/images/logowhite.png");
        //logo.color = FlxColor.WHITE;
        logo.antialiasing = true;
        logo.screenCenter();
        add(logo);

        new FlxTimer().start(1.25, function(tmr:FlxTimer)
        {
			FlxTween.tween(logo, {x: 50, y: 50, angle: -5}, 2.25, {ease: FlxEase.expoInOut});
        });

        changeSelection();
        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ENTER)
            doOption();
        if (FlxG.keys.justPressed.UP)
            changeSelection(-1);
        if (FlxG.keys.justPressed.DOWN)
            changeSelection(1);
    }

    function doOption()
    {
        switch (curSelected)
        {
            case 0: FlxG.switchState(new states.PlayState());
            #if !html5
            case 1: System.exit(0);
            #end
        }
    }

	function changeSelection(change:Int = 0)
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected > options.length - 1)
			curSelected = 0;

		optionsGroup.forEach(function(txt:FlxText)
		{
			txt.color = FlxColor.WHITE;

			if (txt.ID == curSelected)
			{
				txt.color = FlxColor.YELLOW;
			}
		});
	}
}