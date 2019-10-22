/*
 * sdram_test.h
 *
 */

#ifndef SDRAM_TEST_H_
#define SDRAM_TEST_H_

void test_sdram(void);
int MemTestDataBus(unsigned int address);
int MemTestAddressBus(unsigned int memory_base, unsigned int nBytes);
int MemTest8_16BitAccess(unsigned int memory_base);
int MemTestDevice(unsigned int memory_base, unsigned int nBytes);

#endif /* SDRAM_TEST_H_ */
