
local type = 'level'
function onCreate()
    makeAnimatedLuaSprite('pep_tv','tv',900,-70)
    addAnimationByPrefix('pep_tv','what','tv what1',24,true)
    addAnimationByIndicesLoop('pep_tv', 'wha', 'tv what2', '6,7,8,9,10,11,12,13,14,15,16,17', 24)
    addAnimationByIndicesLoop('pep_tv', 'whar', 'tv what3', '6,7,8,9,10,11,12,13,14,15,16,17', 24)
    scaleObject('pep_tv',1.5,1.5)
    setProperty('pep_tv.antialiasing',false)
    addLuaSprite('pep_tv')
    setObjectCamera('pep_tv','camOther')
    playAnim('pep_tv','what',true)

    setProperty('pep_tv.visible',false)



    for i = 1,6 do
        makeAnimatedLuaSprite('heart'..i,'pep heart',30 + (60 * (i % 3)),30 + (60 * (i % 2)))
        addAnimationByPrefix('heart'..i,'heart','pep heart heart',24,true)
        scaleObject('heart'..i,1.2,1.2)
        addLuaSprite('heart'..i)
        setProperty('heart'..i..'.antialiasing',false)
        setObjectCamera('heart'..i,'camOther')
    end
end

local items = {'timeBar','timeBarBG','timeTxt','scoreTxt','healthBar','healthBarBG','iconP1','iconP2'}
function onCreatePost()
    for i = 0,3 do
        setPropertyFromGroup('playerStrums',i,'x',870 + (80 * (i % 4)))
        setPropertyFromGroup('opponentStrums',i,'x',870 + (80 * (i % 4)))
        setPropertyFromGroup('opponentStrums',i,'y',20)
        setPropertyFromGroup('playerStrums',i,'y',100)

    end
    for i = 0,7 do
        setPropertyFromGroup('strumLineNotes',i,'scale.x',0.5)
        setPropertyFromGroup('strumLineNotes',i,'scale.y',0.5)
    end
    for i = 0,#items do
        setProperty(items[i+1]..'.visible',false)
    end
end