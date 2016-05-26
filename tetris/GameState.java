public enum GameState {
 PAUSED,
 PLAYING,
 OVER;
 
  public String buttonText() {
    if (this == PAUSED) {
      return "Resume";
    }
    
    return "Pause";
  }
  
  public String overlayText() {
   if (this == OVER) {
     return "You Lost!";
   } else if (this == PAUSED) {
     return "Game is Paused";
   }
   
   return "";
  }
}