/*****************************************************************************

 @(#) $RCSfile$ $Name$($Revision$) $Date$

 -----------------------------------------------------------------------------

 Copyright (c) 2001-2007  OpenSS7 Corporation <http://www.openss7.com/>
 Copyright (c) 1997-2000  Brian F. G. Bidulock <bidulock@openss7.org>

 All Rights Reserved.

 This program is free software: you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation, version 3 of the license.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 details.

 You should have received a copy of the GNU General Public License along with
 this program.  If not, see <http://www.gnu.org/licenses/>, or write to the
 Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

 -----------------------------------------------------------------------------

 U.S. GOVERNMENT RESTRICTED RIGHTS.  If you are licensing this Software on
 behalf of the U.S. Government ("Government"), the following provisions apply
 to you.  If the Software is supplied by the Department of Defense ("DoD"), it
 is classified as "Commercial Computer Software" under paragraph 252.227-7014
 of the DoD Supplement to the Federal Acquisition Regulations ("DFARS") (or any
 successor regulations) and the Government is acquiring only the license rights
 granted herein (the license rights customarily provided to non-Government
 users).  If the Software is supplied to any unit or agency of the Government
 other than DoD, it is classified as "Restricted Computer Software" and the
 Government's rights in the Software are defined in paragraph 52.227-19 of the
 Federal Acquisition Regulations ("FAR") (or any successor regulations) or, in
 the cases of NASA, in paragraph 18.52.227-86 of the NASA Supplement to the FAR
 (or any successor regulations).

 -----------------------------------------------------------------------------

 Commercial licensing and support of this software is available from OpenSS7
 Corporation at a fee.  See http://www.openss7.com/

 -----------------------------------------------------------------------------

 Last Modified $Date$ by $Author$

 -----------------------------------------------------------------------------

 $Log$
 *****************************************************************************/

#ident "@(#) $RCSfile$ $Name$($Revision$) $Date$"

static char const ident[] = "$RCSfile$ $Name$($Revision$) $Date$";

#include "ntp-config.h"

#ifndef	lint
static char *rcsid =
    "Header: /xtel/isode/isode/others/ntp/RCS/read_psti.c,v 9.0 1992/06/16 12:42:48 isode Rel";
static char *sccsid = "@(#)read_psti.c	1.1	MS/ACF	89/02/17";
#endif	/* lint */

#if	defined(REFCLOCK) && defined(PSTI)
#define	ERR_RATE	60	/* Repeat errors once an hour */

/*
 * read_psti.c
 *     January 1988 -- orignal by Jeffrey I. Schiller <JIS@BITSY.MIT.EDU>
 *     January 1989 -- QU version by Doug Kingston <DPK@Morgan.COM>
 *
 *   This module facilitates reading a Precision Time Standard, Inc.
 *   WWV radio clock. We assume that clock is configured for 9600 baud,
 *   no parity. Output is accepted in either 24 or 12 hour format.
 *   Time is requested and processed in GMT.
 *
 *   This version is designed to make use of the QU command due to
 *   additional information it provides (like date and flags).
 *   Select is used to prevent hanging in a read when there are
 *   no characters to read.  The line is run in cooked mode to
 *   reduce overhead.
 *
 *   This requires a PSTI ROM revision later 4.01.000 or later.
 *
 *   Routines defined:
 *	init_clock_psti(): Open the tty associated with the clock and
 *			   set its tty mode bits. Returns fd on success
 *			   and -1 on failure.
 *	read_clock_psti(): Reads the clock and returns either 0 on success
 *			   or non-zero on error.  On success, pointers are
 *			   provided to the reference and local time.
 */
#include <stdio.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#if defined(sun)
#include <termio.h>
#endif

#ifdef	DEBUG
extern int debug;
#endif	/* DEBUG */

static int nerrors = 0;
static char clockdata[32];

#define	MIN_READ 13		/* for Rev 4.01.001 */

static double reltime();

#ifdef STANDALONE

#ifndef CLOCKDEV
#define CLOCKDEV "/dev/radioclock"
#endif

#define DEBUG	1
int debug = 1;

main(argc, argv)
	int argc;
	char **argv;
{
	struct timeval *tvp, *otvp;

	debug = argc;
	if (openclock(CLOCKDEV))
		do {
			(void) readclock(&tvp, &otvp);
			sleep(1);
		} while (debug > 1);
	exit(0);
}
#endif	/* STANDALONE */

