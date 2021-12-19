package utils;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxSubState;

typedef DialogueData = {
    dialogue:Array<String>,
    dialogueIndex:Int,
    dialogueTime:Array<Float>
}

class Cutscene extends FlxSubState
{
    public var hasDialogue:Bool = false;
    public var dialogue:DialogueData;
    public var defaultDialogueText:String = "You should not be seeing this... oops";

    private var canTime:Bool = false;

    public var dialogueTimer:Float = 0;
    public var dialogueText:FlxText;

    public var onFinish:Void->Void;

    public function new(hasDialog:Bool)
    {
        super();
        hasDialogue = hasDialog;

        if (hasDialogue && dialogue == null || hasDialogue && dialogue.dialogue == [])
            dialogue = {
                dialogue: [defaultDialogueText],
                dialogueIndex: 0,
                dialogueTime: [0]
            }
    }

    override function update(elapsed:Float)
    {
        if (canTime)
            dialogueTimer += elapsed;

		FlxG.watch.addQuick("dialogueTimer", dialogueTimer);
		FlxG.watch.addQuick("dialogueTime", dialogue.dialogueTime[dialogue.dialogueIndex]);

        updateDialogue();
        super.update(elapsed);
    }

    function startDialogue(X:Float = 0, Y:Float = 0, Size:Int = 8)
    {
		dialogueText = new FlxText(X, Y, 0, "Ballsucking", Size);
		dialogueText.setFormat(null, Size);
		dialogueText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(dialogueText);

        canTime = true;
    }

    function updateDialogue()
    {
        // todo WORK ON ACTUAL GAME L OL
        // todo Figure out how to not make it crash
        if (dialogueTimer >= dialogue.dialogueTime[dialogue.dialogueIndex])
        {
            dialogueText.text = dialogue.dialogue[dialogue.dialogueIndex];
            dialogue.dialogueIndex++;
        }
    }
}

class IntroCutscene extends Cutscene
{
    public function new()
    {
        super(true);

        dialogue = {
            dialogue: ["Test 1 LOL!", "Test 2 LMAO!", "aw"],
            dialogueIndex: 0,
            dialogueTime: [0, 5, 7.5]
        }
        
        //var overlay:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        //add(overlay);

        startDialogue(FlxG.width * 0.5, FlxG.height * 0.15, 32);
        //constructAssets();
    }

    function constructAssets()
    {

    }
}