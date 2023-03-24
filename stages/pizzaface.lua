local objects = {
    camera = 'camGame',
    path = 'pizzaface/',
    scale = 3.5,
    x = -1300,
    y = -420
}
function onCreate()
    luaDebugMode = true
    addHaxeLibrary('ColorSwap')
    addHaxeLibrary('FlxBackdrop','flixel.addons.display')
    --addHaxeLibrary('FlxAxes','flixel.util')

    makeLuaSprite('background',objects.path..'background',objects.x,objects.y)
    setProperty('background.antialiasing',false)
    scaleObject('background',objects.scale,objects.scale)
    addLuaSprite('background')


    col = 'FF2C00'
    runHaxeCode([[
        clouds = new FlxBackdrop(Paths.image('pizzaface/clouds') , 0x01, -0, -0);
        clouds.scale.set(3, 3);
        clouds.antialiasing = false;
        clouds.setPosition(-1300,-200);
        clouds.updateHitbox();
        game.addBehindGF(clouds);
        clouds.velocity.set(250,0);

        tinyclouds = new FlxBackdrop(Paths.image('pizzaface/phase3-clouds') , 0x01, -0, -0);
        tinyclouds.scale.set(3.5, 3.5);
        tinyclouds.antialiasing = false;
        tinyclouds.setPosition(-1300,-300);
        tinyclouds.updateHitbox();
        game.addBehindGF(tinyclouds);
        tinyclouds.velocity.set(300,0);


        clouds.color = 0xFF]]..col..[[;
        tinyclouds.color = 0xFF]]..col..[[;

        //game.initLuaShader('test');
        //test = game.createRuntimeShader('test');

        //game.camHUD.setFilters([new ShaderFilter(test)]);
    ]])

    makeAnimatedLuaSprite('lightning',objects.path..'lightning',-900,-200)
    addAnimationByPrefix('lightning','bop','lightning bop',16,false)
    setProperty('lightning.antialiasing',false)
    scaleObject('lightning',objects.scale,objects.scale)
    addLuaSprite('lightning')
    setProperty('lightning.visible',false)

    makeLuaSprite('ground',objects.path..'ground',objects.x,objects.y)
    setProperty('ground.antialiasing',false)
    scaleObject('ground',objects.scale,objects.scale)
    addLuaSprite('ground')

    makeLuaSprite('platform',objects.path..'platform',objects.x,objects.y)
    setProperty('platform.antialiasing',false)
    scaleObject('platform',objects.scale,objects.scale)
    addLuaSprite('platform')
    
    makeLuaSprite('blackoverlay',nil,0,0)
    makeGraphic('blackoverlay',1280,720,'000000')
    scaleObject('blackoverlay',5,5)
    screenCenter('blackoverlay','xy')
    setScrollFactor('blackoverlay',0,0)
    setProperty('blackoverlay.alpha',0.5)
    addLuaSprite('blackoverlay',true)

    makeAnimatedLuaSprite('rain',objects.path..'rain',objects.x,objects.y)
    addAnimationByPrefix('rain','bop','rain bop',24,true)
    setProperty('rain.antialiasing',false)
    scaleObject('rain',objects.scale,objects.scale)
    addLuaSprite('rain',true)
end
function onSongStart()
    runTimer('BOAH',3)
end
function onCreatePost()
    debugPrint('THE CONTROLS ARE [A, D, X, V, SPACE]')
    setProperty('gf.visible',false)
    setProperty('boyfriend.visible',false)
    scaleObject('dad',3,3)
end
local hudZoom = 0.7 --set the value of camhud zoom
local xx = 140
local yy = 610
function onUpdate(elapsed)
    if keyboardJustPressed('E') then
        lightning()
    end

    --runHaxeCode("test.setFloat('iTime',"..os.clock()..");")
    if getProperty('peppino.animation.curAnim.name'):find('punches') then
        xx = getProperty('peppino.x')
        yy = getProperty('peppino.y')
    else
        xx = 140
        yy = 610
    end

	triggerEvent('Camera Follow Pos',xx,yy)
    setProperty('camHUD.zoom',lerp(getProperty('camHUD.zoom'),
    1, --preventing the lerp zoom becoming stupid
    boundTo(elapsed * 7 * getProperty('camZoomingDecay') * getProperty('playbackRate'),0,1)))
end

function onBeatHit()
    runHaxeCode([[
        game.camHUD.zoom += 0.05;
    ]])
end

function lightning()
    playAnim('lightning','bop',true)
    playSound('pizza/lightning',1,'buhe')
    cameraShake('camGame',0.02,1)
    setProperty('lightning.x',getRandomInt(-900,900))
    setProperty('lightning.visible',true)
    doTweenAlpha('blackoverlay','blackoverlay',0,0.2)
    runTimer('ohshit',1)
end

function onTimerCompleted(t)
    if t == 'BOAH' then
        lightning()
    end
    if t == 'ohshit' then
        runTimer('BOAH',getRandomInt(6,10))

        setProperty('lightning.visible',false)
        doTweenAlpha('blackoverlay','blackoverlay',0.5,0.2)
    end
end

function lerp(a,b,t) return a * (1-t) + b * t end

function boundTo(val, min, max)
    if val < min then
        return min
    elseif val > max then
        return max
    else
        return val
    end
end