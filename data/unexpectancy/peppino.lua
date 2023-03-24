local peppino = {
    frameRate = 16,
    x = 500,
    y = 860,
}
local GRAVITY = 2000
local JUMP_FORCE = -800
local FREEZE_TIME = 0.5

local playerY = 0
local playerVelocityY = 0
local freezeTimer = 0
local isJumping = false
local isFrozen = false
local boxY = 200 -- initial box position
local boxHeight = 50


function onCreatePost()
    luaDebugMode = true
    --[[makeAnimatedLuaSprite('peppino','pep',peppino.x,peppino.y)
    setProperty('peppino.antialiasing',false)
    scaleObject('peppino',3,3)
    addAnimationByPrefix('peppino','idle','pep idle0',peppino.frameRate,true)
    addAnimationByPrefix('peppino','walk','pep walk0',24,true)
    addAnimationByPrefix('peppino','jump','pep jump',24,false)
    addAnimationByPrefix('peppino','fall','pep fall',24,true)
    addAnimationByPrefix('peppino','crouch','pep crouch',24,false)
    addAnimationByIndicesLoop('peppino', 'idleC', 'pep idleC', '0,1,2,0,0,0,0,0,0,0,0,0,0,0,0', 12)
    --addAnimationByPrefix('peppino','idleC','pep idleC0',24,true)
    addAnimationByPrefix('peppino','walkC','pep walkC0',24,true)
    for i = 1,4 do
        addAnimationByPrefix('peppino','emote'..i,'pep emote'..i,24,false)
    end
    for i = 1,2 do
        addAnimationByPrefix('peppino','dis'..i,'pep disapoint'..i,24,false)
    end
    addAnimationByPrefix('peppino','emoteDance','pep emoteDance',24,true)
    addAnimationByPrefix('peppino','fall','pep fall',24,true)

    addLuaSprite('peppino')]]
    addHaxeLibrary('FlxObject','flixel')
    addHaxeLibrary('FlxKey','keyboard.input.flixel')

    runHaxeCode([[
        peppino = new Character(200,960,'peppinoP3');
        game.addBehindBF(peppino);
        game.variables.set('peppino',peppino);
        
    ]])

    makeLuaText('test','',500,100,0)
    setTextAlignment('test','center')
    setProperty('test.visible',false)
    addLuaText('test')

    makeLuaSprite('hitbox',nil,-650,980)
    makeGraphic('hitbox',130,20,'FFFFFF')
    addLuaSprite('hitbox')
    setProperty('hitbox.alpha',0.0)
    setObjectCamera('hitbox','camGame')
end
local isCrouching = false
local isWalking = true
local disapoint = true
local freeze = false
local fall = false
local disableMovement = false
local isPunching = false
local hitValue = 20
local hitHealth = 7
function onUpdatePost(elapsed)
    setProperty('peppino.y',960 + playerY)
    setTextString('test','peppinoX:'..getProperty('peppino.x')..'\npeppinoY:'..getProperty('peppino.y')..'\nBoyX:'..boxX..'\nBoyY:'..boxY)
