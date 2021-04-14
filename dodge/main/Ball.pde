public class Ball
{
  private Vector2 position;
  public Vector2 GetPosition() { return position; }
  public void SetPosition(float x, float y) { position = new Vector2(x, y); }
  private Vector2 velocity;
  public Vector2 GetVelocity() { return new Vector2(velocity.X, velocity.Y); }
  public void SetVelocity(float speed, float direction) { velocity = new Vector2(speed, direction); }
  private float size;
  public float GetSize() { return size; }
  color myColor;
  
  public Ball()
  {
    position = new Vector2(-20, -20);
    velocity = new Vector2(0, 0);
    size = 0;
    myColor = color(0, 0, 0, 0);
  }
  
  public Ball(Vector2 pos, float s, Vector2 v, color c)
  {
    position = pos;
    velocity = v;
    size = s;
    myColor = c;
  }
  
  public void Update(float time)
  {
    position.X += velocity.X*cos(velocity.Y)*time;
    position.Y += velocity.X*sin(velocity.Y)*time;
    Draw();
  }
  
  private void Draw()
  {
    fill(myColor);
    ellipse(position.X, position.Y, size, size); 
  }
}