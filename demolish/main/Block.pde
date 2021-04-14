public class Block
{
 
  private float position;  // Position in degrees about the origin
  public float GetPosition() { 
    return position;
  }

  private float arcLength;
  public float GetArcLength() { 
    return arcLength;
  }
  private float radius;
  private float thickness;
  private color _shade;
  private boolean broken;
  public boolean isBroken() { return broken; }
  public void smash() { broken = true; }
  
  public Block(float startPos, float startLength, float startRadius, float startThickness, color shade)
  {
    position = startPos;
    arcLength = startLength;
    radius = startRadius;
    thickness = startThickness;
    _shade = shade;
    broken = false;
  }
  
  public void Update()
  {
    drawSelf();
  }
  
  private void drawSelf()
  {
    ArcBlock(width/2, height/2, radius, radians(position), radians(position+arcLength), thickness, _shade);
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