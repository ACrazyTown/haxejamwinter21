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
        "Hamster balls aren't rockproof, y'know?",
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
        oopsText.alpha = 0;
        oopsText.screenCenter(X);
        oopsText.color = FlxColor.WHITE;
        add(oopsText);

        var funnyText:FlxText = new FlxText(0, oopsText.y + 100, 0, texts[Util.getRandomInt(texts.length)], 24);
        funnyText.screenCenter(X);
        funnyText.alpha = 0;
        funnyText.color = FlxColor.WHITE;
        add(funnyText);

        FlxTween.tween(oopsText, {alpha: 1}, 2.25, {onComplete: function(tween:FlxTween)
        {
            FlxTween.tween(funnyText, {alpha: 1}, 4);
        }});
        
    }

    override function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.R)
            FlxG.switchState(new PlayState());

        super.update(elapsed);
    }
}