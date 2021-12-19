package states;

import flixel.util.FlxTimer;
import flixel.util.FlxTimer.FlxTimerManager;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

using StringTools;

class PauseSubstate extends FlxSubState
{
    var optionArray:Array<String> = ["Continue", "Return to Menu"];
    var optionGroup:FlxTypedGroup<FlxText>;

    var curSelected:Int = 0;

    public function new()
    {
        super();

        FlxTimer.globalManager.active = false;
        FlxG.sound.music.pause();

        var overlay:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        overlay.alpha = 0.6;
        add(overlay);

		optionGroup = new FlxTypedGroup<FlxText>();
		add(optionGroup);

        var pausedText:FlxText = new FlxText(-FlxG.width, 120, 0, "PAUSED", 144);
        add(pausedText);

        var scoreText:FlxText = new FlxText(-400, (pausedText.y + pausedText.height) + 5, 0, "Current Score: " + PlayState.score.score, 24);
        add(scoreText);

        FlxTween.tween(pausedText, {x: 100}, 2, {ease: FlxEase.expoInOut});
		FlxTween.tween(scoreText, {x: 100}, 2.25, {ease: FlxEase.expoInOut});

        for (i in 0...optionArray.length)
        {
            var item:FlxText = new FlxText(-400, i * 70, 0, optionArray[i], 32);
            item.y += 480;
            item.ID = i;
            optionGroup.add(item);

            FlxTween.tween(item, {x: 100}, 1.5, {ease: FlxEase.expoInOut});
        }

        changeSelection();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ENTER)
            acceptOption();

        if (FlxG.keys.justPressed.UP)
            changeSelection(-1);
        if (FlxG.keys.justPressed.DOWN)
            changeSelection(1);
    }

	function changeSelection(change:Int = 0)
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = optionArray.length - 1;
		if (curSelected > optionArray.length - 1)
			curSelected = 0;

		optionGroup.forEach(function(txt:FlxText)
		{
            txt.text = txt.text.replace(">", "");
			txt.color = FlxColor.WHITE;

			if (txt.ID == curSelected)
			{
                txt.color = FlxColor.YELLOW;
				txt.text = ">" + txt.text;
			}
		});
	}

    function acceptOption()
    {
        switch (curSelected)
        {
            case 0:
				FlxG.sound.music.play();
                close();
            case 1:
                FlxG.switchState(new states.TitleState());
        }

        FlxTimer.globalManager.active = true;
    }
}