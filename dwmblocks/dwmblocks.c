#include<stdlib.h>
#include<stdio.h>
#include<string.h>
#include<unistd.h>
#include<signal.h>
#include<X11/Xlib.h>
#include<time.h> 
#include<stdarg.h>
#define LENGTH(X)               (sizeof(X) / sizeof (X[0]))
#define CMDLENGTH		50

// Declare the global log file handle
FILE *log_file = NULL;
void cleanup(void);
void log_info(const char *format, ...);


typedef struct {
	char* icon;
	char* command;
	unsigned int interval;
	unsigned int signal;
} Block;
void sighandler(int num);
void buttonhandler(int sig, siginfo_t *si, void *ucontext);
void replace(char *str, char old, char new);
void remove_all(char *str, char to_remove);
void getcmds(int time);
#ifndef __OpenBSD__
void getsigcmds(int signal);
void setupsignals();
void sighandler(int signum);
#endif
int getstatus(char *str, char *last);
void setroot();
void statusloop();
void termhandler(int signum);


#include "config.h"

static Display *dpy;
static int screen;
static Window root;
static char statusbar[LENGTH(blocks)][CMDLENGTH] = {0};
static char statusstr[2][256];
static int statusContinue = 1;
static void (*writestatus) () = setroot;

void cleanup(void)
{
    if (log_file) {
        fclose(log_file);
    }
}


void log_info(const char *format, ...)
{
    if (!log_file) {
        return;
    }

    time_t now = time(NULL);
    struct tm *t = localtime(&now);
    char timestamp[20];
    strftime(timestamp, sizeof(timestamp), "%Y-%m-%d %H:%M:%S", t);

    va_list args;
    va_start(args, format);

    fprintf(log_file, "%s ", timestamp);
    vfprintf(log_file, format, args);
    fprintf(log_file, "\n");
    fflush(log_file);

    va_end(args);
}











void replace(char *str, char old, char new)
{
//	log_info("replace:: called \n");

	int N = strlen(str);
	for(int i = 0; i < N; i++)
		if(str[i] == old)
			str[i] = new;
}

void remove_all(char *str, char to_remove) {
//	log_info("remove_all:: called \n");

	char *read = str;
	char *write = str;
	while (*read) {
		if (*read == to_remove) {
			read++;
			*write = *read;
		}
		read++;
		write++;
	}
}

//opens process *cmd and stores output in *output
void getcmd(const Block *block, char *output)
{
//	log_info("getcmd:: called \n");

	if (block->signal)
	{
		output[0] = block->signal;
		output++;
	}
	strcpy(output, block->icon);
	char *cmd = block->command;
	FILE *cmdf = popen(cmd,"r");
	if (!cmdf)
		return;
	char c;
	int i = strlen(block->icon);
	fgets(output+i, CMDLENGTH-(strlen(delim)+1), cmdf);
	remove_all(output, '\n');
	i = strlen(output);
    if ((i > 0 && block != &blocks[LENGTH(blocks) - 1]))
        strcat(output, delim);
    i+=strlen(delim);
	output[i++] = '\0';
	pclose(cmdf);
}

void getcmds(int time)
{
//	log_info("getcmds:: called $d\n", time);

	const Block* current;
	for(int i = 0; i < LENGTH(blocks); i++)
	{
		current = blocks + i;
		if ((current->interval != 0 && time % current->interval == 0) || time == -1)
			getcmd(current,statusbar[i]);
	}
}

#ifndef __OpenBSD__
void getsigcmds(int signal)
{
//	log_info("getsigcmds:: called $d\n", signal);


	const Block *current;
	for (int i = 0; i < LENGTH(blocks); i++)
	{
		current = blocks + i;
		if (current->signal == signal)
			getcmd(current,statusbar[i]);
	}
}

// void setupsignals()
// {
// 	log_info("setupsignals:: called\n");

// 	struct sigaction sa;

// 	for(int i = SIGRTMIN; i <= SIGRTMAX; i++)
// 		signal(i, SIG_IGN);