init_clock_psti(timesource)
	char *timesource;
{
	int cfd;

#ifdef TCSETA
	struct termio tty;
#else
	struct sgttyb tty;
#endif

	if ((cfd = open(timesource, 2)) < 0) {
#ifdef DEBUG
		if (debug)
			perror(timesource);
		else
#endif	/* DEBUG */
			advise(LLOG_EXCEPTIONS, timesource, "can't open ");
		return (-1);
	}

	if (ioctl(cfd, TIOCEXCL, 0) < 0) {
#ifdef DEBUG
		if (debug)
			perror("TIOCEXCL on radioclock failed");
		else
#endif	/* DEBUG */
			advise(LLOG_EXCEPTIONS, timesource, "TIOCEXCL on ");
		return (-1);
	}
#ifdef TCSETA
	if (ioctl(cfd, TCGETA, &tty) < 0) {
#ifdef DEBUG
		if (debug)
			perror("ioctl on radioclock failed");
		else
#endif	/* DEBUG */
			advise(LLOG_EXCEPTIONS, timesource, "ioctl on failed on");
		return (-1);
	}
	tty.c_cflag = (B9600 << 16) | B9600 | CS8 | CLOCAL | CREAD;
	tty.c_iflag = ICRNL;
	tty.c_oflag = 0;
	tty.c_lflag = 0;
	bzero((char *) tty.c_cc, sizeof tty.c_cc);
	tty.c_cc[VMIN] = MIN_READ;
	tty.c_cc[VTIME] = 0;
	if (ioctl(cfd, TCSETA, &tty) < 0) {
#else	/* TCSETA */			/* Use older Berkeley style IOCTL's */
	bzero((char *) &tty, sizeof tty);
	tty.sg_ispeed = tty.sg_ospeed = B9600;
	tty.sg_flags = ANYP | CRMOD;
	tty.sg_erase = tty.sg_kill = '\0';
	if (ioctl(cfd, TIOCSETP, &tty) < 0) {
#endif	/* TCSETA */
#ifdef DEBUG
		if (debug)
			perror("ioctl on radioclock failed");
		else
#endif	/* DEBUG */
			advise(LLOG_EXCEPTIONS, timesource, "ioctl failed on");
		return (-1);
	}
	if (write(cfd, "xxxxxxsn\r", 9) != 9) {
#ifdef DEBUG
		if (debug)
			perror("init write to radioclock failed");
		else
#endif	/* DEBUG */
			advise(LLOG_EXCEPTIONS, timesource, "init write to ");
		return (-1);
	}
	return (cfd);		/* Succeeded in opening the clock */
}

/*
 * read_clock_psti() -- Read the PSTI Radio Clock.
 */
read_clock_psti(cfd, tvpp, otvpp)
	int cfd;
	struct timeval **tvpp, **otvpp;
{
	static struct timeval radiotime;
	static struct timeval mytime;
	struct timeval timeout;
	struct tm *mtm;
	struct tm radio_tm, *rtm = &radio_tm;
	register int i;
	register int millis;
	register double diff;
	int stat1, stat2;
	fd_set readfds;
	char message[256];

#ifndef TCSETA
	register char *cp;
	int need;
#endif	/* TCSETA */

	FD_ZERO(&readfds);
	FD_SET(cfd, &readfds);
	timeout.tv_sec = 2;
	timeout.tv_usec = 0;

	(void) ioctl(cfd, TIOCFLUSH, 0);	/* scrap the I/O queues */

	/* BEGIN TIME CRITICAL CODE SECTION!!!!!! */
	/* EVERY CYCLE FROM THIS POINT OUT ADDS TO THE INACCURACY OF THE READ CLOCK VALUE!!!!! */
	if (write(cfd, "\003qu0000", 7) != 7) {
#ifdef DEBUG
		if (debug)
			(void) printf("radioclock write failed\n");
		else
#endif	/* DEBUG */
		if ((nerrors++ % ERR_RATE) == 0)
			advise(LLOG_EXCEPTIONS, "failed", "write to radioclock");
		return (1);
	}
	if (select(cfd + 1, &readfds, 0, 0, &timeout) != 1) {
#ifdef DEBUG
		if (debug)
			(void) printf("radioclock poll timed out\n");
		else
#endif	/* DEBUG */
		if ((nerrors++ % ERR_RATE) == 0)
			advise(LLOG_EXCEPTIONS, "failed", "poll of radioclock failed");
		return (1);
	}
	if ((i = read(cfd, clockdata, sizeof clockdata)) < MIN_READ) {
#ifdef DEBUG
		if (debug)
			(void) printf("radioclock read error (%d)\n", i);
		else
#endif	/* DEBUG */
		if ((nerrors++ % ERR_RATE) == 0)
			advise(LLOG_EXCEPTIONS, "failed", "radioclock read (%d<%d)", i, MIN_READ);
		return (1);
	}

	(void) gettimeofday(&mytime, (struct timezone *) 0);
	/* END OF TIME CRITICAL CODE SECTION!!!! */

	if (clockdata[i - 1] != '\n') {
#ifdef DEBUG
		if (debug)
			(void) printf("radioclock format error1 (%.12s)(0x%x)\n",
				      clockdata, clockdata[12]);
		else
#endif	/* DEBUG */
		if ((nerrors++ % ERR_RATE) == 0)
			advise(LLOG_EXCEPTIONS, NULLCP,
			       "radioclock format error1 (%.12s)(0x%x)", clockdata, clockdata[12]);
		return (1);
	}
	for (i = 0; i < 12; i++) {
		if (clockdata[i] < '0' || clockdata[i] > 'o') {
#ifdef DEBUG
			if (debug)
				(void) printf("radioclock format error2\n");
			else
#endif	/* DEBUG */
			if ((nerrors++ % ERR_RATE) == 0)
				advise(LLOG_EXCEPTIONS, NULLCP, "radioclock format error2\n");
			return (1);
		}
	}
	stat1 = clockdata[0] - '0';
	stat2 = clockdata[1] - '0';
	millis = ((clockdata[2] - '0') * 64) + (clockdata[3] - '0');
	rtm->tm_sec = (clockdata[4] - '0');
	rtm->tm_min = (clockdata[5] - '0');
	rtm->tm_hour = (clockdata[6] - '0');
	rtm->tm_yday = ((clockdata[7] - '0') * 64) + (clockdata[8] - '0') - 1;
	rtm->tm_year = 86 + (clockdata[9] - '0');
	/* byte 10 and 11 reserved */

	/* 
	 * Correct "hours" based on whether or not AM/PM mode is enabled.
	 * If clock is in 24 hour (military) mode then no correction is
	 * needed.
	 */
	if (stat2 & 0x10) {	/* Map AM/PM time to Military */
		if (stat2 & 0x8) {
			if (rtm->tm_hour != 12)
				rtm->tm_hour += 12;
		} else {
			if (rtm->tm_hour == 12)
				rtm->tm_hour = 0;
		}
	}

	if (stat1 != 0x4 && (nerrors++ % ERR_RATE) == 0) {
#ifdef DEBUG
		if (debug)
			(void) printf("radioclock fault #%d 0x%x:%s%s%s%s%s%s\n",
				      nerrors, stat1,
				      stat1 & 0x20 ? " Out of Spec," : "",
				      stat1 & 0x10 ? " Hardware Fault," : "",
				      stat1 & 0x8 ? " Signal Fault," : "",
				      stat1 & 0x4 ? " Time Avail," : "",
				      stat1 & 0x2 ? " Year Mismatch," : "",
				      stat1 & 0x1 ? " Clock Reset," : "");
		else {
#endif	/* DEBUG */
			(void) sprintf(message, "radioclock fault #%d 0x%x:%s%s%s%s%s%s\n",
				       nerrors, stat1,
				       stat1 & 0x20 ? " Out of Spec," : "",
				       stat1 & 0x10 ? " Hardware Fault," : "",
				       stat1 & 0x8 ? " Signal Fault," : "",
				       stat1 & 0x4 ? " Time Avail," : "",
				       stat1 & 0x2 ? " Year Mismatch," : "",
				       stat1 & 0x1 ? " Clock Reset," : "");
			advise(LLOG_EXCEPTIONS, NULLCP, "%s", message);
		}
	}
	if (stat1 & 0x38)	/* Out of Spec, Hardware Fault, Signal Fault */
		return (1);
	if ((millis > 999 || rtm->tm_sec > 60 || rtm->tm_min > 60 ||
	     rtm->tm_hour > 23 || rtm->tm_yday > 365) && (nerrors++ % ERR_RATE) == 0) {
#ifdef DEBUG
		if (debug)
			(void) printf("radioclock bogon #%d: %dd %dh %dm %ds %dms\n",
				      nerrors, rtm->tm_yday, rtm->tm_hour,
				      rtm->tm_min, rtm->tm_sec, millis);
		else
#endif	/* DEBUG */
			(void) sprintf(message,
				       "radioclock bogon #%d: %dd %dh %dm %ds %dms\n",
				       nerrors, rtm->tm_yday, rtm->tm_hour,
				       rtm->tm_min, rtm->tm_sec, millis);
		advise(LLOG_EXCEPTIONS, NULLCP, "%s", message);
		return (1);
	}

	mtm = gmtime(&mytime.tv_sec);
	diff = reltime(rtm, millis * 1000) - reltime(mtm, mytime.tv_usec);
#ifdef DEBUG
	if (debug > 1)
		(void) printf("Clock time:  19%d day %03d %02d:%02d:%02d.%03d diff %.3f\n",
			      rtm->tm_year, rtm->tm_yday, rtm->tm_hour,
			      rtm->tm_min, rtm->tm_sec, millis, diff);
#endif	/* DEBUG */

	if (diff > (90 * 24 * 60 * 60.0) && (nerrors++ % ERR_RATE) == 0) {
#ifdef DEBUG
		if (debug)
			(void) printf("offset excessive (system 19%d/%d, clock 19%d/%d)\n",
				      mtm->tm_year, mtm->tm_yday, rtm->tm_year, mtm->tm_yday);
		else
#endif	/* DEBUG */
			advise(LLOG_EXCEPTIONS, NULLCP,
			       "offset excessive (system 19%d/%d, clock 19%d/%d)\n",
			       mtm->tm_year, mtm->tm_yday, rtm->tm_year, mtm->tm_yday);
		return (1);
	}

	diff += (double) mytime.tv_sec + ((double) mytime.tv_usec / 1000000.0);
	radiotime.tv_sec = diff;
	radiotime.tv_usec = (diff - (double) radiotime.tv_sec) * 1000000;
#ifdef DEBUG
	if (debug > 1) {
		(void) printf("System time: 19%d day %03d %02d:%02d:%02d.%03d\n",
			      mtm->tm_year, mtm->tm_yday, mtm->tm_hour,
			      mtm->tm_min, mtm->tm_sec, mytime.tv_usec / 1000);
		(void) printf("stat1 0%o, stat2 0%o: ", stat1, stat2);
		if (stat1 || stat2)
			(void) printf("%s%s%s%s%s%s%s%s%s%s%s%s",
				      stat1 & 0x20 ? " Out of Spec," : "",
				      stat1 & 0x10 ? " Hardware Fault," : "",
				      stat1 & 0x8 ? " Signal Fault," : "",
				      stat1 & 0x4 ? " Time Avail," : "",
				      stat1 & 0x2 ? " Year Mismatch," : "",
				      stat1 & 0x1 ? " Clock Reset," : "",
				      stat2 & 0x20 ? " DST on," : "",
				      stat2 & 0x10 ? " 12hr mode," : "",
				      stat2 & 0x8 ? " PM," : "",
				      stat2 & 0x4 ? " Spare?," : "",
				      stat2 & 0x2 ? " DST??? +1," : "",
				      stat2 & 0x1 ? " DST??? -1," : "");
		(void) printf("\n");
	}
#endif	/* DEBUG */
	/* If necessary, acknowledge "Clock Reset" flag bit */
	if (stat1 & 0x1) {
		if (write(cfd, "si0", 3) != 3) {
#ifdef DEBUG
			if (debug)
				(void) printf("radioclock reset write failed\n");
			else
#endif	/* DEBUG */
				advise(LLOG_EXCEPTIONS, "failed", "reset write to radioclock");
			return (1);
		}
	}
	if (nerrors && stat1 == 0x4) {
		advise(LLOG_NOTICE, NULLCP, "radioclock OK (after %d errors)", nerrors);
		nerrors = 0;
	}
	*tvpp = &radiotime;
	*otvpp = &mytime;
	return (0);
}

static double
reltime(tm, usec)
	register struct tm *tm;
	register int usec;
{
	return (tm->tm_year * (366.0 * 24.0 * 60.0 * 60.0) +
		tm->tm_yday * (24.0 * 60.0 * 60.0) +
		tm->tm_hour * (60.0 * 60.0) + tm->tm_min * (60.0) + tm->tm_sec + usec / 1000000.0);
}
#endif