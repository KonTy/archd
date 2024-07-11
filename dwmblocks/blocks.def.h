//Modify this file to change what commands output to your statusbar, and recompile using the make command.
// examples taken from https://github.com/msjche/Suckless-msjche/blob/master/dwmblocks/blocks.h abd scripts from https://github.com/msjche/.local-bin-scripts/tree/master/statusbar
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
    {" 📦 ", "pacupdate.sh",                                                36000,1},
    {"",      "~/.config/configs/scripts/volume.sh --geticon",      		 1,	  10},  // Left click (volume)
    {"",      "~/.config/configs/scripts/volume.sh --getmicicon",   		 1,   11},  // Right click (mic)
    {"",      "~/.config/configs/script/weather.sh",                         300, 2},
    {"🧠 ",   "~/.config/configs/script/memory.sh",                          6,   1},
    {" 🌐 ",  "~/.config/configs/script/bandwidth.sh wlo1",                  2,   1},
    {" 🔆 ",  "~/.config/configs/script/brightness.sh",                      6,   1},
    {"",       "~/.config/configs/script/battery.sh",                         5,   2},
    {"",       "~/.config/configs/script/internet.sh",                        5,   0},
    {"",       "~/.config/configs/script/vpn.sh",                             10,  0},
     {"🗓 ", "~/.config/configs/script/clock.sh",              10,                   0},

    // {"🐝", "bumblebee",         5,                    2}, // hybrid video TODO
    // {" ", "volume2",             2,                    10},
	//{"", "date '+%b %d (%a) %I:%M%p'",					5,		0},
};

//sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char delim[] = "  ";
static unsigned int delimLen = 2;