end
function onUpdate(elapsed)
    if getProperty('peppino.animation.curAnim.name'):find('hit') then
		if getProperty('peppino.animation.curAnim.finished') then
		    charaPlayAnim('peppino','idle',true)
		end
	end

    if getProperty('peppino.animation.curAnim.name') == 'jump' then
		if getProperty('peppino.animation.curAnim.finished') and fall then
		    charaPlayAnim('peppino','fall',true)
		end
	end
    if getProperty('peppino.animation.curAnim.name') == 'turn' then
		if getProperty('peppino.animation.curAnim.finished') then
		    charaPlayAnim('peppino','walk',true)
		end
	end
    if getProperty('peppino.animation.curAnim.name') == 'punch' then
		if getProperty('peppino.animation.curAnim.finished') then
		    charaPlayAnim('peppino','idle',true)
		end
	end
    
    if getProperty('peppino.animation.curAnim.name') == 'fall' and not fall then
        if isWalking then
            charaPlayAnim('peppino','walk',true)
        else
            charaPlayAnim('peppino','idle',true)
        end
	end

    if getProperty('peppino.animation.curAnim.name') == 'grab' then
        if getProperty('peppino.animation.curAnim.finished') then
            charaPlayAnim('peppino','idle',true)
		end
	end



    if keyboardJustPressed('A') or keyboardJustPressed('D') then
        runTimer('step',0.1)
        if getProperty('peppino.animation.curAnim.name') == 'walk' then
            charaPlayAnim('peppino','turn',true)
        else
            if isCrouching then
                charaPlayAnim('peppino','walkC',true)
            else
                charaPlayAnim('peppino','walk',true)
            end
        end
        stopSound('breakdance')
    end
    --[[if keyboardJustPressed('C') then
        isFrozen = true
        cancelTimer('disapoint')
        playSound('parry',1)
        charaPlayAnim('peppino','emote'..getRandomInt(1,4),true)
        runTimer('idle',0.5)
        runTimer('breakdance',1)
    end
    if keyboardJustPressed('V') then
        cancelTimer('disapoint')
        playSound('breakdance',1,'breakdance')
        charaPlayAnim('peppino','emoteDance',true)
    end]]
    if isFrozen then
        freezeTimer = freezeTimer + elapsed
        if freezeTimer >= FREEZE_TIME then
            isFrozen = false
            freezeTimer = 0
        end
        return
    end

    playerVelocityY = playerVelocityY + GRAVITY * elapsed
    if keyboardJustPressed('SPACE') and not isJumping and not disableMovement then
        playSound('pizza/jump',1)
        cancelTimer('disapoint')
        if not isJumping then
            playerVelocityY = JUMP_FORCE
            isJumping = true
            fall = true
        end
        charaPlayAnim('peppino','jump',true)
        --doTweenY('peppinoJump','peppino',600,0.4,'cubeOut')
    end

    playerY = playerY + playerVelocityY * elapsed * 2
    if isPunching and overlap('dad', 'peppino') then
        setProperty('dad.flipX',getProperty('peppino.flipX'))
        if getProperty('peppino.flipX') then
            setProperty('dad.x',getProperty('peppino.x')-250)
        else
            setProperty('dad.x',getProperty('peppino.x')+250)
        end
    end


    if playerY >= 0 then
        playerY = 0
        playerVelocityY = 0
        isJumping = false
        fall = false
    end
    boxY = getProperty('dad.y')
    boxX = getProperty('dad.x')
    boxWidth = getProperty('dad.width')
    boxHeight = getProperty('dad.height')

    if keyboardJustPressed('X') then
        charaPlayAnim('peppino','grab',true)
        if getProperty('peppino.flipX') then
            doTweenX('peppinoGrab','peppino',getProperty('peppino.x')-600, 0.4, 'linear')
        else
            doTweenX('peppinoGrab','peppino',getProperty('peppino.x')+600, 0.4, 'linear')
        end
        disableMovement = true
    end
    if keyboardJustPressed('V') then
        doTweenZoom('camGamezoom','camGame',0.9,1,'expoOut')
        isPunching = true
        runTimer('punch',0.13)
        runTimer('hitHealth',0.5)
        runTimer('stopPunch',2.3)
        if getProperty('peppino.flipX') then
            charaPlayAnim('peppino','punchesLeft',true)
        else
            charaPlayAnim('peppino','punchesRight',true)
        end
        --disableMovement = true
    end
    if keyboardJustPressed('S') then
        --cancelTimer('disapoint')
        --isCrouching = true
        --charaPlayAnim('peppino','crouch',true)
    end
    if keyboardPressed('S') then
        --runTimer('isCrouching',0.02)
    end
    if not disableMovement then
        if keyboardPressed('A') then
            isWalking = true
            setProperty('peppino.flipX',true)
            runTimer('idle',0.02)
            if isCrouching then
                setProperty('peppino.x',lerp(getProperty('peppino.x'),getProperty('peppino.x') - 105 , boundTo(elapsed * 5, 0, 1)))
            else
                setProperty('peppino.x',lerp(getProperty('peppino.x'),getProperty('peppino.x') - 205 , boundTo(elapsed * 5, 0, 1)))
            end
        end
        if keyboardPressed('D') then
            isWalking = true
            setProperty('peppino.flipX',false)
            runTimer('idle',0.02)
            if isCrouching then
                setProperty('peppino.x',lerp(getProperty('peppino.x'),getProperty('peppino.x') + 105 , boundTo(elapsed * 5, 0, 1)))
            else
                setProperty('peppino.x',lerp(getProperty('peppino.x'),getProperty('peppino.x') + 205 , boundTo(elapsed * 5, 0, 1)))
            end
        end
    end
