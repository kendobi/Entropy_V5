 var track1 : AudioClip;
 
 GetComponent.<AudioSource>().clip = track1;
 
 var audio1Volume : float = 1.0;
 
 
 function fadeIn() {
     if (audio1Volume < 1) {
         audio1Volume += 0.5 * Time.deltaTime;
         GetComponent.<AudioSource>().volume = audio1Volume;
     }
 }
 
 function fadeOut() {
     while (audio1Volume > 0.1) {
         audio1Volume -= 0.5 * Time.deltaTime;
         GetComponent.<AudioSource>().volume = audio1Volume;
         yield;
     }
 }