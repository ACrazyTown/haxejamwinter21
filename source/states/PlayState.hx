package states;

import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import utils.Score;
import flixel.FlxSubState;
import props.CollidableObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import utils.Util;
import utils.GameData;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import props.Player;
import flixel.FlxState;
import utils.Cutscene.IntroCutscene;

class PlayState extends FlxState
{
	var aliveTime:Float = 0;
	var resetTime:Float = 0;

	var spawnTimer:FlxTimer;

	var objects:FlxTypedGroup<CollidableObject>;
	var destroyedObjects:Int = 0;

	var bg:FlxSprite;
	var player:Player;

	var score:Score;
	var scoreText:FlxText;

	var overlay:FlxSprite;

	override public function create()
	{
		FlxG.fixedTimestep = true;

		bg = new FlxSprite().loadGraphic("assets/images/backdrop.png");
		bg.color = FlxColor.GREEN;
		add(bg);

		objects = new FlxTypedGroup<CollidableObject>();
		add(objects);

		score = new Score();
		scoreText = new FlxText(5, 5, 0, "Score: 0", 24);
		scoreText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
		add(scoreText);

		player = new Player(50, 100);
		add(player);

		spawnStuff();

		super.create();
	}

	override public function update(elapsed:Float):Void
	{	
		super.update(elapsed);

		// debug watchers
		FlxG.watch.addQuick('Alive Time', aliveTime);
		FlxG.watch.addQuick('Reset Time', resetTime);
		FlxG.watch.addQuick('Destroyed Objects', destroyedObjects);
		FlxG.watch.addQuick('Lives', player.lives);

		aliveTime += elapsed;

		if (resetTime != 0 && aliveTime >= resetTime)
			resetIceEffect();

		score.aliveTime = Std.int(Util.truncateFloat(aliveTime, 2));
		score.updateScore(scoreText);

		updateObjects();
	}

	function updateObjects()
	{
		objects.forEachAlive(function(obj:CollidableObject)
		{
			// Kill
			if (!obj.isOnScreen(FlxG.camera) && obj.y < -100)
				removeObject(obj);

			// Collision
			if (FlxG.overlap(player, obj))
			{
				obj.onCollision();

				if (player.lives <= 0)
					openSubState(new GameOverSubstate());
				
				removeObject(obj);
			}
		});
	}

	function spawnStuff()
	{
		spawnTimer = new FlxTimer().start(GameData.spawnTimer, function(tmr:FlxTimer)
		{
			var xOffset:Int = Util.getRandomInt(Std.int(FlxG.width * 1.5));
			var daType:Int = 0;

			if (FlxG.random.bool(75))
				daType = 0;
			else if (FlxG.random.bool(40))
				daType = 1;
			else if (FlxG.random.bool(90))
				daType = 2;

			var dumbass:CollidableObject = new CollidableObject(xOffset * 1.5, FlxG.height + 400, daType);
			dumbass.setGraphicSize(Std.int(dumbass.width / 4), Std.int(dumbass.height / 4));
			dumbass.updateHitbox();
			dumbass.onCollision = function() {
				switch (dumbass.type)
				{
					case Rock:
						score.badHits += 1;
						player.lives -= 1;
					case Good:
						score.goodHits += 1;
					case Ice:
						FlxG.camera.flash(FlxColor.WHITE, 2.5);
						
						player.iced = true;
						resetTime = aliveTime + 12; // Effect lasts 12 seconds
						trace(resetTime);

						bg.color = FlxColor.WHITE;

						overlay = new FlxSprite().loadGraphic("assets/images/overlay.png");
						overlay.alpha = 0;
						add(overlay);

						FlxTween.tween(overlay, {alpha: 1}, 2.75);
				}
			};
			objects.add(dumbass);
		}, 0);
	}

	function resetIceEffect()
	{
		FlxTween.tween(overlay, {alpha: 0}, 2.25);
		
		player.iced = false;

		// if the bg is gonna be a completely new one then replace this!!
		FlxTween.color(bg, 1.75, FlxColor.WHITE, FlxColor.GREEN);

		resetTime = 0;
	}

	function removeObject(object:CollidableObject)
	{
		destroyedObjects += 1;

		object.kill();
		objects.remove(object);
		object.destroy();
	}

	function openSubstate(SubState:FlxSubState)
	{
		super.openSubState(SubState);
	}
}