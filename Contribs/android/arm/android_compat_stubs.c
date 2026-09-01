/* Android compatibility stubs for missing libc functions
 * Add this to your build when linking against libraries compiled
 * for newer API levels than your target.
 */
#include <android/api-level.h>

#if __ANDROID_API__ < 28

/* pthread stubs */
int pthread_atfork(void (*prepare)(void), void (*parent)(void), 
                   void (*child)(void)) { 
    return 0; 
}

/* passwd stubs - curl netrc uses this */
struct passwd;
uid_t getuid(void) { return 0; }
int getpwuid_r(uid_t uid, struct passwd *pwd, char *buf, size_t buflen, 
                 struct passwd **result) { 
    *result = 0;
    return -1; 
}

/* termios stubs - OpenSSL UI uses this */
struct termios;
int tcgetattr(int fd, struct termios *termios_p) { return -1; }
int tcsetattr(int fd, int optional_actions, 
              const struct termios *termios_p) { return -1; }

/* signal stubs */
typedef void (*sighandler_t)(int);
sighandler_t signal(int signum, sighandler_t handler) { return 0; }

#if __ANDROID_API__ < 23
int sigfillset(sigset_t *set) { return 0; }
int sigdelset(sigset_t *set, int signum) { return 0; }
#endif

#endif /* __ANDROID_API__ < 28 */

/* FD_SET_chk - fortification stub */
#if defined(__BIONIC_FORTIFY) || defined(_FORTIFY_SOURCE)
void __FD_SET_chk(int fd, fd_set *set, size_t setsize) {
    if (fd >= 0 && fd < (int)(setsize * 8)) {
        FD_SET(fd, set);
    }
}
#endif