// 	// setup all the signals from blocks[]
// 	for(int i = 0; i < LENGTH(blocks); i++)
// 	{
// 		if (blocks[i].signal > 0)
// 		{
// 			signal(SIGRTMIN+blocks[i].signal, sighandler);
// 			sigaddset(&sa.sa_mask, SIGRTMIN+blocks[i].signal);
// 		}
// 	}
// 	sa.sa_sigaction = buttonhandler;
// 	sa.sa_flags = SA_SIGINFO;
// 	sigaction(SIGUSR1, &sa, NULL);
// 	struct sigaction sigchld_action = {
//   		.sa_handler = SIG_DFL,
//   		.sa_flags = SA_NOCLDWAIT
// 	};
// 	sigaction(SIGCHLD, &sigchld_action, NULL);

// }


void setupsignals() {
    log_info("setupsignals:: called\n");

    struct sigaction sa;
    sigemptyset(&sa.sa_mask); // Initialize the signal mask

    // Set all signals to ignore initially
    for (int i = SIGRTMIN; i <= SIGRTMAX; i++) {
        signal(i, SIG_IGN);
    }

    // Setup all the signals from blocks[]
    for (int i = 0; i < LENGTH(blocks); i++) {
        if (blocks[i].signal > 0) {

            sa.sa_sigaction = buttonhandler; // Assign the handler
            sa.sa_flags = SA_SIGINFO; // Use SA_SIGINFO for siginfo_t

            // Set the signal handler for the specific signal
            sigaction(SIGRTMIN + blocks[i].signal, &sa, NULL);
			log_info("\t\tsetupsignals:: button handeler for: %d\n", SIGRTMIN + blocks[i].signal);
        }
    }

    // Set up default action for SIGCHLD
    struct sigaction sigchld_action = {
        .sa_handler = SIG_DFL,
        .sa_flags = SA_NOCLDWAIT
    };
    sigaction(SIGCHLD, &sigchld_action, NULL);
}


#endif

int getstatus(char *str, char *last)
{
	//log_info("getstatus:: called\n");

	strcpy(last, str);
	str[0] = '\0';
    for(int i = 0; i < LENGTH(blocks); i++) {
		strcat(str, statusbar[i]);
        if (i == LENGTH(blocks) - 1)
            strcat(str, " ");
    }
	str[strlen(str)-1] = '\0';
	return strcmp(str, last);//0 if they are the same
}

void setroot()
{
	// log_info("setroot:: called\n");

	if (!getstatus(statusstr[0], statusstr[1]))//Only set root if text has changed.
		return;
	Display *d = XOpenDisplay(NULL);
	if (d) {
		dpy = d;
	}
	screen = DefaultScreen(dpy);
	root = RootWindow(dpy, screen);
	XStoreName(dpy, root, statusstr[0]);
	XCloseDisplay(dpy);
}

void pstdout()
{
	
log_info("pstdout:: called\n");

	if (!getstatus(statusstr[0], statusstr[1]))//Only write out if text has changed.
		return;
	printf("%s\n",statusstr[0]);
	fflush(stdout);
}


void statusloop()
{
	log_info("statusloop:: called\n");
#ifndef __OpenBSD__
	setupsignals();
#endif
	int i = 0;
	getcmds(-1);
	while(statusContinue)
	{
		getcmds(i);
		writestatus();
		sleep(1.0);
		i++;
	}
}

#ifndef __OpenBSD__
void sighandler(int signum)
{
	log_info("sighandler:: called\n");
	getsigcmds(signum - SIGRTMIN);
	writestatus();
}

