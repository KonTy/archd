//Modify this file to change what commands output to your statusbar, and recompile using the make command.
// examples taken from https://github.com/msjche/Suckless-msjche/blob/master/dwmblocks/blocks.h abd scripts from https://github.com/msjche/.local-bin-scripts/tree/master/statusbar

static const Block blocks[] = {
    /*Icon*/    /*Command*/                                       /*Update Interval*/   /*Update Signal*/
    // {" 📦 ",    "pacupdate", 36000,                1},
    // {"",        "volume --geticon",     1,          10},  // Left click (volume)
    // {"",        "volume --getmicicon",  1,          11},  // Right click (mic)
    // {"",        "weather",               300,        2},
    // {"🧠 ",     "memory",                6,          1},
    // {" 🌐 ",    "bandwidth wlo1",        2,          1},
    // {"",        "internet",              5,          0},
    {"🗓 ",     "clock",                 10,         0},
};

// TODO these don't have exe files installed on the machine like acpi, and others used in the scritp
    // {"",        "vpn",                   10,         0},
    // {" 🔆 ",    "brightness",            6,          1},
    // {"",        "battery",               5,          2},


// {"🐝", "bumblebee",         5,                    2}, // hybrid video TODO
// {" ", "volume2",             2,                    10},
//{"", "date '+%b %d (%a) %I:%M%p'",					5,		0},

//sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char delim[] = " | ";
static unsigned int delimLen = 5;