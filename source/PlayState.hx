package;

import flixel.*;
import openfl.display.Shader;

class PlayState extends FlxState
{

    var runTime:Float = 0;

    // The sprite that the shader is put over
    var s:FlxSprite;

    // The shader itself
    var waterShader:Water;

    // Default size of the sprite
    var w(default,set):Int = 180;
    var h(default,set):Int = 180;

    var res:GLShaderParameter;
    var time:GLShaderParameter;

    override public function create():Void
    {
        super.create();

        s = new FlxSprite();
        s.makeGraphic(180, 180, 0xffff0000);
        s.shader = waterShader = new Water();
        s.x = FlxG.width /2 - s.width /2;
        s.y = FlxG.height/2 - s.height/2;
        add(s);

        // Set up the resolution shader.
        res = new GLShaderParameter("vec2",2);
        res.value = [s.width,s.height];
        waterShader.data["iResolution"] = res;

        // I don't want this shader to change based on mouse position!
        var mouse:GLShaderParameter = new GLShaderParameter("vec4",4);
        mouse.value = [
            0,0,
            FlxG.mouse.pressed ? 1 : 0,
            FlxG.mouse.pressedRight ? 1 : 0 ];
        waterShader.data['iMouse'] = mouse;

        time = new GLShaderParameter("float",1);
        time.value = [runTime];
        waterShader.data['iTime'] = time;
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        runTime += elapsed;

        time.value = [runTime];
        res.value = [s.width,s.height];

        var speed = FlxG.width*elapsed/2;
        if(FlxG.keys.pressed.UP) s.y -= speed;
        if(FlxG.keys.pressed.DOWN) s.y += speed;
        if(FlxG.keys.pressed.LEFT) s.x -= speed;
        if(FlxG.keys.pressed.RIGHT) s.x += speed;

        if(FlxG.keys.pressed.MINUS) s.angle += 1;
        if(FlxG.keys.pressed.PLUS) s.angle -= 1;

        if(FlxG.keys.pressed.ONE) w+=1;
        if(FlxG.keys.pressed.TWO) w-=1;
        if(FlxG.keys.pressed.THREE) h+=1;
        if(FlxG.keys.pressed.FOUR) h -= 1;
    }

    inline function nextPower(k:Int) {
        var n=1;
        while(n < k)
            n*=2;
        return Std.int(n);
    }

    function set_w(W:Int):Int {
        s.makeGraphic(W,h,0xffff0000);
        return w=W;
    }
    function set_h(H:Int):Int {
        s.makeGraphic(w,H,0xffff0000);
        return h=H;
    }

}
