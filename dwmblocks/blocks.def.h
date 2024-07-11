//Modify this file to change what commands output to your statusbar, and recompile using the make command.
// examples taken from https://github.com/msjche/Suckless-msjche/blob/master/dwmblocks/blocks.h abd scripts from https://github.com/msjche/.local-bin-scripts/tree/master/statusbar

#include <stdlib.h>
#include <stdio.h>

// Macro to define a command string with the home directory path
#define HOME_CMD(cmd) ({ \
    char *home = getenv("HOME"); \
    char *full_cmd; \
    if (home) { \
        asprintf(&full_cmd, "%s/%s", home, cmd); \
    } else { \
        asprintf(&full_cmd, "%s", cmd); \
    } \
    full_cmd; \
})

static const Block blocks[] = {
    /*Icon*/    /*Command*/                                       /*Update Interval*/   /*Update Signal*/
    {" 📦 ",    "pacupdate.sh", 36000,                1},
    {"",        "volume.sh --geticon",     1,          10},  // Left click (volume)
    {"",        "volume.sh --getmicicon",  1,          11},  // Right click (mic)
    {"",        "weather.sh",               300,        2},
    {"🧠 ",     "memory.sh",                6,          1},
    {" 🌐 ",    "bandwidth.sh wlo1",        2,          1},
    {" 🔆 ",    "brightness.sh",            6,          1},
    {"",        "battery.sh",               5,          2},
    {"",        "internet.sh",              5,          0},
    {"",        "vpn.sh",                   10,         0},
    {"🗓 ",     "clock.sh",                 10,         0},
};

// {"🐝", "bumblebee",         5,                    2}, // hybrid video TODO
// {" ", "volume2",             2,                    10},
//{"", "date '+%b %d (%a) %I:%M%p'",					5,		0},

//sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char delim[] = "  ";
static unsigned int delimLen = 2;
