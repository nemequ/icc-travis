/* LICENSE
 *
 * No license (express or implied, by estoppel or otherwise) to any intellectual property rights is granted by this
 * document.
 *
 * Intel disclaims all express and implied warranties, including without limitation, the implied warranties of
 * merchantability, fitness for a particular purpose, and non-infringement, as well as any warranty arising from
 * course of performance, course of dealing, or usage in trade.
 *
 * This document contains information on products, services and/or processes in development. All information
 * provided here is subject to change without notice. Contact your Intel representative to obtain the latest
 * forecast, schedule, specifications and roadmaps.
 *
 * The products and services described may contain defects or errors which may cause deviations from
 * published specifications.
 *
 * Software and workloads used in performance tests may have been optimized for performance only on Intel
 * microprocessors. Performance tests, such as SYSmark and MobileMark, are measured using specific
 * computer systems, components, software, operations and functions. Any change to any of those factors may
 * cause the results to vary. You should consult other information and performance tests to assist you in fully
 * evaluating your contemplated purchases, including the performance of that product when combined with
 * other products.
 *
 * Cilk, Intel, the Intel logo, Intel Atom, Intel Core, Intel Inside, Intel NetBurst, Intel SpeedStep, Intel vPro,
 * Intel Xeon Phi, Intel XScale, Itanium, MMX, Pentium, Thunderbolt, Ultrabook, VTune and Xeon are
 * trademarks of Intel Corporation in the U.S. and/or other countries.
 *
 * *Other names and brands may be claimed as the property of others.
 *
 * Microsoft, Windows, and the Windows logo are trademarks, or registered trademarks of Microsoft Corporation
 * in the United States and/or other countries.
 *
 * Java is a registered trademark of Oracle and/or its affiliates.
 *
 * Copyright © 2013-2015, Intel Corporation. All rights reserved.
 */

#include <stdio.h>
#include <ipp.h>

int main(int argc, char *argv[])
{
    /* From https://software.intel.com/sites/default/files/managed/a7/15/ipp_userguide_0.pdf, page 19. */

    const IppLibraryVersion *lib;
    IppStatus status;
    Ipp64u mask, emask;

    /* Init IPP library */
    ippInit();

    /* Get IPP library version info */
    lib = ippGetLibVersion();
    printf("%s %s\n", lib->Name, lib->Version);

    return 0;
}
