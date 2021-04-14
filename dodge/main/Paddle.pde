public class Paddle
{
  private float position;
  public float GetPosition() { 
    return position;
  }

  private float arcLength;
  public float GetArcLength() { 
    return arcLength;
  }
  private float radius;
  private float thickness;
  private float speed;
  public float distanceTraveled = 0;
  

  public Paddle(float startPos, float startLength, float startRadius, float startThickness, float startSpeed)
  {
    position = startPos;
    arcLength = startLength;
    radius = startRadius;
    thickness = startThickness;
    speed = startSpeed;
  }

  public void Update(float elapsedTime)
  {
    handleInput(elapsedTime);
    drawSelf();
  }

  private void handleInput(float time)
  {
    if (keyPressed)
    {
      if (keyCode == LEFT)
      {
        position -= speed*time;
        distanceTraveled += speed*time;
      } else if (keyCode == RIGHT)
      {
        position += speed*time;
        distanceTraveled += speed*time;
      } else if (keyCode == UP)
      {
        arcLength += 2*(speed)*time;
        position -= (speed)*time;
      } else if (keyCode == DOWN)
      {
        arcLength -= 2*(speed)*time;
        position += (speed)*time;
      }
    }
  }

  private void drawSelf()
  {
    ArcBlock(width/2, height/2, radius, radians(position), radians(position+arcLength), thickness);
  }


  public Vector2[] GetEdgePoints()
  {
    int numPts = 100;
    float start = radians(position);
    Vector2[] points = new Vector2[numPts];
    float aLength = start - radians(position+arcLength);
    float increment = aLength / numPts;

    for (int i = 1; i < numPts; i++)
    {
      Vector2 newPt;

      if (i % 2 == 0) // Point goes on outer strip
      {
        newPt = new Vector2((width/2) + (radius+thickness)*sin(start-increment*i), (height/2) + (radius+thickness)*cos(start-increment*i));
      } else
      {
        newPt = new Vector2((width/2) + (radius)*sin(start-increment*i), (height/2) + (radius)*cos(start-increment*i));
      }

      points[i] = newPt;
    }
    
    return points;
  }
}