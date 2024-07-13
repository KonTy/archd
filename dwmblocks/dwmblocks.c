#include<stdlib.h>
#include<stdio.h>
#include<string.h>
#include<unistd.h>
#include<signal.h>
#include<X11/Xlib.h>
#define LENGTH(X)               (sizeof(X) / sizeof (X[0]))
#define CMDLENGTH		50

// Declare the global log file handle
FILE *log_file = NULL;
void cleanup(void);


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


void replace(char *str, char old, char new)
{
	int N = strlen(str);
	for(int i = 0; i < N; i++)
		if(str[i] == old)
			str[i] = new;
}

void remove_all(char *str, char to_remove) {
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
	const Block *current;
	for (int i = 0; i < LENGTH(blocks); i++)
	{
		current = blocks + i;
		if (current->signal == signal)
			getcmd(current,statusbar[i]);
	}
}

void setupsignals()
{
	struct sigaction sa;

	for(int i = SIGRTMIN; i <= SIGRTMAX; i++)
		signal(i, SIG_IGN);

	for(int i = 0; i < LENGTH(blocks); i++)
	{
		if (blocks[i].signal > 0)
		{
			signal(SIGRTMIN+blocks[i].signal, sighandler);
			sigaddset(&sa.sa_mask, SIGRTMIN+blocks[i].signal);
		}
	}
	sa.sa_sigaction = buttonhandler;
	sa.sa_flags = SA_SIGINFO;
	sigaction(SIGUSR1, &sa, NULL);
	struct sigaction sigchld_action = {
  		.sa_handler = SIG_DFL,
  		.sa_flags = SA_NOCLDWAIT
	};
	sigaction(SIGCHLD, &sigchld_action, NULL);

}
#endif

int getstatus(char *str, char *last)
{
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
	if (!getstatus(statusstr[0], statusstr[1]))//Only write out if text has changed.
		return;
	printf("%s\n",statusstr[0]);
	fflush(stdout);
}


void statusloop()
{
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
	getsigcmds(signum-SIGRTMIN);
	writestatus();
}

void buttonhandler(int sig, siginfo_t *si, void *ucontext)
{

	if (log_file) {
        fprintf(log_file, "Buttonhandler called\n");
        fprintf(log_file, "sig: %d\n", sig);
        fprintf(log_file, "si->si_value.sival_int: %d\n", si->si_value.sival_int);
        fflush(log_file);
    }
    
    // Extract the button number
    char button[2];
    button[0] = '0' + (si->si_value.sival_int & 0xff);
    button[1] = '\0';

    pid_t process_id = getpid();
    sig = si->si_value.sival_int >> 8;

    if (fork() == 0)
    {
        const Block *current = NULL;
        for (int i = 0; i < LENGTH(blocks); i++)
        {
            if (blocks[i].signal == sig)
            {
                current = &blocks[i];
                break;
            }
        }

        if (current)
        {
            char shcmd[1024];
            snprintf(shcmd, sizeof(shcmd), "%s && kill -%d %d", current->command, current->signal + 34, process_id);

            char *command[] = { "/bin/sh", "-c", shcmd, NULL };
            setenv("BLOCK_BUTTON", button, 1);

            // Log the button number and command
            if (log_file) {
                fprintf(log_file, "Button: %s\n", button);
                fprintf(log_file, "Command: %s\n", shcmd);
                fflush(log_file);
            }

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

    log_file = fopen("/var/log/dwmblocks.log", "a");
    if (log_file == NULL) {
        perror("fopen log file");
        return EXIT_FAILURE;
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
