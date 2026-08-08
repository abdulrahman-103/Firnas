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


var box = newBody(bodyType = dynamicBody, bodyShape = rectangle, position = firnas.Vector2(x: 6, y:7))
box.gravityScale = 0
var box2 = newBody(bodyType = characterBody, bodyShape = rectangle, position = firnas.Vector2(x: 6, y:3))

proc main =
  initWindow(screenWidth, screenHeight, "firnas")
  setTargetFPS(60)
  testLoadImage()
  testDrawTextWithFont()

  while not windowShouldClose():
    updatePhysics()
    beginDrawing()
    clearBackground(RayWhite)
    drawText("Congrats! You created your first window!", 190, 200, 20, LightGray)

    drawBody(box2, Black)
    drawBody(box, Red)
    #if isKeyDown(KeyboardKey.D):
    #  box.applyForce(firnas.Vector2.right * 10)

    moveBody(box, 10)

    endDrawing()

  closeWindow()

main()