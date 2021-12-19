package states;

import flixel.tweens.FlxTween;
import utils.Util;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSplash;
import flixel.FlxSubState;

class GameOverSubstate extends FlxSubState
{
    var texts:Array<String> = [
        "You're dead...",
        "Hampster balls aren't rockproof, y'know?",
        "Try not slamming into a boulder next time...",
        "Yikes..",
        "You had like... 3 chances, and yet you still failed.",
        "Welp."
    ];

    public function new()
    {
        super();

        var overlay:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        overlay.alpha = 0.7;
        add(overlay);

        var oopsText:FlxText = new FlxText(0, 100, 0, "Ooops!", 64);
        oopsText.screenCenter(X);
        oopsText.color = FlxColor.WHITE;
        add(oopsText);

        var funnyText:FlxText = new FlxText(0, oopsText.y + 100, 0, texts[Util.getRandomInt(texts.length)], 24);
        funnyText.screenCenter(X);
        funnyText.alpha = 0;
        funnyText.color = FlxColor.WHITE;
        add(funnyText);

        var shit:FlxText = new FlxText(0, funnyText.y + 200, 0, "Press R to retry\nPress Q to quit", 32);
        shit.screenCenter(X);
        add(shit);

        FlxTween.tween(funnyText, {alpha: 1}, 3);
		FlxTween.tween(shit, {alpha: 1}, 2.5);
    }

    override function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.R)
            FlxG.switchState(new PlayState());
        if (FlxG.keys.justPressed.Q)
            FlxG.switchState(new TitleState());

        super.update(elapsed);
    }
}