--exam 2 app 2 and 3
local widget = require "widget"
local physics = require "physics"
physics.start()

switchGroup=display.newGroup()
mainGroup = display.newGroup()


backGround=display.newImageRect("Sky.jpg", 1.2*display.contentWidth, 1.2*display.contentHeight)
backGround.x=display.contentCenterX
backGround.y=display.contentCenterY
mainGroup:insert(backGround)

--sound effect
bounceSound=audio.loadSound("bounceSound.mp3")
winningSound=audio.loadSound("winningSound.wav")
bgm=audio.loadSound("bgm.mp3")

audio.play(bgm,{channel=1,loops=-1, fadein=1000 } )

gameTitle_options = {
  text = "A Game of Frogs",
  x = display.contentCenterX,
  y = 29,
  width = 220,
  height = 40,
  font = "harry.TTF",
  fontSize = 28,
  align = "center",
}
gameTitle = display.newText( gameTitle_options )
gameTitle.id = "gameTitle"
gameTitle:setTextColor(1.0, 0.2, 0.2, 1.0)
mainGroup:insert(gameTitle)

tFrogs=0
totalFrogs_options = {
  text = "",
  x = display.contentWidth*0.55,
  y = display.contentHeight*0.3,
  width = 220,
  height = 40,
  font = "harry.TTF",
  fontSize = 28,
  align = "center",
}
totalFrogs = display.newText( totalFrogs_options )
totalFrogs.id = "totalFrogs"
totalFrogs:setTextColor(1.0, 0.2, 0.2, 1.0)
mainGroup:insert(totalFrogs)

lFrogs=0
luckyFrogs_options = {
  text = "",
  x = display.contentWidth*0.7,
  y = display.contentHeight*0.3,
  width = 220,
  height = 40,
  font = "harry.TTF",
  fontSize = 28,
  align = "center",
}
luckyFrogs = display.newText( luckyFrogs_options )
luckyFrogs.id = "luckyFrogs"
luckyFrogs:setTextColor(1.0, 0.2, 0.2, 1.0)
mainGroup:insert(luckyFrogs)

pct_options = {
  text = "",
  x = display.contentWidth*0.9,
  y = display.contentHeight*0.3,
  width = 220,
  height = 40,
  font = "harry.TTF",
  fontSize = 28,
  align = "center",
}
pct = display.newText( pct_options )
pct.id = "pct"
pct:setTextColor(1.0, 0.2, 0.2, 1.0)
mainGroup:insert(pct)

function deleteFrog(e)
  display.remove(e)
  e=nil
end

function groundCollision(e)
  audio.play(bounceSound,{channel=3})
  timer.performWithDelay(4000,function() deleteFrog(e.other) end)
  
end

ground=display.newImageRect("minecraft-ground.png", 0.5*display.contentWidth, display.contentHeight*0.1)
ground.x=0.75*display.contentWidth
ground.y=display.contentHeight*0.4
physics.addBody(ground, "static", { friction = 0.5, bounce = .01})
ground.name = "ground"
ground:addEventListener("collision", groundCollision)
mainGroup:insert(ground)

function lineGroundCollision(e)
  audio.play(bounceSound,{channel=3})
  timer.performWithDelay(4000,function() deleteFrog(e.other) end)
  
end

lineGround = display.newLine(0, display.contentHeight*1.08, display.contentWidth, display.contentHeight*1.08)
lineGround.id = "lineGround"
lineGround:setStrokeColor(1.0, 1.0, 0.0, 1.0)
lineGround.strokeWidth = 8
physics.addBody(lineGround, "static", { friction = 0.5})
lineGround.name = "lineGround"
lineGround:addEventListener("collision", lineGroundCollision)
mainGroup:insert(lineGround)

function cubeCollision(e)
  audio.play(bounceSound,{channel=3})
end

spinningCube=display.newImageRect("cube.png", display.contentHeight*0.16, display.contentHeight*0.16)
spinningCube.x=0.2*display.contentWidth
spinningCube.y=0.9*display.contentHeight
physics.addBody(spinningCube, "static", { friction = 0.5})
spinningCube:addEventListener("collision", cubeCollision)
mainGroup:insert(spinningCube)


function boxCollision(e)
  audio.play(winningSound,{channel=2})
  lFrogs=lFrogs+1
  luckyFrogs.text=lFrogs
  pct.text=string.format("%.0f",lFrogs/tFrogs*100).."%"
  deleteFrog(e.other)
end

box=display.newImageRect("box.png", display.contentHeight*0.16, display.contentHeight*0.16)
box.x=0.8*display.contentWidth
box.y=0.6*display.contentHeight
box:addEventListener("collision", boxCollision)
physics.addBody(box, "static", {bounce = .8 })
mainGroup:insert(box)

