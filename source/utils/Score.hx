package utils;

import flixel.FlxBasic;
import flixel.text.FlxText;

class Score extends FlxBasic
{
    public var score:Int = 0;

    public var aliveTime:Int = 0;
    public var goodHits:Int = 0;
    public var badHits:Int = 0;

    public function updateScore(scoreText:FlxText)
    {
        score = calculateScore();
        scoreText.text = "Score: " + score;
    }

    public function calculateScore()
    {
        return (((aliveTime * 10) + Std.int(goodHits * 2.5)) - Std.int(badHits * 5)); // Higher penalty for bad hits
    }
}