package states;

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

	var spawnTimer:FlxTimer;

	var objects:FlxTypedGroup<CollidableObject>;
	var player:Player;

	var score:Score;
	var scoreText:FlxText;

	override public function create()
	{
		FlxG.fixedTimestep = true;

		var background:FlxSprite = new FlxSprite().loadGraphic("assets/images/backdrop.png");
		background.color = FlxColor.GREEN;
		add(background);

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

		FlxG.watch.addQuick('Objects', objects.length);
		FlxG.watch.addQuick('Lives', player.lives);

		aliveTime += elapsed;

		score.aliveTime = Std.int(Util.truncateFloat(aliveTime, 2));
		score.updateScore(scoreText);

		updateObjects();
	}

	function updateObjects()
	{
		objects.forEachAlive(function(obj:CollidableObject)
		{
			// Kill
			if (obj.isOnScreen(FlxG.camera) && obj.y < -100)
			{
				obj.kill();
				objects.remove(obj);
				obj.destroy();
			}

			// Collision
			if (FlxG.overlap(player, obj))
			{
				/*
				if (!obj.good)
				{
					score.badHits += 1;
					player.lives -= 1;

					obj.kill();
					objects.remove(obj);
					obj.destroy();

					if (player.lives <= 0)
						openSubState(new GameOverSubstate());
				}
				else
				{
					score.goodHits += 1;

					obj.kill();
					objects.remove(obj);
					obj.destroy();
				}
				*/

				obj.onCollision();
				
				obj.kill();
				objects.remove(obj);
				obj.destroy();
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
			else if (FlxG.random.bool(35))
				daType = 1;
			else if (FlxG.random.bool(15))
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
						// TODO: ICE
						trace("TODO: ICE!!!");
				}
			};
			objects.add(dumbass);
		}, 0);
	}

	function openSubstate(SubState:FlxSubState)
	{
		super.openSubState(SubState);
	}
}
