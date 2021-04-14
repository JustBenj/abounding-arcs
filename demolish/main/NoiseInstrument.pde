import ddf.minim.*;
import ddf.minim.ugens.*;

AudioOutput out;

// just plays a burst of noise of the specified tint and amplitude
class NoiseInstrument implements Instrument
{
  // create all variables that must be used throughout the class
  Noise myNoise;
  
  // constructors for the intsrument
  NoiseInstrument( float amplitude, Noise.Tint noiseTint, AudioOutput ao )
  {
    // create new instances of any UGen objects as necessary
    // white noise is used for this instrument
    myNoise = new Noise( amplitude, noiseTint );
    out = ao;
  }
  
  // every instrument must have a noteOn( float ) method
  void noteOn( float dur )
  {
    myNoise.patch( out );
  }
  
  // every instrument must have a noteOff() method
  void noteOff()
  {
    // unpatch the output 
    // this causes the entire instrument to stop calculating sampleframes
    // which is good when the instrument is no longer generating sound.
    myNoise.unpatch( out );
  }
}