void buttonhandler(int sig, siginfo_t *si, void *ucontext)
{

    // Log the incoming parameters
    log_info("Buttonhandler called");
    log_info("sig: %d", sig);
    log_info("si->si_value.sival_int: %d", si->si_value.sival_int);
    
    // Extract the button number
    char button[2];
    button[0] = '0' + (si->si_value.sival_int & 0xff);
    button[1] = '\0';

    pid_t process_id = getpid();
    sig = si->si_value.sival_int >> 8;

    if (fork() == 0)
    {
		log_info("\tButtonhandler:: fork");
        const Block *current = NULL;
        for (int i = 0; i < LENGTH(blocks); i++)
        {
			log_info("\t\tButtonhandler:: for %d == sig", blocks[i].signal, sig);
            if (blocks[i].signal == sig)
            {
                current = &blocks[i];
                break;
            }
        }
		log_info("\t\tButtonhandler:: after for");
        if (current)
        {
			log_info("\t\t\tButtonhandler:: current");
            char shcmd[1024];
            snprintf(shcmd, sizeof(shcmd), "%s && kill -%d %d", current->command, current->signal + 34, process_id);

            char *command[] = { "/bin/sh", "-c", shcmd, NULL };
            setenv("BLOCK_BUTTON", button, 1);

            // Log the button number and command
            log_info("Button: %s", button);
            log_info("Command: %s", shcmd);

            setsid();
            execvp(command[0], command);
            perror("execvp");  // In case execvp fails
        }
        else
        {
            // Debug: print if no matching block is found
            printf("No matching block found for signal: %d\n", sig);
        }
        exit(EXIT_SUCCESS);
    }
    else
    {
        // Debug: print if fork fails
        perror("fork");
    }
}


// void buttonhandler(int sig, siginfo_t *si, void *ucontext)
// {
//     char button[2];
//     button[0] = '0' + (si->si_value.sival_int & 0xff);
//     button[1] = '\0';

//     pid_t process_id = getpid();
//     sig = si->si_value.sival_int >> 8;

//     if (fork() == 0)
//     {
//         const Block *current = NULL;
//         for (int i = 0; i < LENGTH(blocks); i++)
//         {
//             if (blocks[i].signal == sig)
//             {
//                 current = &blocks[i];
//                 break;
//             }
//         }

//         if (current)
//         {
//             char shcmd[1024];
//             snprintf(shcmd, sizeof(shcmd), "%s && kill -%d %d", current->command, current->signal + 34, process_id);

//             char *command[] = { "/bin/sh", "-c", shcmd, NULL };
//             setenv("BLOCK_BUTTON", button, 1);

//             // Launch st to print the button number and debug info
//             char *st_cmd[] = { "st", "-e", "sh", "-c", "echo BLOCK_BUTTON=$BLOCK_BUTTON; echo shcmd=$shcmd; exec sh", NULL };
//             execvp(st_cmd[0], st_cmd);
//             perror("execvp st");

//             setsid();
//             execvp(command[0], command);
//             perror("execvp");  // In case execvp fails
//         }
//         else
//         {
//             // Debug: print if no matching block is found
//             printf("No matching block found for signal: %d\n", sig);
//         }
//         exit(EXIT_SUCCESS);
//     }
//     else
//     {
//         // Debug: print if fork fails
//         perror("fork");
//     }
// }


#endif

void termhandler(int signum)
{
	statusContinue = 0;
	exit(0);
}

int main(int argc, char** argv)
{

  const char *homedir = getenv("HOME");
    if (homedir == NULL) {
        fprintf(stderr, "Error: Could not determine the home directory.\n");
        return EXIT_FAILURE;
    }

    char log_path[1024];
    snprintf(log_path, sizeof(log_path), "%s/dwmblocks.log", homedir);

    log_file = fopen(log_path, "a");
    if (log_file == NULL) {
        perror("fopen log file");
        return EXIT_FAILURE;
    }

	if (log_file) {
        fprintf(log_file, "DWMBlocks started\n");
        fflush(log_file);
    }

    // Register cleanup function to close the log file on exit
    atexit(cleanup);
	
	for(int i = 0; i < argc; i++)
	{
		if (!strcmp("-d",argv[i]))
			delim = argv[++i];
		else if(!strcmp("-p",argv[i]))
			writestatus = pstdout;
	}
	signal(SIGTERM, termhandler);
	signal(SIGINT, termhandler);
	statusloop();
}