line1 = display.newLine(0.2*display.contentWidth, 0.9*display.contentHeight, 0.2*display.contentWidth, 1.08*display.contentHeight-4)
line1.id = "line1"
line1:setStrokeColor(0.0, 0.0, 0.0, 1.0)
line1.strokeWidth = 8
mainGroup:insert(line1)

line2 = display.newLine(0.1*display.contentWidth, 1.08*display.contentHeight-8, 0.3*display.contentWidth, 1.08*display.contentHeight-8)
line2.id = "line2"
line2:setStrokeColor(0.0, 0.0, 0.0, 1.0)
line2.strokeWidth = 8
mainGroup:insert(line2)

--bgmSwitch
function bgmSwitchHandler( event )
  s = event.target
  if s.isOn then
    audio.setVolume(1,{ channel=1 } )
  else
    audio.setVolume(0,{ channel=1 } )
  end
end


bgmSwitch = widget.newSwitch({
  style = "checkbox",
  id = "bgmSwitch",
  x = 0.1*display.contentWidth,
  y = display.contentHeight*0.8,
  initialSwitchState = true,
  onRelease = bgmSwitchHandler,
})
switchGroup:insert(bgmSwitch)

--winningSwitch
function winningSwitchHandler( event )
  s = event.target
  if s.isOn then
    audio.setVolume(1,{ channel=2 } )
  else
    audio.setVolume(0,{ channel=2 } )
  end
end


winningSwitch = widget.newSwitch({
  style = "checkbox",
  id = "winningSwitch",
  x = 0.1*display.contentWidth,
  y = display.contentHeight*0.9,
  initialSwitchState = true,
  onRelease = winningSwitchHandler,
})
switchGroup:insert(winningSwitch)

--bounceSwitch
function bounceSwitchHandler( event )
  s = event.target
  if s.isOn then
    audio.setVolume(1,{ channel=3 } )
  else
    audio.setVolume(0,{ channel=3 } )
  end
end


bounceSwitch = widget.newSwitch({
  style = "checkbox",
  id = "bounceSwitch",
  x = 0.1*display.contentWidth,
  y = display.contentHeight,
  initialSwitchState = true,
  onRelease = bounceSwitchHandler,
})
switchGroup:insert(bounceSwitch)

--caption
Obj20_options = {
  text = "Play Background Music",
  x = display.contentCenterX+15,
  y = display.contentHeight*0.82,
  width = 300,
  height = 40,
  font = "Dialog",
  fontSize = 20,
  align = "center",
}
Obj20 = display.newText( Obj20_options )
Obj20.id = "Obj20"
switchGroup:insert(Obj20)

Obj21_options = {
  text = "Play Winning Sound",
  x = display.contentCenterX,
  y = display.contentHeight*0.92,
  width = 220,
  height = 40,
  font = "Dialog",
  fontSize = 20,
  align = "center",
}
Obj21 = display.newText( Obj21_options )
Obj21.id = "Obj21"
switchGroup:insert(Obj21)

Obj22_options = {
  text = "Play Bounce Sound",
  x = display.contentCenterX,
  y = display.contentHeight*1.02,
  width = 220,
  height = 40,
  font = "Dialog",
  fontSize = 20,
  align = "center",
}
Obj22 = display.newText( Obj22_options )
Obj22.id = "Obj22"
switchGroup:insert(Obj22)

switchGroup.alpha=0

symbolIsUp=false
originalY=mainGroup.y
function symbolTapHandler(event)
  if event.phase=="began" then
    if not symbolIsUp then
    
      transition.to(mainGroup,{time=300,y=mainGroup.y-0.4*display.contentHeight})
      symbolIsUp=true
      switchGroup.alpha=1
    else
      transition.to(mainGroup,{time=300,y=originalY})
      symbolIsUp=false
      switchGroup.alpha=0
    end
    
  end
  
  
end


symbol=display.newImageRect("i_symbol.png", display.contentHeight*0.1, display.contentHeight*0.1)
symbol.x=0.9*display.contentWidth
symbol.y=1*display.contentHeight
symbol:addEventListener( "touch", symbolTapHandler )

function onEnterFrame(event)
  spinningCube.rotation=spinningCube.rotation+2
end
Runtime:addEventListener("enterFrame",onEnterFrame)




frogID=0
function dropFrog(e)
  if e.phase == "began" and e.y<0.3*display.contentHeight then
        tFrogs=tFrogs+1
        totalFrogs.text=tFrogs
        pct.text=string.format("%.0f",lFrogs/tFrogs*100).."%"
        frog = display.newImageRect("choc-frog.png", display.contentHeight*0.1, display.contentHeight*0.1)
        frog.x = e.x
        frog.y = e.y
        frog.name = "frog"
        frog.id="frog"..frogID
        frogID=frogID+1
        print(frog.id)
        physics.addBody(frog, {density = .1, bounce = .6, friction = 0.5, radius = display.contentHeight*0.06})
        
  end
  
end
Runtime:addEventListener("touch", dropFrog)




