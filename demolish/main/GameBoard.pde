import ddf.minim.*;

public class GameBoard
{
  // Player variables
  Paddle player;
  int totalLives = 10;
  float scoreRate = 1;
  float totalScore = 0;
  boolean alive = true;  

  Ball ball;
  int ballCount = 0;
  int maxDistance = 280;
  
  Block[] blocks;
  int blockCount = 0;  

  color bgColor = color(0, 0, 0, 80);
  color hitColor = color(100, 0, 0, 80);
  float hitTimer = 1;
  float hitTime = .2;

  boolean wasCollision = false;
  
  // Sound Stuff
  Minim minim;
  AudioOutput mainOut;
  NoiseInstrument hitNoise;

  public GameBoard()
  {
    player = new Paddle(347, 30, maxDistance, 20, 120);
    ball = new Ball(new Vector2(width/2,(height/2)+180), 20, new Vector2(100,PI/4), color(255));
    spawnBlocks();
    
    minim = new Minim(this);
    mainOut = minim.getLineOut(Minim.MONO, 512);
    hitNoise = new NoiseInstrument(0.5, Noise.Tint.RED, mainOut);
  }
  
  private void spawnBlocks()
  {
    int radius = 150;
    int radialDiv = 4;
    int circumDiv = 10;
    float pos = 0;
    float arcLength = 0;
    int thickness = radius / radialDiv;
    
    blocks = new Block[radialDiv*circumDiv];
    
    for (int i=1; i <= radialDiv; i++)
    {
      arcLength = (360 / circumDiv);
      for (int j=0; j < circumDiv; j++)
      {
        pos = (360 / circumDiv) * j;
        blocks[blockCount] = new Block(pos, arcLength, thickness*(i-1), thickness, color(random(255),random(255),random(255)));
        blockCount++;
      }
    }
    
    
  }

  public void Update(float time)
  {
    fill(bgColor); //redraw each frame
    noStroke();
    rect(width/2, height/2, width, height);
    bgColor = color(0, 0, 0, 255);
    hitTimer += time;
    
    if (wasCollision || hitTimer < hitTime)
    {
      if(wasCollision)
        hitTimer = 0;
      
      translate(random(-10, 10), random(-10, 10));
      bgColor = hitColor;
    }
    
    if (alive)
    {
      ball.Update(time);
      player.Update(time);
      for (int i = 0; i < blockCount; i++)
      {
        if (!blocks[i].isBroken())
          blocks[i].Update();
      }

      if (CheckPlayerContact())
      {
       wasCollision = true;
       mainOut.playNote(0, 0.15, hitNoise);
      }
      else if (CheckBlockContact())
      {
       wasCollision = true;
       mainOut.playNote(0, 0.15, hitNoise);
      }
      else
      {
        wasCollision = false;
      }
    } 
    else
    {
      fill(255);
      text("Game over.", width / 2, height / 2);
    }
  }

  private boolean CheckPlayerContact()
  {
    boolean didHit = false;
    Vector2[] points = player.GetEdgePoints();

    float ballX = ball.GetPosition().X;
    float ballY = ball.GetPosition().Y;
    float radius = ball.GetSize();
    float ballSpeed = ball.GetVelocity().X;
    float ballAngle = ball.GetVelocity().Y;

    for (int j = 1; j < points.length; j++)
    {
      float pointX = points[j].X;
      float pointY = points[j].Y;
      if (dist(ballX, ballY, pointX, pointY) < radius/2)
      {
        float dx = pointX - points[j-1].X;
        float dy = pointY - points[j-1].Y;
        println("Paddle: " + pointX + ", " + pointY);
        float newAngle = -(PI - ballAngle - atan(dy/dx));
        ball.SetVelocity(ballSpeed, newAngle);
        didHit = true;
      }
    }

    return didHit;
  }
  
  private boolean CheckBlockContact()
  {
    boolean didHit = false;
    float ballX = ball.GetPosition().X;
    float ballY = ball.GetPosition().Y;
    float radius = ball.GetSize();
    float ballSpeed = ball.GetVelocity().X;
    float ballAngle = ball.GetVelocity().Y;
    
    for (int i = 0; i < blockCount; i++)
    {
      if (!blocks[i].isBroken()) {
        Vector2[] points = blocks[i].GetEdgePoints();
        for (int j = 1; j < points.length; j++)
        {
          float pointX = points[j].X;
          float pointY = points[j].Y;
          if (dist(ballX, ballY, pointX, pointY) < radius/2)
          {
              float dx = pointX - points[j-1].X;
              float dy = pointY - points[j-1].Y;
              println("Block: " + pointX + ", " + pointY);
              float newAngle = -(PI - ballAngle - atan(dy/dx));
              ball.SetVelocity(ballSpeed, newAngle);
              didHit = true;
              blocks[i].smash();
          }
        }
      }
    }

    return didHit;
  }
}