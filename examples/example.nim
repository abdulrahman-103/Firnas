import raylib, rlgl, raymath, rmem, reasings, rcamera
import firnas
import firnas/plugin

const
  screenWidth = 800
  screenHeight = 450

proc testLoadImage() =
  try:
    let image = loadImage("test_image.png")
  except RaylibError:
    echo "Error loading image"

proc testDrawTextWithFont() =
  let font = getFontDefault()
  let position = raylib.Vector2(x: 200, y: 200)
  drawText(font, "Hello with custom font", position, 24, 2, DarkGray)


var box = newBody(bodyType = characterBody, bodyShape = rectangle, position = firnas.Vector2(x: 10, y:7 ), size = firnas.Vector2(x: 5, y:5))
box.gravityScale = 0
var box2 = newBody(bodyType = dynamicBody, bodyShape = rectangle, position = firnas.Vector2(x: 6, y: 2), mass = 5)
var floor = newBody(bodyType = staticBody, bodyShape = rectangle, position = firnas.Vector2(x: 50, y: 12), size = firnas.Vector2(x: 100, y: 2))

proc main =
  initWindow(screenWidth, screenHeight, "firnas")
  setTargetFPS(144)
  setPhysicsHz(60)
  testLoadImage()
  testDrawTextWithFont()
  var keys: seq[bool] = @[]
  while not windowShouldClose():
    updatePhysics()
    
    beginDrawing()
    clearBackground(RayWhite)
    drawText("Congrats! You created your first window!", 190, 200, 20, LightGray)

    drawBody(box2, Black)
    drawBody(box, Red)
    drawBody(floor, Blue)

    var keys: seq[bool] = @[isKeyDown(KeyboardKey.A), isKeyDown(KeyboardKey.D), isKeyDown(KeyboardKey.W), isKeyDown(KeyboardKey.S)]
    moveBody(box, 10, keys)

    endDrawing()

  closeWindow()

main()