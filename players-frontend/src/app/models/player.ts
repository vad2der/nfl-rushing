export interface Player {
  "Player": string;
  "Team": string;
  "Pos": string;
  "Att": number;
  "Att/G": number;
  "Yds": string;
  "Avg": number;
  "Yds/G": number;
  "TD": number;
  "Lng": string;
  "1st": number;
  "1st%": number;
  "20+": number;
  "40+": number;
  "FUM": number;
}

export const PLAYER_KEYS = [
  "Player",
  "Team",
  "Pos",
  "Att",
  "Att/G",
  "Yds",
  "Avg",
  "Yds/G",
  "TD",
  "Lng",
  "1st",
  "1st%",
  "20+",
  "40+",
  "FUM"
]