import ddf.minim.*;

public class GameBoard
{
  // Player variables
  Paddle player;
  int totalLives = 10;
  float scoreRate = 1;
  float totalScore = 0;
  boolean alive = true;  

  Ball[] balls;
  int ballCount = 0;
  int maxDistance = 280;

  float spawnTimer;
  float spawnFrequency = 2;

  float minSpeed = 200;
  float maxSpeed = 500;

  float minSize = 20;
  float maxSize = 60;
  
  color bgColor = color(0, 0, 0, 80);
  color hitColor = color(100, 0, 0, 80);
  float hitTimer = 1;
  float hitTime = .2;

  boolean wasCollision = false;
  
  // Sound Stuff
  Minim minim;
  AudioOutput mainOut;
  NoiseInstrument hitNoise;
  
  boolean needBallVector = true;
  Vector2 newBallVector = new Vector2(0,0);
  
  public GameBoard(int maxBalls)
  {
    balls = new Ball[maxBalls];
    for (int i = 0; i < maxBalls; i++)
    {
      balls[i] = new Ball();
    }
    spawnTimer = 0;

    player = new Paddle(0, 30, maxDistance, 20, 120);
    
    minim = new Minim(this);
    mainOut = minim.getLineOut(Minim.MONO, 512);
    hitNoise = new NoiseInstrument(0.5, Noise.Tint.RED, mainOut);
  }

  public void Update(float time)
  {
    fill(bgColor); //redraw each frame
    noStroke();
    rect(width/2, height/2, width, height);
    bgColor = color(0, 0, 0, 80);
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
      UpdateBalls(time);
      player.Update(time);

      scoreRate = (player.GetArcLength()/10);
      totalScore += ceil((scoreRate * time) + player.distanceTraveled / 1000);
      spawnFrequency = (1000/totalScore);

      text(totalScore, 10, 20);
      text(totalLives, 10, 40);
      if (CheckContact())
      {
        totalLives--;
        wasCollision = true;
        mainOut.playNote(0, 0.15, hitNoise);
      }
      else
      {
        wasCollision = false;
      }

      if (totalLives <= 0)
      {
        alive = false;
      }
    } else
    {
      fill(255);
      text("Game over.", width / 2, height / 2);
    }
  }

  private void UpdateBalls(float time)
  {
    spawnTimer += time;
      
    if (needBallVector){
      newBallVector = new Vector2(random(minSpeed, maxSpeed), random(0, 2*PI));
       needBallVector = false; 
    }
      stroke(255);
      strokeWeight(4);
      line(width / 2, height / 2, (width / 2) + newBallVector.X * cos(newBallVector.Y), (height / 2) + newBallVector.X * sin(newBallVector.Y));
      noStroke();
      
    
    if (spawnTimer >= spawnFrequency)
    {
      if (ballCount >= balls.length)
        ballCount = 0;

      Vector2 newPos = new Vector2(width / 2, height / 2);
      Vector2 newVel = newBallVector;
      float newSize = random(minSize, maxSize);
      color newColor = color(random(50, 255), random(50, 255), random(50, 255));

      spawnTimer = 0;
      balls[ballCount] = new Ball(newPos, newSize, newVel, newColor);
      ballCount++;
      needBallVector = true;
    }

    for (int i = 0; i < balls.length; i++)
    {
      balls[i].Update(time);
    }
  }

  private boolean CheckContact()
  {
    boolean didHit = false;
    Vector2[] points = player.GetEdgePoints();

    for (int i = 0; i < balls.length; i++)
    {
      float ballX = balls[i].GetPosition().X;
      float ballY = balls[i].GetPosition().Y;
      float radius = balls[i].GetSize();

      for (int j = 1; j < points.length; j++)
      {
        float pointX = points[j].X;
        float pointY = points[j].Y;
        if (dist(ballX, ballY, pointX, pointY) < radius/2)
        {
          balls[i] = new Ball();
          didHit = true;
        }
      }
    }

    return didHit;
  }
}