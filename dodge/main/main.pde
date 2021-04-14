// Initialize game variables
float currentGameTime;
float lastGameTime;
float elapsedGameTime;

GameBoard gb;

void setup()
{
  // Set up window and engine
  size(600, 600);
  frameRate(30);
  rectMode(CENTER);

  // Setup pieces
  gb = new GameBoard(50);
}

void draw()
{
  lastGameTime = currentGameTime;
  currentGameTime = millis();
  elapsedGameTime = (currentGameTime - lastGameTime)/1000;

  gb.Update(elapsedGameTime);

}

public class Vector2
{
  public float X;
  public float Y;
  public Vector2(float x, float y)
  {
    X = x;
    Y = y;
  }
}

public void ArcBlock(float x, float y, float innerRadius, float start, float end, float thickness)
{
  int numPts = 100;
  float arcLength = start - end;
  float increment = arcLength / numPts;
  noStroke();
  fill(255);
  beginShape(TRIANGLE_STRIP);
  for (int i = 1; i < numPts; i++)
  {
    Vector2 newPt;

    if (i % 2 == 0) // Point goes on outer strip
    {
      newPt = new Vector2(x + (innerRadius+thickness)*sin(start-increment*i), y + (innerRadius+thickness)*cos(start-increment*i));
    } else
    {
      newPt = new Vector2(x + innerRadius*sin(start-increment*i), y + innerRadius*cos(start-increment*i));
    }
    vertex(newPt.X, newPt.Y);
  }
  endShape();
}