end

function onTweenCompleted(t)
    if t == 'peppinoJump' then
        charaPlayAnim('peppino','fall',true)
        doTweenY('peppinoJumpBack','peppino',960,0.3,'linear')
        --runTimer('peppinoFall',0.05)
    end
    if t == 'peppinoJumpBack' then
        charaPlayAnim('peppino','idle',true)
    end
    if t == 'peppinoGrab' then
        disableMovement = false
    end
end
function onTimerCompleted(t)
    if t == 'stopPunch' then
        isPunching = false
        doTweenZoom('camGamezoom','camGame',0.445,2,'expoOut')
        charaPlayAnim('peppino','hit'..getRandomInt(1,2),true)
        if getProperty('peppino.flipX') then
            doTweenX('boyfrined','dad',getProperty('dad.x') - 500,1,'backOut')
        else
            doTweenX('boyfrined','dad',getProperty('dad.x') + 500,1,'backOut')
        end
    end
    if t == 'hitHealth' and isPunching then
        setPropertyFromGroup('strumLineNotes',hitHealth,'color',getColorFromHex('000000'))
        hitHealth = hitHealth - 1
        runTimer('hitHealth',0.5)
    end
    if t == 'punch' and getProperty('peppino.animation.curAnim.name'):find('punches') then
        if getProperty('peppino.flipX') then
            setProperty('peppino.x',getProperty('peppino.x')- 30)
        else
            setProperty('peppino.x',getProperty('peppino.x')+ 30)
        end
        runTimer('punch',0.13)
        playSound('pizza/punch',1,'punch')
    end
    if t == 'step' and getProperty('peppino.animation.curAnim.name') == 'walk' or getProperty('peppino.animation.curAnim.name') == 'turn' then
        runTimer('step',0.3)
        playSound('pizza/step',1,'step')
    end
    if t == 'disapoint' then
        --charaPlayAnim('peppino','dis'..getRandomInt(1,2))
    end
    if t == 'isCrouching' then
        isCrouching = false
        runTimer('idle',0.01)
    end
    if t == 'peppinoFall' then
        charaPlayAnim('peppino','fall',true)
        doTweenY('peppinoJumpBack','peppino',860,0.2,'linear')
    end
    if t == 'idle' then
        isWalking = false
        --runTimer('disapoint',3)
        if isCrouching then
            charaPlayAnim('peppino','idleC',true)
        else
            charaPlayAnim('peppino','idle',true)
        end
    end
end

function charaPlayAnim(tag,anim,force)
    runHaxeCode([[
        ]]..tag..[[.playAnim(']]..anim..[[',true);
    ]])
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
function overlap(obj1, obj2)
    if getProperty(obj1..'.x') + 0 >= getProperty(obj2..'.x') - 100 and (getProperty(obj1..'.x') + getProperty(obj1..'.width')) <= (getProperty(obj2..'.x') + getProperty(obj2..'.width')) and getProperty(obj1..'.y') >= getProperty(obj2..'.y') and (getProperty(obj1..'.y') + getProperty(obj1..'.height')) <= (getProperty(obj2..'.y') + getProperty(obj2..'.height')) then
      return true
    end
end
